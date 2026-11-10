package.preload.json = function() return require("dkjson") end
local json = require("json")
local function run(fault)
    local callback, queries, removals, bossSpent, records = nil, 0, 0, false, {}
    local helper = 733
    OUPPoolProbe = {State = function(label) return {label = label, continued = true, enabled = true,
        helper = helper, helperType = 1, realType = 1, helperQuality = 4, realQuality = 4,
        helperTags = 17826048, realTags = 17826048,
        choices = {magicMushroom = false}, run = {seed = 123, settings = {magicMushroom = true}}} end}
    ModCallbacks = {MC_POST_GET_COLLECTIBLE = 1}
    CallbackPriority = {EARLY = -100}
    ItemPoolType = {POOL_TREASURE = 0, POOL_BOSS = 2}
    CollectibleType = {COLLECTIBLE_DADS_NOTE = 668}
    PlayerType = {PLAYER_ISAAC = 0}
    local player = {GetPlayerType = function() return 0 end,
        GetCollectibleNum = function(_, id, trueOnly) assert(trueOnly); return fault == "owned" and id == 12 and 1 or 0 end}
    local pool = {RemoveCollectible = function(_, id)
        assert(id ~= 12 and id ~= helper, "reload fixture must not touch either target identity")
        removals = removals + 1
    end}
    function pool:GetCollectible(poolID, decrease, _, fallback)
        queries = queries + 1
        assert(removals > 0 and fallback == 668)
        local selected = 668
        if poolID == 0 then
            if fault == "reset" then selected = helper elseif fault == "original" then selected = 12 end
        elseif not bossSpent and fault ~= "missing" then selected = helper; if decrease then bossSpent = true end end
        callback(nil, selected, poolID, decrease)
        return selected == helper and 12 or selected
    end
    local game = {Difficulty = 0, GetNumPlayers = function() return 1 end,
        GetSeeds = function() return {GetStartSeed = function() return 123 end} end,
        GetFrameCount = function() return 100 end, GetItemPool = function() return pool end}
    Game = function() return game end
    Isaac = {GetPlayer = function() return player end,
        GetItemConfig = function() return {GetCollectibles = function() return {Size = 734} end} end,
        DebugString = function(line) records[#records + 1] = json.decode(line:sub(10)) end}
    RegisterMod = function() return {AddPriorityCallback = function(_, _, _, fn) callback = fn end,
        RemoveCallback = function(_, _, fn) assert(callback == fn); callback = nil end} end
    local ok = pcall(dofile, "tools/validation/pool-reload-check.lua")
    assert(callback == nil)
    if fault == "owned" then assert(not ok and queries == 0 and removals == 0)
    elseif fault then assert(not ok and records[#records].pass == false)
    else assert(ok and queries == 3 and records[#records].pass) end
end
run(); run("owned"); run("reset"); run("original"); run("missing")
print("reload fixture contracts passed (native restart remains separate)")
