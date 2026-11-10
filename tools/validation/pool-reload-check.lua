-- Two-phase disposable-run check. Archive the unspent Prepare measurement,
-- then save, fully exit and Continue before running the same file to Verify.
local json = require("json")
assert(OUPPoolProbe, "maintained observer missing")
local game, player = Game(), Isaac.GetPlayer(0)
local expectedSeed = 2299138499 -- SVW0 6RZE
assert(game:GetSeeds():GetStartSeed() == expectedSeed, "use seed SVW0 6RZE")
local state = OUPPoolProbe.State("MM_RELOAD_CONTEXT")
local verifying = state.continued == true
assert(state.continued ~= nil and state.enabled == true, "observed On run required")
local label = verifying and "MM_UNSPENT_RELOAD" or "MM_UNSPENT_PREPARE"
OUPPoolProbe.State(label)
assert(state.choices and state.run and state.run.seed == expectedSeed
    and state.run.settings.magicMushroom == true
    and state.choices.magicMushroom == not verifying,
    "expected active On; next-run On for prepare, Off for Continue")
assert(state.helper > 0 and state.helper ~= 12 and state.realType == state.helperType
    and state.realQuality == state.helperQuality and state.realTags == state.helperTags,
    "helper metadata mismatch")
assert(game.Difficulty == 0 and game:GetNumPlayers() == 1
    and player:GetPlayerType() == PlayerType.PLAYER_ISAAC, "one Normal Isaac required")
local realOwned, helperOwned = player:GetCollectibleNum(12, true), player:GetCollectibleNum(state.helper, true)
assert(realOwned == 0 and helperOwned == 0, "ownership would confound pool availability")
local pool, exclusions = game:GetItemPool(), 0
for id = 1, Isaac.GetItemConfig():GetCollectibles().Size - 1 do
    if id ~= 12 and id ~= state.helper then
        pool:RemoveCollectible(id)
        exclusions = exclusions + 1
    end
end
local pools = {
    {name = "treasure", id = ItemPoolType.POOL_TREASURE},
    {name = "boss", id = ItemPoolType.POOL_BOSS},
    {name = "greedTreasure", id = ItemPoolType.POOL_GREED_TREASURE},
    {name = "greedBoss", id = ItemPoolType.POOL_GREED_BOSS},
    {name = "ultraSecret", id = ItemPoolType.POOL_ULTRA_SECRET},
}
local mod, raw = RegisterMod("OUP measured native pool reload check", 1), {}
local function observe(_, selected, selectedPool, decrease)
    raw[#raw + 1] = {selected = selected, pool = selectedPool, decrease = decrease}
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, CallbackPriority.EARLY, observe)
local fallback = CollectibleType.COLLECTIBLE_DADS_NOTE
local function scan(expected)
    local values = {}
    for _, entry in ipairs(pools) do
        values[entry.name] = pool:GetCollectible(entry.id, false, 12099, fallback)
        assert(values[entry.name] == expected, entry.name .. " availability differs")
    end
    return values
end
local before, drawn, after
local ok, failure = pcall(function()
    before = scan(12)
    if verifying then
        drawn = pool:GetCollectible(ItemPoolType.POOL_BOSS, true, 12001, fallback)
        assert(drawn == 12, "Boss draw unavailable")
        after = scan(fallback)
    end
    assert(#raw == (verifying and 11 or 5), "unexpected native call count")
    for index, pick in ipairs(raw) do
        assert(pick.selected == (index <= (verifying and 6 or 5) and state.helper or fallback),
            "unexpected native identity")
    end
end)
mod:RemoveCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, observe)
Isaac.DebugString("OUP_POOL " .. json.encode({kind = verifying and "reload_result" or "reload_anchor",
    label = label, seed = expectedSeed, frame = game:GetFrameCount(), continued = state.continued,
    pass = ok, error = failure, before = before, drawn = drawn, after = after, raw = raw,
    fallback = fallback, realOwned = realOwned, helperOwned = helperOwned,
    otherIdentityExclusions = exclusions, targetIdentitiesUntouched = true}))
assert(ok, failure)
print(verifying and "MM_UNSPENT_RELOAD_PASS" or "MM_RELOAD_READY", #raw, expectedSeed)
