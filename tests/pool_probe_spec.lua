-- Safety/protocol checks for the diagnostic driver, not native weighting proof.
local json = require("dkjson")
package.preload.json = function() return json end
local callbacks, logs, removals, remaining = {}, {}, 0, 1
local continuedCallback, rawCallback
local player = {GetPlayerType = function() return 0 end,
    HasCollectible = function() return false end, GetCollectibleNum = function() return 0 end}
ItemPoolType = {POOL_TREASURE = 0, POOL_BOSS = 3, POOL_GREED_TREASURE = 14,
    POOL_GREED_BOSS = 17, POOL_ULTRA_SECRET = 29}
ModCallbacks = {MC_POST_GAME_STARTED = 15, MC_POST_GET_COLLECTIBLE = 63, MC_PRE_GAME_EXIT = 17}
CallbackPriority = {EARLY = -100}
CollectibleType = {COLLECTIBLE_DADS_NOTE = 668}
PlayerType = {PLAYER_ISAAC = 0}
ModConfigMenu = {Version = 113}
local metadata = {Quality = 4, Tags = 7, Type = 1, Hidden = false}
local helperID = 1001
Isaac = {
    GetItemIdByName = function() return helperID end,
    GetItemConfig = function() return {GetCollectible = function() return metadata end,
        GetCollectibles = function() return {Size = 1002} end} end,
    GetPlayer = function() return player end,
    DebugString = function(line) logs[#logs + 1] = line end,
}
local pool = {RemoveCollectible = function(_, id)
    assert(id ~= 1001); removals = removals + 1
end}
function pool:GetCollectible(_, decrease, seed, fallback)
    if rawCallback then rawCallback(nil, remaining > 0 and 1001 or fallback, 0, decrease, seed) end
    if remaining == 0 then return fallback end
    if decrease then remaining = remaining - 1 end
    return 12
end
Game = function() return {
    GetItemPool = function() return pool end, GetNumPlayers = function() return 1 end,
    GetSeeds = function() return {GetStartSeed = function() return 123 end,
        GetStartSeedString = function() return "AAAA BBBB" end} end,
    GetFrameCount = function() return 10 end, Difficulty = 0,
} end
openUnnerfPack = {Config = {IsEnabled = function() return true end},
    LoadData = function() return '{"settings":{"magicMushroom":true},"run":{"seed":123}}' end}
RegisterMod = function() return {
    AddCallback = function(_, id, fn)
        callbacks[id] = fn
        if id == 15 then continuedCallback = fn end
    end,
    AddPriorityCallback = function(_, id, priority, fn)
        assert(priority == -100); callbacks[id] = fn; rawCallback = fn
    end,
    RemoveCallback = function(_, id, fn) assert(callbacks[id] == fn); callbacks[id] = nil end,
} end
dofile("tools/validation/pool-rule-probe.lua")
OUPPoolProbe.State("contract")
assert(removals == 0, "State must be read-only")
assert(not pcall(OUPPoolProbe.Run, "treasure"), "unobserved start rejected")
assert(removals == 0)
continuedCallback(nil, false)
OUPPoolProbe.Run("treasure", "fresh")
assert(removals == 1000 and remaining == 0)
assert(not pcall(OUPPoolProbe.Run, "treasure"), "no replay against consumed pools")
continuedCallback(nil, true)
local before = removals
OUPPoolProbe.CheckSpent("treasure", "continue")
assert(removals == before, "Continue query must not isolate/deplete again")
assert(rawCallback(nil, 23, 0, false, 42) == nil, "observer cannot alter selections")
OUPPoolProbe.Stop()
assert(OUPPoolProbe == nil and next(callbacks) == nil and removals == before)
assert(#logs > 3)
-- Baseline capture must also work BEFORE the helper/feature is installed.
helperID = 0
pool.RemoveCollectible = function(_, id) assert(id == 12); removals = removals + 1 end
pool.GetCollectible = function(_, _, decrease) assert(decrease == false); return 3 end
dofile("tools/validation/pool-rule-probe.lua")
before = removals
OUPPoolProbe.Fingerprint("BASELINE")
assert(removals == before + 1, "fingerprint excludes only Magic Mushroom")
local last = json.decode(logs[#logs]:match("OUP_POOL (.*)"))
assert(last.kind == "fingerprint_complete" and last.pass and last.pools == 5)
assert(not pcall(OUPPoolProbe.Fingerprint, "REPLAY"), "fresh state required for repeated profile")
OUPPoolProbe.Stop()
print("pool probe protocol passed (Lua doubles; native verification pending)")
