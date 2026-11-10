-- Disposable fresh On run only. Measure native cross-pool depletion without
-- assuming that another entry remains available after the Treasure draw.
local json = require("json")
assert(OUPPoolProbe, "maintained observer missing")
local label = "MM_CROSS_DEPLETION"
local state = OUPPoolProbe.State(label)
local game, player = Game(), Isaac.GetPlayer(0)
assert(state.continued == false and state.enabled == true, "fresh Magic Mushroom On run required")
assert(game.Difficulty == 0 and game:GetNumPlayers() == 1
    and player:GetPlayerType() == PlayerType.PLAYER_ISAAC, "one Normal Isaac required")
assert(state.helper > 0 and state.helper ~= 12, "helper missing")
assert(player:GetCollectibleNum(12, true) == 0 and player:GetCollectibleNum(state.helper, true) == 0,
    "owned items would confound depletion")
local pool = game:GetItemPool()
for id = 1, Isaac.GetItemConfig():GetCollectibles().Size - 1 do
    if id ~= 12 and id ~= state.helper then pool:RemoveCollectible(id) end
end
local pools = {
    {name = "treasure", id = ItemPoolType.POOL_TREASURE},
    {name = "boss", id = ItemPoolType.POOL_BOSS},
    {name = "greedTreasure", id = ItemPoolType.POOL_GREED_TREASURE},
    {name = "greedBoss", id = ItemPoolType.POOL_GREED_BOSS},
    {name = "ultraSecret", id = ItemPoolType.POOL_ULTRA_SECRET},
}
local fallback = CollectibleType.COLLECTIBLE_DADS_NOTE
local mod = RegisterMod("OUP cross-pool depletion measurement", 1)
local raw = {}
local function observe(_, selected, selectedPool, decrease)
    raw[#raw + 1] = {selected = selected, pool = selectedPool, decrease = decrease}
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, CallbackPriority.EARLY, observe)
local function scan()
    local values = {}
    for _, entry in ipairs(pools) do
        values[entry.name] = pool:GetCollectible(entry.id, false, 12099, fallback)
    end
    return values
end
local before, drawn, after
local ok, failure = pcall(function()
    before = scan()
    for _, entry in ipairs(pools) do assert(before[entry.name] == 12, entry.name .. " unavailable before draw") end
    drawn = pool:GetCollectible(ItemPoolType.POOL_TREASURE, true, 12001, fallback)
    assert(drawn == 12, "Treasure draw unavailable")
    after = scan()
    assert(after.treasure == fallback, "Treasure did not deplete")
end)
mod:RemoveCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, observe)
Isaac.DebugString("OUP_POOL " .. json.encode({kind = "cross_depletion", label = label,
    seed = game:GetSeeds():GetStartSeed(), frame = game:GetFrameCount(), continued = state.continued,
    pass = ok, error = failure, before = before, drawn = drawn, after = after, raw = raw,
    fallback = fallback, helper = state.helper, targetIdentitiesUntouched = true}))
assert(ok, failure)
print("MM_CROSS_BEFORE", before.treasure, before.boss, before.greedTreasure, before.greedBoss, before.ultraSecret)
print("MM_CROSS_AFTER", after.treasure, after.boss, after.greedTreasure, after.greedBoss, after.ultraSecret)
