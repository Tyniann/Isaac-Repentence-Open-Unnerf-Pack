-- Frame-driver safety contracts; scripted transitions are not engine evidence.
package.preload.json = function() return require("dkjson") end
local json = require("json")
local function setup(fault)
    OUPPoolGrantProbe = nil
    local frame, real, helper, modifier, callback, records = 0, 0, 0, 0, nil, {}
    local wisp
    ModCallbacks = {MC_POST_PEFFECT_UPDATE = 1}
    CallbackPriority = {LATE = 100}
    PlayerType = {PLAYER_ISAAC = 0}
    OUPPoolProbe = {State = function(label) return {label = label, enabled = true, helper = 733,
        realType = 1, helperType = 1, realQuality = 4, helperQuality = 4,
        realTags = 17826048, helperTags = 17826048} end}
    local player = {InitSeed = 17, Damage = 3.5, MoveSpeed = 1, Position = {},
        Exists = function() return true end, GetPlayerType = function() return 0 end,
        GetMaxHearts = function() return 6 end, GetHearts = function() return 6 end}
    function player:GetCollectibleNum(id, trueOnly)
        if id == 12 then return real end
        assert(id == 733)
        return helper + (trueOnly and 0 or modifier)
    end
    function player:AddCollectible(id)
        assert(id == 733); helper = helper + 1
    end
    function player:AddItemWisp(id)
        assert(id == 733); modifier = 1
        wisp = {SubType = id, alive = true}
        function wisp:Exists() return self.alive end
        function wisp:Remove()
            assert(self.alive); self.alive = false
            if fault ~= "retained_modifier" then modifier = 0 end
        end
        return wisp
    end
    local game = {Difficulty = 0, GetNumPlayers = function() return 1 end,
        GetFrameCount = function() return frame end,
        GetSeeds = function() return {GetStartSeed = function() return 123 end} end}
    Game = function() return game end
    Isaac = {GetPlayer = function() return player end,
        DebugString = function(line) records[#records + 1] = json.decode(line:sub(10)) end}
    RegisterMod = function() return {
        AddPriorityCallback = function(_, _, priority, fn) assert(priority > 0 and not callback); callback = fn end,
        RemoveCallback = function(_, _, fn) assert(callback == fn); callback = nil end,
    } end
    local function tick(convert)
        frame = frame + 1
        -- A scripted post-conversion snapshot, not a reimplementation test.
        if convert then real, helper = real + helper, 0 end
        if callback then callback(nil, {InitSeed = fault == "missing_actor" and 18 or player.InitSeed}) end
    end
    dofile("tools/validation/pool-grant-probe.lua")
    if fault == "timeout" or fault == "missing_actor" then
        for _ = 1, 122 do tick(false) end
        assert(not callback and records[#records].kind == "grant_result" and not records[#records].pass)
        return
    end
    tick(true); tick(true); tick(true)
    assert(not callback and real == 1 and helper == 0 and records[#records].pass)
    OUPPoolGrantProbe.Start(2, true, "MODIFIER")
    for _ = 1, 8 do tick(true) end
    local result = records[#records]
    assert(not callback and real == 3 and helper == 0)
    assert(result.kind == "grant_result" and result.beforeReal == 1 and result.expectedReal == 3)
    if fault == "retained_modifier" then
        assert(modifier == 1 and not result.pass and result.conversionVerified
            and not result.cleanupComplete and result.discardRunRequired)
    else assert(modifier == 0 and result.pass) end
    local sawControl = false
    for _, record in ipairs(records) do
        if record.kind == "modifier_control" then
            assert(record.helperTrue == 0 and record.helperFull == 1 and record.realTrue == 1)
            sawControl = true
        end
    end
    assert(sawControl and wisp and not wisp:Exists())
end
setup()
setup("timeout")
setup("missing_actor")
setup("retained_modifier")
print("grant fixture safety contracts passed (native grants remain separate)")
