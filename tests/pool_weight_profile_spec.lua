-- Intact-pool fixture contracts only; synthetic counts are not native evidence.
package.preload.json = function() return require("dkjson") end
local json = require("json")

local function run(enabled, fault)
    OUPPoolWeightProfile = nil
    local callback, queries, highSeeds, records = nil, 0, 0, {}
    local target = enabled and 733 or 12
    OUPPoolProbe = {State = function(label)
        return {label = label, enabled = enabled, helper = 733, continued = false,
            helperQuality = 4, realQuality = 4, helperTags = 17826048, realTags = 17826048,
            helperType = 1, realType = 1, helperHidden = false, realHidden = false}
    end}
    openUnnerfPack = {Config = {IsEnabled = function() return enabled end}}
    ModCallbacks = {MC_POST_GET_COLLECTIBLE = 1}
    CallbackPriority = {EARLY = -100}
    PlayerType = {PLAYER_ISAAC = 0}
    ItemPoolType = {POOL_TREASURE = 0}
    CollectibleType = {COLLECTIBLE_DADS_NOTE = 668}
    local player = {GetPlayerType = function() return 0 end, HasCollectible = function() return false end}
    local pool = {RemoveCollectible = function() error("profiler must not remove entries") end}
    function pool:GetCollectible(poolID, decrease, seed, fallback)
        assert(poolID == 0 and decrease == false and fallback == 668)
        assert(seed > 0 and seed <= 4294967295)
        queries = queries + 1
        if seed >= 2147483648 then highSeeds = highSeeds + 1 end
        local slot = queries % 64
        local raw
        if fault == "starved" then raw = slot % 2 == 0 and target or 4
        elseif slot < ((enabled or fault == "biased") and 2 or 1) then raw = target
        elseif slot == 2 or slot == 3 then raw = 4
        else raw = 100 + queries % 61 end
        callback(nil, raw)
        return raw == 733 and 12 or raw
    end
    local game = {Difficulty = 0, GetNumPlayers = function() return 1 end,
        GetSeeds = function() return {GetStartSeed = function() return 123 end} end,
        GetFrameCount = function() return 18 end, GetItemPool = function() return pool end}
    Game = function() return game end
    Isaac = {GetPlayer = function() return player end,
        GetItemConfig = function() return {GetCollectible = function(_, id)
            assert(id == 4)
            return {Quality = fault == "metadata" and 3 or 4, Type = 1, Hidden = false}
        end} end,
        DebugString = function(line) records[#records + 1] = json.decode(line:sub(10)) end}
    RegisterMod = function() return {
        AddPriorityCallback = function(_, _, _, fn) assert(callback == nil); callback = fn end,
        RemoveCallback = function(_, _, fn) assert(callback == fn); callback = nil end,
    } end
    local ok, failure = pcall(dofile, "tools/validation/pool-weight-profile.lua")
    assert(callback == nil, "callback cleanup required")
    if fault == "metadata" then assert(not ok and queries == 0); return end
    if fault == "starved" then
        assert(not ok and records[#records].pass == false)
        assert(tostring(failure):find("pool is restricted", 1, true))
        local before = queries
        assert(not pcall(OUPPoolWeightProfile.ReviewPilot, "MM_OFF_FULL_WEIGHT_PILOT"))
        assert(not pcall(OUPPoolWeightProfile.Run, 262144, "BLOCKED"))
        assert(queries == before, "failed pilot must block a full profile")
        return
    end
    assert(ok, tostring(failure))
    assert(records[#records].pilot and records[#records].pass and records[#records].zScore == nil)
    local before = queries
    assert(not pcall(OUPPoolWeightProfile.Run, 262144, "UNREVIEWED"))
    assert(queries == before, "pilot warnings must be reviewed before broad sampling")
    OUPPoolWeightProfile.ReviewPilot(enabled and "MM_ON_FULL_WEIGHT_PILOT" or "MM_OFF_FULL_WEIGHT_PILOT")
    local fullOK, fullFailure = pcall(OUPPoolWeightProfile.Run, 262144, "FULL")
    assert(callback == nil and highSeeds * 2 == queries)
    local result = records[#records]
    assert(result.samples == 262144 and result.focal >= 256 and result.distinctOther >= 32)
    if fault == "biased" then
        assert(not fullOK and result.pass == false)
        assert(tostring(fullFailure):find("relative weighting differs", 1, true))
    else
        assert(fullOK and result.pass and math.abs(result.zScore) <= 4, tostring(fullFailure))
    end
    before = queries
    assert(not pcall(OUPPoolWeightProfile.Run, 262144, "REPEAT"))
    assert(queries == before, "a reviewed pilot permits only one full attempt")
end

run(false)
run(true)
run(false, "metadata")
run(false, "starved")
run(false, "biased")
print("intact-pool profiler contracts passed (native pilot remains separate)")
