-- Explicit disposable-run fixture. Does not install or restart anything.
-- Leaves only Magic Mushroom and a verified Weight-1 reference, samples without
-- decreasing weights, then removes the reference and consumes Magic Mushroom.
-- The finite rate check corroborates the exact XML values; it does not expose
-- raw native descriptors or prove arbitrary floating-point weights by itself.
local json = require("json")
assert(OUPPoolProbe, "load the maintained pool observer first")
local enabled = openUnnerfPack.Config.IsEnabled("magicMushroom")
local label = enabled and "MM_ON_TREASURE_WEIGHT_U32" or "MM_OFF_TREASURE_WEIGHT_U32"
local state = OUPPoolProbe.State(label)
local game, reference, samples = Game(), 4, 4096
local fallback = CollectibleType.COLLECTIBLE_DADS_NOTE
assert(state.continued == false, "use an observed fresh disposable run")
assert(game.Difficulty == 0 and game:GetNumPlayers() == 1, "one Normal Isaac required")
local player = Isaac.GetPlayer(0)
assert(player:GetPlayerType() == PlayerType.PLAYER_ISAAC, "use Isaac")
assert(not player:HasCollectible(12, true) and not player:HasCollectible(state.helper, true)
    and not player:HasCollectible(reference, true), "start without either test item")
assert(state.helper > 0 and state.helperQuality == state.realQuality
    and state.helperTags == state.realTags and state.helperType == state.realType
    and state.realQuality == 4 and state.realType == 1
    and state.realHidden == false and state.helperHidden == false, "Magic Mushroom metadata mismatch")
local config = Isaac.GetItemConfig():GetCollectible(reference)
assert(config and config.Quality == 4 and config.Type == 1 and config.Hidden == false,
    "reference metadata differs; stop before pool mutation")

local function record(kind, fields)
    fields.kind, fields.label = kind, label
    fields.seed, fields.frame = game:GetSeeds():GetStartSeed(), game:GetFrameCount()
    fields.continued = state.continued
    Isaac.DebugString("OUP_POOL " .. json.encode(fields))
end

-- Current checksum-verified repentance.a: Cricket's Head (4) is a quality-4
-- passive with Treasure Weight 1 / DecreaseBy 1 / RemoveOn 0.1. Same-ID trinkets
-- are unrelated. The source record evidence is in the feature's testing ledger.
local target = enabled and state.helper or 12
local pool = game:GetItemPool()
for id = 1, Isaac.GetItemConfig():GetCollectibles().Size - 1 do
    if id ~= target and id ~= reference then pool:RemoveCollectible(id) end
end

local mod = RegisterMod("OUP disposable Treasure weight check", 1)
local phase, nativeTarget, nativeReference, nativeOther = "weight", 0, 0, 0
local function nativePick(_, selected, selectedPool, decrease, seed)
    if phase == "weight" then
        if selected == target then nativeTarget = nativeTarget + 1
        elseif selected == reference then nativeReference = nativeReference + 1
        else nativeOther = nativeOther + 1 end
    else
        record("native_pick", {selected = selected, pool = selectedPool,
            decrease = decrease, pickSeed = seed})
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, CallbackPriority.EARLY, nativePick)
local targetCount, referenceCount, output, after = 0, 0, nil, nil
local lowerTarget, lowerReference, upperTarget, upperReference = 0, 0, 0, 0
local expectedRate = enabled and 0.5 or 1 / 3
local tolerance = 0.03
local ok, failure = pcall(function()
    for index = 1, samples / 2 do
        -- Pair each fixed lower-half seed with its upper-half counterpart.
        -- Sampling only positive signed-32-bit seeds leaves half the native
        -- seed domain untested. Zero is excluded because it requests a seed.
        local base = (index * 2654435761) % 2147483647 + 1
        for _, seed in ipairs({base, base + 2147483648}) do
            local selected = pool:GetCollectible(ItemPoolType.POOL_TREASURE, false, seed, fallback)
            assert(selected == 12 or selected == reference, "unexpected item; preserve log and stop")
            if selected == 12 then
                targetCount = targetCount + 1
                if seed < 2147483648 then lowerTarget = lowerTarget + 1 else upperTarget = upperTarget + 1 end
            else
                referenceCount = referenceCount + 1
                if seed < 2147483648 then lowerReference = lowerReference + 1 else upperReference = upperReference + 1 end
            end
        end
    end
    local observedRate = targetCount / samples
    record("weight_sample", {samples = samples, reference = reference, nativeIdentity = target,
        targetCount = targetCount, referenceCount = referenceCount,
        expectedRate = expectedRate, observedRate = observedRate, tolerance = tolerance,
        declaredTargetWeight = enabled and 1 or 0.5, referenceWeight = 1,
        nativeTarget = nativeTarget, nativeReference = nativeReference, nativeOther = nativeOther,
        seedDomain = "paired_uint32_halves", lowerTarget = lowerTarget, lowerReference = lowerReference,
        upperTarget = upperTarget, upperReference = upperReference})
    assert(nativeOther == 0 and nativeTarget == targetCount and nativeReference == referenceCount,
        "native identities do not match the two-entry fixture")
    assert(math.abs(observedRate - expectedRate) <= tolerance,
        "relative weighting differs; preserve log and stop")
    pool:RemoveCollectible(reference)
    phase = "depletion"
    output = pool:GetCollectible(ItemPoolType.POOL_TREASURE, true, 12001, fallback)
    after = pool:GetCollectible(ItemPoolType.POOL_TREASURE, false, 12099, fallback)
    assert(output == 12 and after == fallback, "expected one Magic Mushroom draw then fallback")
end)
mod:RemoveCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, nativePick)
record("weight_result", {pass = ok, error = failure, samples = samples, targetCount = targetCount,
    referenceCount = referenceCount, expectedRate = expectedRate, tolerance = tolerance,
    nativeIdentity = target, nativeTarget = nativeTarget, nativeOther = nativeOther,
    output = output, after = after, fallback = fallback, seedDomain = "paired_uint32_halves",
    lowerTarget = lowerTarget, lowerReference = lowerReference,
    upperTarget = upperTarget, upperReference = upperReference})
assert(ok, failure)
print("MM_WEIGHT_PASS", enabled and "On" or "Off", targetCount, referenceCount, output, after)
-- All other entries were removed. Use a fresh run before any next pool check.
