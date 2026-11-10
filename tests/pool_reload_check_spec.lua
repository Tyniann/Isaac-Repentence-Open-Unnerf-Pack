package.preload.json = function() return require("dkjson") end
local json = require("json")
local function run(continued, fault)
    local callback, queries, removals, spent, records = nil, 0, 0, false, {}
    local seed, helper = 2299138499, 733
    local choice = not continued
    if fault == "choice" then choice = continued end
    OUPPoolProbe = {State = function() return {continued = continued, enabled = true,
        helper = helper, helperType = 1, realType = 1, helperQuality = 4, realQuality = 4,
        helperTags = 17826048, realTags = 17826048,
        choices = {magicMushroom = choice},
        run = {seed = seed, settings = {magicMushroom = true}}} end}
    ModCallbacks = {MC_POST_GET_COLLECTIBLE = 1}
    CallbackPriority = {EARLY = -100}
    ItemPoolType = {POOL_TREASURE = 0, POOL_BOSS = 2, POOL_GREED_TREASURE = 16,
        POOL_GREED_BOSS = 17, POOL_ULTRA_SECRET = 24}
    CollectibleType = {COLLECTIBLE_DADS_NOTE = 668}
    PlayerType = {PLAYER_ISAAC = 0}
    local player = {GetPlayerType = function() return 0 end,
        GetCollectibleNum = function(_, id, trueOnly) assert(trueOnly); return fault == "owned" and id == 12 and 1 or 0 end}
    local pool = {RemoveCollectible = function(_, id)
        assert(id ~= 12 and id ~= helper, "fixture must not touch either target identity")
        removals = removals + 1
    end}
    function pool:GetCollectible(poolID, decrease, _, fallback)
        queries = queries + 1
        local selected = spent and fallback or helper
        if fault == "missing" and poolID == 2 then selected = fallback end
        if fault == "duplicate" and spent then selected = helper end
        if fault == "original" then selected = 12 end
        callback(nil, selected, poolID, decrease)
        if decrease then assert(continued and poolID == 2 and not spent); spent = true end
        return selected == helper and 12 or selected
    end
    Game = function() return {Difficulty = 0, GetNumPlayers = function() return 1 end,
        GetSeeds = function() return {GetStartSeed = function() return fault == "seed" and 123 or seed end} end,
        GetFrameCount = function() return 100 end, GetItemPool = function() return pool end} end
    Isaac = {GetPlayer = function() return player end,
        GetItemConfig = function() return {GetCollectibles = function() return {Size = 734} end} end,
        DebugString = function(line) records[#records + 1] = json.decode(line:sub(10)) end}
    RegisterMod = function() return {AddPriorityCallback = function(_, _, _, fn) callback = fn end,
        RemoveCallback = function(_, _, fn) assert(callback == fn); callback = nil end} end
    local ok = pcall(dofile, "tools/validation/pool-reload-check.lua")
    assert(callback == nil)
    if fault == "owned" or fault == "choice" or fault == "seed" then
        assert(not ok and queries == 0 and removals == 0)
    elseif fault then assert(not ok and records[#records].pass == false)
    else
        assert(ok and queries == (continued and 11 or 5) and records[#records].pass)
        assert(spent == continued, "prepare must not consume the measured entry")
    end
end
run(false); run(true)
for _, fault in ipairs({"owned", "choice", "seed", "missing", "original"}) do run(false, fault); run(true, fault) end
run(true, "duplicate")
print("measured reload fixture contracts passed (native process boundary remains separate)")
