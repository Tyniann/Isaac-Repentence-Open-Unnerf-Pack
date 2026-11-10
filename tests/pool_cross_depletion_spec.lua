package.preload.json = function() return require("dkjson") end
local json = require("json")
local function run(globalDepletion, missingBefore)
    local callback, spent, removed, records = nil, false, 0, {}
    OUPPoolProbe = {State = function() return {continued = false, enabled = true, helper = 733} end}
    PlayerType = {PLAYER_ISAAC = 0}
    ItemPoolType = {POOL_TREASURE = 0, POOL_BOSS = 2, POOL_GREED_TREASURE = 16,
        POOL_GREED_BOSS = 17, POOL_ULTRA_SECRET = 24}
    ModCallbacks = {MC_POST_GET_COLLECTIBLE = 1}
    CallbackPriority = {EARLY = -100}
    CollectibleType = {COLLECTIBLE_DADS_NOTE = 668}
    local pool = {RemoveCollectible = function(_, id)
        assert(id ~= 12 and id ~= 733)
        removed = removed + 1
    end}
    function pool:GetCollectible(poolID, decrease, _, fallback)
        local selected = (missingBefore and poolID == 2 or spent and (globalDepletion or poolID == 0)) and fallback or 733
        callback(nil, selected, poolID, decrease)
        if decrease then assert(poolID == 0 and not spent); spent = true end
        return selected == 733 and 12 or selected
    end
    Game = function() return {Difficulty = 0, GetNumPlayers = function() return 1 end,
        GetSeeds = function() return {GetStartSeed = function() return 123 end} end,
        GetFrameCount = function() return 20 end, GetItemPool = function() return pool end} end
    Isaac = {GetPlayer = function() return {GetPlayerType = function() return 0 end,
        GetCollectibleNum = function(_, _, trueOnly) assert(trueOnly); return 0 end} end,
        GetItemConfig = function() return {GetCollectibles = function() return {Size = 734} end} end,
        DebugString = function(line) records[#records + 1] = json.decode(line:sub(10)) end}
    RegisterMod = function() return {AddPriorityCallback = function(_, _, _, fn) callback = fn end,
        RemoveCallback = function(_, _, fn) assert(callback == fn); callback = nil end} end
    local ok = pcall(dofile, "tools/validation/pool-cross-depletion.lua")
    local result = records[#records]
    assert(callback == nil and removed == 731)
    if missingBefore then assert(not ok and not result.pass and not spent)
    else
        assert(ok and result.pass and #result.raw == 11 and result.before.boss == 12)
        assert(result.after.treasure == 668 and result.after.boss == (globalDepletion and 668 or 12))
    end
end
run(false); run(true); run(false, true)
print("cross-pool measurement contracts passed (not native depletion evidence)")
