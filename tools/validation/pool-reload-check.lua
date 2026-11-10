-- HISTORICAL FAILED RECIPE: do not run again without a measured Boss baseline.
-- The assumption that Boss was unspent before saving was not established.
-- Continue the previously tested On run after a verified full process exit.
-- Re-isolate NON-target identities only. Neither Magic Mushroom identity is
-- removed, added or reset, so both saved depletion and an unspent entry matter.
local json = require("json")
assert(OUPPoolProbe, "maintained observer missing")
local label = "MM_FULL_PROCESS_RELOAD"
local state = OUPPoolProbe.State(label)
local game = Game()
assert(state.continued == true and state.enabled == true, "Continue the tested On run")
assert(state.choices and state.choices.magicMushroom == false and state.run
    and state.run.settings.magicMushroom == true and state.run.seed == game:GetSeeds():GetStartSeed(),
    "expected next-run Off and saved-run On")
assert(state.helper > 0 and state.helper ~= 12 and state.realType == state.helperType
    and state.realQuality == state.helperQuality and state.realTags == state.helperTags,
    "helper metadata mismatch")
local player = Isaac.GetPlayer(0)
assert(game.Difficulty == 0 and game:GetNumPlayers() == 1
    and player:GetPlayerType() == PlayerType.PLAYER_ISAAC, "one Normal Isaac required")
local realOwned, helperOwned = player:GetCollectibleNum(12, true), player:GetCollectibleNum(state.helper, true)
assert(realOwned == 0 and helperOwned == 0, "ownership would confound saved depletion")
local pool, exclusions = game:GetItemPool(), 0
for id = 1, Isaac.GetItemConfig():GetCollectibles().Size - 1 do
    if id ~= 12 and id ~= state.helper then
        pool:RemoveCollectible(id)
        exclusions = exclusions + 1
    end
end
local mod = RegisterMod("OUP saved target-pool check", 1)
local raw = {}
local function nativePick(_, selected, selectedPool, decrease)
    raw[#raw + 1] = {selected = selected, pool = selectedPool, decrease = decrease}
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, CallbackPriority.EARLY, nativePick)
local fallback = CollectibleType.COLLECTIBLE_DADS_NOTE
local spent, available, after
local ok, failure = pcall(function()
    spent = pool:GetCollectible(ItemPoolType.POOL_TREASURE, false, 12099, fallback)
    assert(spent == fallback, "spent Treasure target or excluded original reappeared")
    available = pool:GetCollectible(ItemPoolType.POOL_BOSS, true, 12001, fallback)
    assert(available == 12, "previously unspent Boss target unavailable")
    after = pool:GetCollectible(ItemPoolType.POOL_BOSS, false, 12099, fallback)
    assert(after == fallback, "Boss target did not deplete once")
    assert(#raw == 3 and raw[1].selected == fallback and raw[2].selected == state.helper
        and raw[3].selected == fallback, "native target identities differ")
end)
mod:RemoveCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, nativePick)
Isaac.DebugString("OUP_POOL " .. json.encode({kind = "reload_result", label = label,
    seed = game:GetSeeds():GetStartSeed(), frame = game:GetFrameCount(), continued = state.continued,
    pass = ok, error = failure, treasureSpent = spent, bossAvailable = available, bossAfter = after,
    fallback = fallback, raw = raw, realOwned = realOwned, helperOwned = helperOwned,
    otherIdentityExclusions = exclusions, targetIdentitiesUntouched = true}))
assert(ok, failure)
print("MM_RELOAD_PASS", spent, available, after)
