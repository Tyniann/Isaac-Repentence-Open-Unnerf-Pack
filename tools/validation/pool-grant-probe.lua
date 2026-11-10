-- Explicit disposable-run grants. No saves/settings, pool edits or restarts.
-- Loading starts one actual helper-copy pilot. Close the console to advance;
-- Status reports completion. A later Start can test two copies plus a modifier.
assert(OUPPoolGrantProbe == nil, "grant probe loaded; use Start or Status")
assert(OUPPoolProbe, "load the maintained pool observer first")
assert(CallbackPriority and type(CallbackPriority.LATE) == "number" and CallbackPriority.LATE > 0,
    "late callback priority unavailable; stop before granting")
local json = require("json")
local mod = RegisterMod("OUP disposable helper grant check", 1)
local probe, active, result = {}, nil, nil
OUPPoolGrantProbe = probe
local tick

local function counts(a)
    local player = a.player
    if not player:Exists() then return {actorMissing = true} end
    return {realTrue = player:GetCollectibleNum(12, true), realFull = player:GetCollectibleNum(12, false),
        helperTrue = player:GetCollectibleNum(a.helper, true), helperFull = player:GetCollectibleNum(a.helper, false),
        damage = player.Damage, speed = player.MoveSpeed, maxHearts = player:GetMaxHearts(), hearts = player:GetHearts()}
end
local function record(a, kind, fields)
    fields.kind, fields.label, fields.seed = kind, a.label, a.seed
    fields.frame = Game():GetFrameCount()
    Isaac.DebugString("OUP_POOL " .. json.encode(fields))
end
local function finish(ok, failure)
    local a = active
    active = nil
    mod:RemoveCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, tick)
    if a.wisp and a.wisp:Exists() then a.wisp:Remove() end -- Only this fixture's entity.
    local final = counts(a)
    final.pass, final.error = ok, failure
    final.beforeReal, final.copies, final.expectedReal = a.beforeReal, a.copies, a.expected
    final.withModifier, final.helper = a.withModifier, a.helper
    record(a, "grant_result", final)
    result = {label = a.label, pass = ok, counts = final}
end
local function addCopies(a)
    for _ = 1, a.copies do a.player:AddCollectible(a.helper) end
    local state = counts(a)
    record(a, "helper_added", state)
    assert(state.helperTrue == a.copies, "native true-item count differs immediately after grant")
    a.phase, a.stable = "convert", 0
end

tick = function(_, player)
    local a = active
    if not a then return end
    local frame = Game():GetFrameCount()
    if not a.player:Exists() or Game():GetSeeds():GetStartSeed() ~= a.seed or frame < a.startFrame then
        finish(false, "test actor/run changed")
        return
    end
    if frame > a.deadline then
        finish(false, "grant fixture timed out; preserve evidence")
        return
    end
    if player.InitSeed ~= a.actorSeed then return end -- Entity wrappers need not be the same Lua userdata.
    if frame == a.lastFrame then return end
    a.lastFrame = frame
    local ok, failure = pcall(function()
        assert(a.player:Exists() and Game():GetSeeds():GetStartSeed() == a.seed
            and frame >= a.startFrame, "test actor/run changed")
        local state = counts(a)
        assert(state.realTrue <= a.expected, "extra permanent Magic Mushroom copy appeared")
        if a.phase == "modifier" then
            assert(state.realTrue == a.beforeReal, "temporary helper became a permanent item")
            assert(state.helperTrue == 0, "modifier included in native true-item count")
            if state.helperFull == 1 then
                state.wispSubType = a.wisp.SubType
                record(a, "modifier_control", state)
                addCopies(a)
            end
        elseif a.phase == "convert" then
            if state.realTrue == a.expected and state.helperTrue == 0 then
                a.stable = a.stable + 1
                if a.stable >= 2 then
                    assert(state.helperFull == (a.withModifier and 1 or 0), "temporary modifier count changed")
                    record(a, "converted", state)
                    if a.withModifier then
                        a.wisp:Remove()
                        a.phase = "cleanup"
                    else finish(true) end
                end
            else a.stable = 0 end
        elseif a.phase == "cleanup" and state.helperFull == 0 then
            assert(state.realTrue == a.expected and state.helperTrue == 0, "modifier cleanup changed owned counts")
            finish(true)
        end
    end)
    if not ok and active then finish(false, failure) end
end

function probe.Start(copies, withModifier, label)
    assert(not active and (copies == 1 or copies == 2) and type(label) == "string" and label ~= "",
        "use one labeled bounded grant case at a time")
    local state = OUPPoolProbe.State(label)
    assert(state.enabled and state.helper > 0 and state.realType == 1 and state.helperType == 1
        and state.realQuality == state.helperQuality and state.realTags == state.helperTags,
        "enabled matching helper required")
    local game, player = Game(), Isaac.GetPlayer(0)
    assert(game.Difficulty == 0 and game:GetNumPlayers() == 1
        and player:GetPlayerType() == PlayerType.PLAYER_ISAAC and type(player.InitSeed) == "number",
        "one disposable Normal Isaac required")
    local a = {player = player, actorSeed = player.InitSeed, label = label, helper = state.helper, copies = copies,
        seed = game:GetSeeds():GetStartSeed(), startFrame = game:GetFrameCount(),
        lastFrame = game:GetFrameCount(), deadline = game:GetFrameCount() + 120,
        withModifier = withModifier == true}
    local before = counts(a)
    assert(before.helperFull == 0, "start without another helper or helper effect")
    assert(copies == 1 and before.realTrue == 0 or copies == 2 and before.realTrue >= 1,
        "pilot needs zero real copies; multi-copy case needs an existing real copy")
    a.beforeReal, a.expected = before.realTrue, before.realTrue + copies
    active, result = a, nil
    record(a, "grant_before", before)
    mod:AddPriorityCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, CallbackPriority.LATE, tick)
    local ok, failure = pcall(function()
        if a.withModifier then
            a.wisp = player:AddItemWisp(a.helper, player.Position)
            assert(a.wisp and a.wisp:Exists(), "native item-wisp creation failed")
            a.phase = "modifier"
        else addCopies(a) end
    end)
    if not ok then finish(false, failure); error(failure) end
    print("MM_GRANT_PENDING", label)
end

function probe.Status()
    if active then print("MM_GRANT_PENDING", active.label)
    elseif result then
        print(result.pass and "MM_GRANT_PASS" or "MM_GRANT_FAIL", result.label,
            result.counts.realTrue, result.counts.helperTrue, result.counts.helperFull)
    else print("MM_GRANT_IDLE") end
end
function probe.Stop()
    if active then finish(false, "stopped explicitly") end
end

probe.Start(1, false, "MM_GRANT_ONE")
