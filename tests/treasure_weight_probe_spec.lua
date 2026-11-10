-- Fixture safety/protocol only. This does not verify native selection weights.
package.preload.json = function() return require("dkjson") end
local json = require("json")

local function run(enabled, fault)
    local target, callback, removed, records = enabled and 733 or 12, nil, {}, {}
    local queries, weights, spent = 0, 0, false
    OUPPoolProbe = {State = function(label)
        return {label = label, enabled = enabled, helper = 733, continued = false,
            helperQuality = 4, realQuality = 4, helperTags = 17826048,
            realTags = 17826048, helperType = 1, realType = 1,
            helperHidden = false, realHidden = false}
    end}
    openUnnerfPack = {Config = {IsEnabled = function() return enabled end}}
    ModCallbacks = {MC_POST_GET_COLLECTIBLE = 1}
    CallbackPriority = {EARLY = -100}
    PlayerType = {PLAYER_ISAAC = 0}
    ItemPoolType = {POOL_TREASURE = 0}
    CollectibleType = {COLLECTIBLE_DADS_NOTE = 668}
    local player = {GetPlayerType = function() return 0 end,
        HasCollectible = function() return false end}
    local pool = {RemoveCollectible = function(_, id) removed[id] = true end}
    function pool:GetCollectible(_, decrease, seed, fallback)
        queries = queries + 1
        assert(seed > 0 and seed < 2147483648 and fallback == 668)
        local selected
        if fault == "unexpected" then selected = 668
        elseif removed[4] then
            selected = spent and 668 or target
            if decrease then spent = true end
        else
            assert(not decrease, "weight sampling must not consume entries")
            weights = weights + 1
            selected = weights % (enabled and 2 or 3) == 0 and target or 4
        end
        if callback then callback(nil, selected, 0, decrease, seed) end
        return selected == 733 and 12 or selected
    end
    local seeds = {GetStartSeed = function() return 123 end}
    local game = {Difficulty = 0, GetNumPlayers = function() return 1 end,
        GetSeeds = function() return seeds end, GetFrameCount = function() return 18 end,
        GetItemPool = function() return pool end}
    Game = function() return game end
    local items = {GetCollectibles = function() return {Size = 734} end,
        GetCollectible = function(_, id)
            assert(id == 4)
            return {Quality = fault == "metadata" and 3 or 4, Type = 1, Hidden = false}
        end}
    Isaac = {GetPlayer = function() return player end, GetItemConfig = function() return items end,
        DebugString = function(line) records[#records + 1] = json.decode(line:sub(10)) end}
    RegisterMod = function()
        return {AddPriorityCallback = function(_, _, _, fn) callback = fn end,
            RemoveCallback = function(_, _, fn) assert(callback == fn); callback = nil end}
    end
    local ok, message = pcall(dofile, "tools/validation/treasure-weight-probe.lua")
    assert(callback == nil, "diagnostic callback must be removed on pass and failure")
    if fault == "metadata" then
        assert(not ok and next(removed) == nil and queries == 0)
    elseif fault then
        assert(not ok and queries == 1 and records[#records].pass == false, tostring(message))
    else
        assert(ok, tostring(message))
        local result = records[#records]
        assert(result.kind == "weight_result" and result.pass and result.after == 668)
        assert(result.output == 12 and result.samples == 4096)
        assert(result.nativeIdentity == target and result.nativeOther == 0)
        assert(result.nativeTarget == result.targetCount)
        assert(queries == 4098 and removed[4] and not removed[target])
        assert(removed[enabled and 12 or 733], "only the selected identity remains")
    end
end

run(false)
run(true)
run(false, "metadata")
run(true, "unexpected")
print("treasure weight fixture contracts passed (native weighting remains separate)")
