-- Read-only pool sampling for disposable Normal Isaac runs. No pool entries,
-- settings, inventory or run state are added, removed, decreased or reset.
-- Loading runs a small pilot; subsequent Run calls reuse this loaded observer.
assert(OUPPoolWeightProfile == nil, "weight profiler loaded; use its Run method")
assert(OUPPoolProbe, "load the maintained pool observer first")
local json = require("json")
local mod = RegisterMod("OUP intact-pool weight profile", 1)
local profile, busy, pilot = {}, false, nil
OUPPoolWeightProfile = profile

function profile.ReviewPilot(label)
    -- Call only after the archived pilot's native warnings have been reviewed.
    assert(pilot and pilot.label == label and pilot.seed == Game():GetSeeds():GetStartSeed()
        and pilot.enabled == openUnnerfPack.Config.IsEnabled("magicMushroom"),
        "review a successful matching pilot first")
    pilot.reviewed = true
    Isaac.DebugString("OUP_POOL " .. json.encode({kind = "weight_pilot_reviewed", label = label,
        seed = pilot.seed, frame = Game():GetFrameCount()}))
end

function profile.Run(samples, label)
    assert(not busy and (samples == 8192 or samples == 262144), "use a bounded pilot or full profile")
    if samples == 8192 then pilot = nil end -- A failed pilot invalidates any earlier review.
    local enabled = openUnnerfPack.Config.IsEnabled("magicMushroom")
    label = label or (enabled and "MM_ON_FULL_WEIGHT_PILOT" or "MM_OFF_FULL_WEIGHT_PILOT")
    local state = OUPPoolProbe.State(label)
    local game, reference = Game(), 4
    if samples == 262144 then
        assert(pilot and pilot.reviewed and pilot.seed == game:GetSeeds():GetStartSeed()
            and pilot.enabled == enabled, "review a successful matching pilot before the full profile")
        pilot = nil -- Each reviewed pilot authorizes one bounded full attempt.
    end
    assert(state.continued == false and game.Difficulty == 0 and game:GetNumPlayers() == 1,
        "use one fresh disposable Normal Isaac")
    local player = Isaac.GetPlayer(0)
    assert(player:GetPlayerType() == PlayerType.PLAYER_ISAAC, "use Isaac")
    assert(not player:HasCollectible(12, true) and not player:HasCollectible(state.helper, true)
        and not player:HasCollectible(reference, true), "start without either comparison item")
    assert(state.helper > 0 and state.helperQuality == state.realQuality
        and state.helperTags == state.realTags and state.helperType == state.realType
        and state.realQuality == 4 and state.realType == 1
        and state.realHidden == false and state.helperHidden == false, "Magic Mushroom metadata mismatch")
    local referenceConfig = Isaac.GetItemConfig():GetCollectible(reference)
    assert(referenceConfig and referenceConfig.Quality == 4 and referenceConfig.Type == 1
        and referenceConfig.Hidden == false, "reference metadata mismatch")

    local function record(kind, fields)
        fields.kind, fields.label = kind, label
        fields.seed, fields.frame = game:GetSeeds():GetStartSeed(), game:GetFrameCount()
        fields.continued = state.continued
        Isaac.DebugString("OUP_POOL " .. json.encode(fields))
    end
    local target = enabled and state.helper or 12
    local started = type(Isaac.GetTime) == "function" and Isaac.GetTime() or nil
    local targetCount, referenceCount, otherCount, fallbackCount = 0, 0, 0, 0
    local nativeTarget, nativeReference, unexpectedIdentity = 0, 0, 0
    local others, outputs = {}, {}
    local function nativePick(_, selected)
        if selected == target then nativeTarget = nativeTarget + 1
        elseif selected == reference then nativeReference = nativeReference + 1
        elseif selected == 12 or selected == state.helper then unexpectedIdentity = unexpectedIdentity + 1 end
    end
    busy = true
    mod:AddPriorityCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, CallbackPriority.EARLY, nativePick)
    local focal, expected, observed, zScore, distinctOther = 0, enabled and 0.5 or 1 / 3, nil, nil, 0
    local ok, failure = pcall(function()
        local pool = game:GetItemPool()
        for index = 1, samples / 2 do
            local base = (index * 2654435761) % 2147483647 + 1
            for half = 0, 1 do
                local seed = base + half * 2147483648
                local selected = pool:GetCollectible(ItemPoolType.POOL_TREASURE, false, seed,
                    CollectibleType.COLLECTIBLE_DADS_NOTE)
                local key = tostring(selected)
                outputs[key] = (outputs[key] or 0) + 1
                if selected == 12 then targetCount = targetCount + 1
                elseif selected == reference then referenceCount = referenceCount + 1
                else otherCount = otherCount + 1; others[key] = true end
                if selected == CollectibleType.COLLECTIBLE_DADS_NOTE then fallbackCount = fallbackCount + 1 end
            end
        end
        for _ in pairs(others) do distinctOther = distinctOther + 1 end
        assert(otherCount >= samples * 0.9 and distinctOther >= 32,
            "pool is restricted; do not use an isolated or consumed test run")
        assert(unexpectedIdentity == 0 and nativeTarget == targetCount and nativeReference == referenceCount,
            "native identities differ from translated outputs")
        focal = targetCount + referenceCount
        observed = focal > 0 and targetCount / focal or nil
        if samples == 262144 then
            assert(focal >= 256, "insufficient focal samples; preserve profile without claiming weighting")
            zScore = (targetCount - focal * expected) / math.sqrt(focal * expected * (1 - expected))
            -- A finite diagnostic consistency bound, not raw descriptor access
            -- or proof of exact floating-point weights. Exact XML is separate.
            assert(math.abs(zScore) <= 4, "normal-pool relative weighting differs; preserve profile")
        end
    end)
    mod:RemoveCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, nativePick)
    busy = false
    if samples == 8192 and ok then
        pilot = {label = label, seed = game:GetSeeds():GetStartSeed(), enabled = enabled, reviewed = false}
    end
    record("weight_profile", {pass = ok, error = failure, samples = samples, pilot = samples == 8192,
        nativeIdentity = target, reference = reference, targetCount = targetCount, referenceCount = referenceCount,
        otherCount = otherCount, distinctOther = distinctOther, fallbackCount = fallbackCount, outputs = outputs,
        nativeTarget = nativeTarget, nativeReference = nativeReference, unexpectedIdentity = unexpectedIdentity,
        focal = focal, expectedFocalShare = expected, observedFocalShare = observed, zScore = zScore,
        minimumFocal = 256, maximumAbsZ = 4, seedDomain = "paired_uint32_halves",
        elapsedMs = started and (Isaac.GetTime() - started) or nil})
    assert(ok, failure)
    print(samples == 8192 and "MM_WEIGHT_PILOT" or "MM_WEIGHT_RATE_PASS",
        enabled and "On" or "Off", samples, targetCount, referenceCount, otherCount)
end

profile.Run(8192)
