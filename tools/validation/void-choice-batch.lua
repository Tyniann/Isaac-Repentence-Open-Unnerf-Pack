-- Disposable-run native checks for #16. Loading is inert. Run restarts runs,
-- changes rooms, grants Void/option items, and writes only the backed-up pack's
-- next-run Void setting. Discard the final run; Stop restores the original choice.
assert(OUPVoidBatch == nil, "Void batch already loaded")
local json = require("json")
local mod = RegisterMod("OUP Void native batch", 1)
local batch, active, result = {}, nil, nil
local continuation, continueResult, lastContinued
OUPVoidBatch = batch
local C = CollectibleType
local books = {58, 78, 34, 287} -- Repeatable effects without random pickup rewards.
local originalSettings
-- Fixed seed cohorts make original native identities comparable without Morph.
local edgeSeeds = {photos = 212727584, alt = 1344027538}
local edgeDiscovered = {}

local function emit(kind, fields)
    fields = fields or {}
    fields.kind, fields.frame = kind, Game():GetFrameCount()
    fields.label = active and active.label or continuation and "VOID16_CONTINUE" or "idle"
    fields.case = active and active.case and active.case.name or nil
    fields.seed = Game():GetSeeds():GetStartSeed()
    Isaac.DebugString("OUP_VOID_BATCH " .. json.encode(fields))
end
local function saved()
    return openUnnerfPack:HasData() and json.decode(openUnnerfPack:LoadData()) or {version = 1, settings = {}}
end
local function choice(value)
    local data = saved()
    data.settings = data.settings or {}
    data.settings.voidChoiceAbsorption = value
    openUnnerfPack:SaveData(json.encode(data))
end
local function restoreSettings()
    if originalSettings then
        local data = saved()
        data.settings = originalSettings
        openUnnerfPack:SaveData(json.encode(data))
        -- If the final new run loaded this same choice, its config cache also
        -- matches. Release ownership so later owner menu edits stay untouched.
        if active and active.lastChoice == (originalSettings.voidChoiceAbsorption ~= false) then
            originalSettings = nil
        end
    end
end
local function player() return Isaac.GetPlayer(0) end
local function pickups()
    local found = {}
    for _, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)) do
        local p = entity:ToPickup()
        if p:Exists() and p.SubType > 0 then found[#found + 1] = p end
    end
    table.sort(found, function(a, b) return a.InitSeed < b.InitSeed end)
    return found
end
local function stats()
    local p = player()
    return {damage = p.Damage, delay = p.MaxFireDelay, speed = p.MoveSpeed,
        shotSpeed = p.ShotSpeed, luck = p.Luck, range = p.TearRange}
end
local function state()
    local p, level = player(), Game():GetLevel()
    local current = level:GetCurrentRoomDesc()
    local dimension = -1
    if current.SafeGridIndex >= 0 then
        for i = 0, 2 do
            local desc = level:GetRoomByIdx(current.SafeGridIndex, i)
            if desc.Data and GetPtrHash(desc) == GetPtrHash(current) then dimension = i end
        end
    end
    local items = {}
    for _, pickup in ipairs(pickups()) do
        local entry = {item = pickup.SubType, seed = pickup.InitSeed,
            group = pickup.OptionsPickupIndex, price = pickup.Price, touched = pickup.Touched}
        if active and active.edge then
            local config = Isaac.GetItemConfig():GetCollectible(pickup.SubType)
            entry.itemType, entry.quest = config.Type, config.Tags & ItemConfig.TAG_QUEST ~= 0
            entry.blind = active.case.edgeKind == "alt" and EID:IsAltChoice(pickup) or false
        end
        items[#items + 1] = entry
    end
    local owned = {}
    for _, id in ipairs(active and active.fixtureIds or books) do owned[tostring(id)] = p:GetCollectibleNum(id, true) end
    return {seed = Game():GetSeeds():GetStartSeed(),
        playerType = p:GetPlayerType(), roomType = Game():GetRoom():GetType(),
        roomIndex = level:GetCurrentRoomIndex(), roomVariant = current.Data and current.Data.Variant,
        stage = level:GetStage(), stageType = level:GetStageType(),
        dimension = dimension, safeGridIndex = current.SafeGridIndex,
        pickups = items, owned = owned, stats = stats(),
        charge = p:GetActiveCharge(0), soulHearts = p:GetSoulHearts(),
        shield = p:GetEffects():GetCollectibleEffectNum(58),
        enabled = openUnnerfPack.Config.IsEnabled("voidChoiceAbsorption"),
        nextChoice = saved().settings.voidChoiceAbsorption,
        maxCharges = Isaac.GetItemConfig():GetCollectible(C.COLLECTIBLE_VOID).MaxCharges,
        voidRngSeed = p:GetCollectibleRNG(C.COLLECTIBLE_VOID):GetSeed(),
        mcm = ModConfigMenu ~= nil, repentogon = REPENTOGON ~= nil,
        enemies = Game():GetRoom():GetAliveEnemiesCount(), clear = Game():GetRoom():IsClear(),
        ambushActive = Game():GetRoom():IsAmbushActive()}
end
local function check(condition, message)
    if not condition then error(message) end
end
local function cleanupPickups()
    -- Every run is disposable and explicitly owned by this runner.
    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity:ToPickup() then entity:Remove() end
    end
end
local function spawn(id, group, price, x)
    local room = Game():GetRoom()
    local p = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
        id, room:GetCenterPos() + Vector(x, -60), Vector.Zero, nil):ToPickup()
    p.OptionsPickupIndex, p.Price = group, price or 0
    p.AutoUpdatePrice = false
    return p
end
local function ownedNone()
    for _, id in ipairs(active.fixtureIds) do
        check(player():GetCollectibleNum(id, true) == 0, "absorbed item became owned: " .. id)
    end
end
local function useVoid()
    local p = player()
    p:SetActiveCharge(4, 0)
    -- Match the observed physical-use flags (4) and slot (0). This invokes the
    -- native item code; API discharge is recorded separately from manual charge evidence.
    p:GetCollectibleRNG(C.COLLECTIBLE_VOID):SetSeed(160477, 35)
    active.invocations = {}
    emit("before_use", state())
    p:UseActiveItem(C.COLLECTIBLE_VOID, UseFlag.USE_OWNED, 0)
    emit("after_use", state())
end
local function schedule(phase, frames)
    active.phase, active.wait = phase, frames or 20
end
local function enterNativeRoom(case)
    if case.roomType == RoomType.ROOM_TREASURE or case.roomType == RoomType.ROOM_BOSS then
        local level = Game():GetLevel()
        local generated = level:GetRooms()
        for index = 0, generated.Size - 1 do
            local desc = generated:Get(index)
            if desc.Data and desc.Data.Type == case.roomType and desc.SafeGridIndex >= 0 then
                local main = level:GetRoomByIdx(desc.SafeGridIndex, 0)
                if main.Data and GetPtrHash(main) == GetPtrHash(desc) then
                    emit("native_level_room_selected", {roomIndex = desc.SafeGridIndex,
                        roomType = desc.Data.Type, variant = desc.Data.Variant})
                    Game():ChangeRoom(desc.SafeGridIndex)
                    return
                end
            end
        end
        error("requested native room missing from generated floor")
    end
    Isaac.ExecuteCommand(case.room)
end
local nextCase
local function finish(ok, message)
    if ok and active.edge and not active.pilot then
        local byName = {}
        for _, entry in ipairs(active.results) do byName[entry.name] = entry end
        for _, cohort in ipairs({"photos", "alt"}) do
            local off, control, on = byName[cohort .. "-off"], byName[cohort .. "-unlinked"], byName[cohort .. "-on"]
            check(off and control and on, "missing edge comparison: " .. cohort)
            for _, observed in ipairs({control, on}) do
                check(observed.fixture.seed == off.fixture.seed, "edge cohort seed changed")
                check(#observed.fixture.pickups == #off.fixture.pickups, "edge fixture count changed")
                for i, original in ipairs(off.fixture.pickups) do
                    local same = observed.fixture.pickups[i]
                    check(same.item == original.item and same.seed == original.seed
                        and same.group == original.group and same.blind == original.blind,
                        "original identity/group/blind state changed between controls")
                end
                for key, value in pairs(off.beforeStats) do
                    check(math.abs(value - observed.beforeStats[key]) < 0.00001, "edge starting stats changed")
                end
            end
            for key, value in pairs(control.afterStats) do
                check(math.abs(value - on.afterStats[key]) < 0.00001,
                    "linked On differs from native unlinked rewards: " .. cohort .. "/" .. key)
            end
            check(#control.observed.pickups == #on.observed.pickups, "edge consumption differs from native control")
            for i, pickup in ipairs(control.observed.pickups) do
                check(pickup.item == on.observed.pickups[i].item, "edge surviving identity differs")
            end
            emit("edge_comparison", {cohort = cohort, pass = true,
                off = off.afterStats, unlinked = control.afterStats, on = on.afterStats})
        end
    elseif ok and not active.pilot then
        local byName = {}
        for _, entry in ipairs(active.results) do byName[entry.name] = entry end
        for _, pair in ipairs({{"passive-single", "passive-linked-off"},
            {"passive-unlinked", "passive-linked-on"}}) do
            if byName[pair[1]] and byName[pair[2]] then
                for key, value in pairs(byName[pair[1]].afterStats) do
                    if math.abs(value - byName[pair[2]].afterStats[key]) > 0.00001 then
                        ok, message = false, "passive native comparator differs: " .. pair[1] .. "/" .. pair[2] .. "/" .. key
                    end
                end
            else
                emit("comparison_from_earlier_capture", {cases = pair})
            end
        end
    end
    emit("batch_result", {pass = ok, error = message, results = active.results})
    result = {pass = ok, error = message, results = active.results}
    if not ok and player():Exists() and not player():IsDead() then
        player():SetMinDamageCooldown(3600) -- Time to inspect a failed disposable fixture safely.
    end
    restoreSettings()
    active = nil
    print(ok and "OUP_VOID_BATCH_PASS" or "OUP_VOID_BATCH_FAIL", message or "discard disposable run")
end
local function complete(fields)
    fields = fields or {}
    fields.pass, fields.name = true, active.case.name
    fields.observed = state()
    active.results[#active.results + 1] = fields
    emit("case_result", fields)
    nextCase()
end
nextCase = function()
    active.index = active.index + 1
    active.case = active.cases[active.index]
    if not active.case then finish(true); return end
    active.fixtureIds, active.invocations = {}, {}
    active.seededCase, active.rewardWait = false, 0
    active.phase, active.wait = "starting", 180
    Isaac.ExecuteCommand("restart " .. (active.case.actor or 0))
end
local function startCase()
    local a, p = active, player()
    check(Game():GetNumPlayers() == 1 and Game().Difficulty == 0, "single-player Normal required")
    check(openUnnerfPack.Config.IsEnabled("voidChoiceAbsorption") == a.case.enabled,
        "new-run setting not selected")
    check(p:GetPlayerType() == (a.case.actor or 0), "wrong character after restart")
    if a.edge then
        if not a.seededCase then
            a.seededCase = true
            a.phase, a.wait = "starting", 180
            Isaac.ExecuteCommand("seed " .. Seeds.Seed2String(edgeSeeds[a.case.edgeKind]))
            return
        end
        check(Game():GetSeeds():GetStartSeed() == edgeSeeds[a.case.edgeKind], "seed command did not select cohort")
    end
    if p:GetActiveItem(0) ~= C.COLLECTIBLE_VOID then p:AddCollectible(C.COLLECTIBLE_VOID, 4, true) end
    p.Position = Game():GetRoom():GetCenterPos() + Vector(0, 100)
    check(p:GetEffects():GetCollectibleEffectNum(58) == 0, "shield leaked across runs")
    if a.case.room then
        if a.case.options then p:AddCollectible(a.case.options) end
        if a.case.stage then
            Isaac.ExecuteCommand(a.case.stage)
            schedule("stage_room", 30)
            return
        end
        enterNativeRoom(a.case)
        schedule("room", 30)
        return
    end
    if a.case.special then
        p:AddCollectible(1); p:AddCollectible(2)
        p:UseActiveItem(a.case.special, 0, -1)
        schedule("special", 60)
        return
    end
    cleanupPickups()
    local kind = a.case.kind
    if kind == "empty" then
        useVoid(); schedule("empty_result"); return
    end
    local ids = (kind == "passive" or kind == "manual") and {1, 2}
        or kind == "mixed" and {58, 1} or {58, 78}
    if a.case.single then ids = {1} end
    a.fixtureIds = ids
    for i, id in ipairs(ids) do
        spawn(id, a.case.unlinked and 0 or 916, a.case.paid and 15 or 0, i == 1 and -80 or 80)
    end
    emit("fixture", state())
    if kind == "manual" then schedule("manual", 20) else schedule("first_use", 20) end
end
local function tick()
    if not active then return end
    local ok, failure = pcall(function()
        local a = active
        if player():Exists() and not player():IsDead() then player():SetMinDamageCooldown(120) end
        a.ticks = a.ticks + 1
        check(a.ticks < 3600, "batch exceeded two-minute frame budget")
        if a.phase == "starting" then
            a.wait = a.wait - 1
            check(a.wait > 0, "restart callback not observed")
            return
        end
        if a.wait > 0 then a.wait = a.wait - 1; return end
        if a.phase == "setup" then startCase()
        elseif a.phase == "stage_room" then
            enterNativeRoom(a.case); schedule("room", 30)
        elseif a.phase == "special" then
            local observation = state()
            if a.case.special == C.COLLECTIBLE_GENESIS then
                check(observation.roomIndex == GridRooms.ROOM_GENESIS_IDX, "Genesis transition not observed")
            else check(observation.dimension == 2, "Death Certificate dimension not observed") end
            -- Verify the real production gate in the actual selection area.
            -- Do not destroy native selection pedestals or run a replacement use.
            a.fixtureIds = {58, 78}
            local first, second = spawn(58, 916, 0, -80), spawn(78, 916, 0, 80)
            local invoked = 0
            for _, callback in ipairs(Isaac.GetCallbacks(ModCallbacks.MC_PRE_USE_ITEM)) do
                if callback.Mod and callback.Mod.Name == "Void Choice Unnerf" then
                    callback.Function(callback.Mod, C.COLLECTIBLE_VOID,
                        player():GetCollectibleRNG(C.COLLECTIBLE_VOID), player(), UseFlag.USE_OWNED, 0, 0)
                    invoked = invoked + 1
                end
            end
            check(invoked == 1, "expected exactly one registered production Void callback")
            check(first.OptionsPickupIndex == 916 and second.OptionsPickupIndex == 916,
                "special-room restriction bypassed")
            complete({scope = "native entry and production exclusion gate; native return untested",
                invokedCallbacks = invoked})
        elseif a.phase == "manual" then
            local found = pickups()
            check(#found == 2, "manual fixture missing")
            player().Position = found[1].Position
            a.manualWait, a.manualStable = 0, 0
            schedule("manual_result", 0)
        elseif a.phase == "manual_result" then
            -- Ownership is applied only when the native pickup animation's
            -- queued item flushes. Observe that event instead of assuming a
            -- fixed 30-frame animation duration.
            a.manualWait = a.manualWait + 1
            local owned = player():GetCollectibleNum(1, true) + player():GetCollectibleNum(2, true)
            check(owned <= 1, "manual pickup granted both choices")
            check(a.manualWait <= 180, "manual pickup never settled")
            if owned == 1 then
                player().Position = Game():GetRoom():GetCenterPos() + Vector(0, 100)
                a.manualStable = a.manualStable + 1
                if a.manualStable >= 10 then complete() end
            else a.manualStable = 0 end
        elseif a.phase == "room" then
            if a.case.boss and not a.bossKilled then
                for _, entity in ipairs(Isaac.GetRoomEntities()) do
                    local npc = entity:ToNPC()
                    if npc and npc:IsActiveEnemy(false) then npc:Kill() end
                end
                a.bossKilled = true
                schedule("room", 60); return
            end
            local found = pickups()
            if a.case.boss and #found < 2 then
                a.rewardWait = (a.rewardWait or 0) + 10
                check(a.rewardWait <= 600, "native boss reward never settled")
                for _, entity in ipairs(Isaac.GetRoomEntities()) do
                    local npc = entity:ToNPC()
                    if npc and npc:IsActiveEnemy(false) then npc:Kill() end
                end
                schedule("room", 10); return
            end
            if a.edge then
                a.fixtureIds = {}
                for _, pickup in ipairs(found) do a.fixtureIds[#a.fixtureIds + 1] = pickup.SubType end
                local fixture = state()
                if a.case.edgeKind == "photos" then
                    local ids = {}
                    for _, pickup in ipairs(fixture.pickups) do ids[pickup.item] = true end
                    check(#found == 2 and ids[327] and ids[328], "native Mom did not produce both unlocked photos")
                    check(fixture.stage == 6, "photo fixture is not on Depths II")
                else
                    check(fixture.stage == 1 and (fixture.stageType == 3 or fixture.stageType == 4),
                        "mystery fixture is not a native alternate-path first floor")
                    local hidden, passive = 0, #found == 2
                    for _, pickup in ipairs(fixture.pickups) do
                        hidden = hidden + (pickup.blind and 1 or 0)
                        passive = passive and pickup.itemType == ItemType.ITEM_PASSIVE
                    end
                    if hidden ~= 1 or not passive then
                        check(not edgeDiscovered.alt, "previously selected natural mystery fixture changed")
                        a.candidates = (a.candidates or 0) + 1
                        emit("edge_seed_rejected", {fixture = fixture, attempt = a.candidates,
                            reason = "need an untouched naturally blind passive pair for bounded stat comparison"})
                        check(a.candidates < 8, "no natural passive mystery pair within bounded seed search")
                        edgeSeeds.alt = edgeSeeds.alt + 1
                        a.phase, a.wait = "starting", 180
                        Isaac.ExecuteCommand("seed " .. Seeds.Seed2String(edgeSeeds.alt))
                        return
                    end
                    edgeDiscovered.alt = true
                    check(found[1].OptionsPickupIndex ~= 0
                        and found[1].OptionsPickupIndex == found[2].OptionsPickupIndex,
                        "natural alternate-path pair has no native choice link")
                end
                for _, pickup in ipairs(found) do
                    check(pickup.Price == 0 and not pickup.Touched, "native fixture was touched or priced")
                end
                a.fixture = fixture
                emit("edge_native_fixture", {fixture = fixture, blindOracle = "EID:IsAltChoice (vanilla sprite comparison)",
                    eidVersion = EID.ModVersion, eidCommit = EID.ModVersionCommit,
                    intervention = a.case.unlinked and "clear option links only; preserve identities and presentation" or "none"})
                if a.case.unlinked then
                    for _, pickup in ipairs(found) do pickup.OptionsPickupIndex = 0 end
                end
                schedule("first_use", 20)
                return
            end
            check(#found >= 2, "native room did not generate choice pedestals")
            local groups = {}
            for _, pickup in ipairs(found) do
                if pickup.OptionsPickupIndex ~= 0 then
                    local group = pickup.OptionsPickupIndex
                    groups[group] = (groups[group] or 0) + 1
                end
            end
            local choices = false
            for _, size in pairs(groups) do if size >= 2 then choices = true end end
            check(choices, "native room has no actual linked choice group")
            check(Game():GetRoom():GetType() == a.case.roomType, "wrong native room type")
            a.fixtureIds = {}
            for i, pickup in ipairs(found) do
                local group, price = pickup.OptionsPickupIndex, pickup.Price
                check(i <= #books, "more native choices than distinct fixture books")
                pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, books[i], true, true, true)
                pickup.OptionsPickupIndex, pickup.Price = group, price
                a.fixtureIds[#a.fixtureIds + 1] = books[i]
            end
            player().Position = Game():GetRoom():GetCenterPos() + Vector(0, 100)
            emit("native_room_fixture", state())
            schedule("first_use")
        elseif a.phase == "first_use" then
            a.beforeStats = stats()
            useVoid()
            check(next(a.invocations) == nil, "newly absorbed active executed immediately")
            schedule("first_result")
        elseif a.phase == "first_result" then
            ownedNone()
            if a.edge then
                local after = state()
                for _, pickup in ipairs(after.pickups) do
                    for _, original in ipairs(a.fixture.pickups) do
                        if pickup.seed == original.seed then
                            local expected = a.case.unlinked and 0 or original.group
                            check(pickup.item == original.item and pickup.group == expected,
                                "surviving native choice was not restored")
                        end
                    end
                end
                complete({fixture = a.fixture, beforeStats = a.beforeStats, afterStats = stats(),
                    rngIntervention = "Void RNG seed 160477 shift 35 before one native use",
                    scope = "first absorption of untouched native passive identities; no full route transition test"})
                return
            end
            if a.case.paid then
                check(#pickups() == #a.fixtureIds, "unpaid pedestal was consumed")
                complete(); return
            end
            check(#pickups() == 0, "eligible pedestal survived Void")
            check(player():GetSoulHearts() == 0, "new Revelations effect executed immediately")
            if a.case.roomType == RoomType.ROOM_BOSSRUSH then
                local room = Game():GetRoom()
                if not room:IsAmbushActive() and room:GetAliveEnemiesCount() == 0 then
                    a.ambushWait = (a.ambushWait or 0) + 1
                    check(a.ambushWait <= 300, "Boss Rush never started within the native wait bound")
                    schedule("first_result", 0); return
                end
                emit("boss_rush_started", state())
                -- Stop enemies after the start assertion; room cannot be rolled back.
                for _, e in ipairs(Isaac.GetRoomEntities()) do if e:ToNPC() then e:Remove() end end
            end
            a.afterStats = stats()
            if a.case.kind == "passive" then
                complete({beforeStats = a.beforeStats, afterStats = a.afterStats}); return
            end
            useVoid(); schedule("second_result")
        elseif a.phase == "second_result" or a.phase == "third_result" then
            ownedNone()
            local expected = {}
            for _, id in ipairs(a.fixtureIds) do
                if id == 58 or id == 78 or id == 34 or id == 287 then expected[id] = true end
            end
            if not a.case.enabled and not a.case.unlinked then expected[78] = nil end
            for id in pairs(expected) do check(a.invocations[id] == 1, "stored effect count differs for " .. id) end
            for id, number in pairs(a.invocations) do check(expected[id] and number == 1, "unexpected stored active") end
            if expected[78] then
                local expectedHearts = a.phase == "second_result" and 2 or 4
                check(player():GetSoulHearts() == expectedHearts, "Revelations multiplicity changed")
            end
            emit("stored_effects", {invocations = a.invocations, observed = state()})
            if a.phase == "second_result" then useVoid(); schedule("third_result")
            else complete() end
        elseif a.phase == "empty_result" then
            check(#pickups() == 0 and next(a.invocations) == nil, "empty room produced reward")
            complete()
        end
    end)
    if not ok and active then finish(false, tostring(failure)) end
end

-- A restart can save the previous run's cached choices before selecting the new
-- run. Write the fixture's backed-up input after that save, before config.load.
mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.EARLY, function(_, continued)
    if active and active.phase == "starting" and not continued then
        choice(active.case.enabled)
        active.lastChoice, active.bossKilled = active.case.enabled, false
    end
end)
mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.LATE, function(_, continued)
    lastContinued = continued
    emit("observed_run_start", {continued = continued, observed = state()})
    if active then
        if active.phase ~= "starting" or continued then finish(false, "unexpected run transition")
        else emit("run_started", {continued = continued}); schedule("setup", 20) end
    end
end)
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_, item, _, _, flags)
    local watch = active or continuation
    if watch and item ~= C.COLLECTIBLE_VOID and flags & UseFlag.USE_VOID ~= 0 then
        watch.invocations[item] = (watch.invocations[item] or 0) + 1
        emit("stored_active", {item = item, flags = flags})
    end
end)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, tick)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_GAME_EXIT, CallbackPriority.LATE, function()
    if not active then restoreSettings() end
end)

function batch.Run(pilot, fromCase)
    check(not active and not continuation and openUnnerfPack and openUnnerfPack.Config, "idle production pack required")
    check(Game():GetNumPlayers() == 1 and Game().Difficulty == 0, "single-player Normal required")
    check(not (OUPVoidProbe and OUPVoidProbe.active), "stop another active probe")
    originalSettings = saved().settings or {}
    active = {label = pilot and "VOID16_PILOT" or "VOID16_MATRIX", pilot = pilot, index = 0, ticks = 0, results = {},
        cases = pilot and {{name = "active-isaac-on", enabled = true}} or {
            {name = "active-isaac-on", enabled = true},
            {name = "active-apollyon-on", enabled = true, actor = 15},
            {name = "active-off", enabled = false},
            {name = "unlinked-active-on", enabled = true, unlinked = true},
            {name = "mixed-on", enabled = true, kind = "mixed"},
            {name = "passive-single", enabled = false, kind = "passive", single = true},
            {name = "passive-linked-off", enabled = false, kind = "passive"},
            {name = "passive-unlinked", enabled = true, kind = "passive", unlinked = true},
            {name = "passive-linked-on", enabled = true, kind = "passive"},
            {name = "paid-on", enabled = true, paid = true},
            {name = "empty-on", enabled = true, kind = "empty"},
            {name = "manual-choice-on", enabled = true, kind = "manual"},
            -- The owner selected Boss Rush for native room acceptance. A bare
            -- goto s.angel may generate a single pedestal and is not a fixture.
            {name = "boss-rush-native", enabled = true, room = "goto s.bossrush", roomType = RoomType.ROOM_BOSSRUSH},
            {name = "more-options-native", enabled = true, options = C.COLLECTIBLE_MORE_OPTIONS,
                room = "goto s.treasure", roomType = RoomType.ROOM_TREASURE},
            {name = "theres-options-native", enabled = true, options = C.COLLECTIBLE_THERES_OPTIONS,
                room = "goto s.boss", roomType = RoomType.ROOM_BOSS, boss = true},
            {name = "alt-treasure-native", enabled = true, stage = "stage 1c",
                room = "goto s.treasure", roomType = RoomType.ROOM_TREASURE},
            {name = "genesis-exclusion", enabled = true, special = C.COLLECTIBLE_GENESIS},
            {name = "certificate-exclusion", enabled = true, special = C.COLLECTIBLE_DEATH_CERTIFICATE},
            {name = "continue-anchor", enabled = true, actor = 15},
        }}
    result = nil
    if fromCase then
        local found = false
        for index, case in ipairs(active.cases) do
            if case.name == fromCase then active.index, found = index - 1, true; break end
        end
        check(found, "unknown resume case")
    end
    emit("batch_start", state())
    if fromCase then emit("resume_from_case", {fromCase = fromCase,
        scope = "remaining cases only; prior results stay in their original capture"}) end
    nextCase()
    print("OUP_VOID_BATCH_RUNNING", pilot and "pilot" or "matrix")
end
function batch.RunEdges(pilot)
    check(not active and not continuation and openUnnerfPack and openUnnerfPack.Config, "idle production pack required")
    check(Game():GetNumPlayers() == 1 and Game().Difficulty == 0, "single-player Normal required")
    check(EID and type(EID.IsAltChoice) == "function", "installed EID vanilla blind-state observer required")
    check(not REPENTOGON, "these edge observations target the vanilla executable")
    originalSettings, result = saved().settings or {}, nil
    local cases = {}
    for _, cohort in ipairs(pilot and {"photos"} or {"photos", "alt"}) do
        for _, mode in ipairs(pilot and {"off"} or {"off", "unlinked", "on"}) do
            cases[#cases + 1] = {name = cohort .. "-" .. mode, edgeKind = cohort,
                enabled = mode == "on", unlinked = mode == "unlinked", boss = cohort == "photos",
                stage = cohort == "photos" and "stage 6" or "stage 1c",
                room = cohort == "photos" and "goto s.boss" or "goto s.treasure",
                roomType = cohort == "photos" and RoomType.ROOM_BOSS or RoomType.ROOM_TREASURE}
        end
    end
    active = {label = pilot and "VOID17_PILOT" or "VOID17_EDGES", edge = true,
        pilot = pilot, index = 0, ticks = 0, results = {}, cases = cases}
    nextCase()
    print("OUP_VOID_BATCH_RUNNING", "native edge cases")
end
function batch.CheckContinue(expectedSeed)
    check(not active and not continuation and lastContinued == true, "Continue the anchor run after relaunch")
    local before, data = state(), saved()
    check(before.seed == expectedSeed and before.playerType == 15, "wrong continued anchor run")
    check(before.enabled and data.run and data.run.seed == expectedSeed
        and data.run.settings.voidChoiceAbsorption == true and data.settings.voidChoiceAbsorption == false,
        "expected active On snapshot with next-run Off choice")
    check(before.soulHearts == 4, "anchor health differs before native Continue use")
    continuation = {before = before, uses = 1, wait = 20, ticks = 0, invocations = {}}
    continueResult = nil
    emit("continue_before", before)
    local continueTick
    local function finishContinue(ok, failure)
        emit("continue_result", {pass = ok, error = failure, before = before, observed = state()})
        continueResult = {pass = ok, error = failure}
        continuation = nil
        mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, continueTick)
        print(ok and "OUP_VOID_CONTINUE_PASS" or "OUP_VOID_CONTINUE_FAIL", failure or "")
    end
    continueTick = function()
        local ok, failure = pcall(function()
            local c = continuation
            c.ticks = c.ticks + 1
            check(c.ticks < 180 and Game():GetSeeds():GetStartSeed() == expectedSeed, "Continue check changed run/timed out")
            if c.wait > 0 then c.wait = c.wait - 1; return end
            check(c.invocations[58] == 1 and c.invocations[78] == 1, "stored effects did not execute exactly once")
            for id, number in pairs(c.invocations) do
                check((id == 58 or id == 78) and number == 1, "extra continued stored effect")
            end
            local observed = state()
            check(observed.soulHearts == before.soulHearts + 2 * c.uses and observed.shield > 0,
                "continued native rewards differ")
            check(player():GetCollectibleNum(58, true) == 0 and player():GetCollectibleNum(78, true) == 0,
                "continued absorbed book became owned")
            emit("continue_use_result", {uses = c.uses, observed = observed})
            if c.uses == 2 then finishContinue(true)
            else
                c.uses, c.invocations, c.wait = 2, {}, 20
                player():SetActiveCharge(4, 0)
                player():UseActiveItem(C.COLLECTIBLE_VOID, UseFlag.USE_OWNED, 0)
            end
        end)
        if not ok then finishContinue(false, tostring(failure)) end
    end
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, continueTick)
    continuation.tick = continueTick
    player():SetActiveCharge(4, 0)
    player():UseActiveItem(C.COLLECTIBLE_VOID, UseFlag.USE_OWNED, 0)
    print("OUP_VOID_CONTINUE_RUNNING")
end
function batch.Status()
    print(continuation and "OUP_VOID_CONTINUE_RUNNING"
        or continueResult and (continueResult.pass and "OUP_VOID_CONTINUE_PASS" or "OUP_VOID_CONTINUE_FAIL")
        or active and "OUP_VOID_BATCH_RUNNING" or result and result.pass and "OUP_VOID_BATCH_PASS"
        or result and "OUP_VOID_BATCH_FAIL" or "OUP_VOID_BATCH_IDLE",
        active and active.case.name or result and result.error or "")
end
function batch.Stop()
    if continuation then
        mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, continuation.tick)
        continuation = nil
        continueResult = {pass = false, error = "stopped explicitly"}
    end
    if active then finish(false, "stopped explicitly; discard run") else restoreSettings() end
end
print("OUP_VOID_BATCH_LOADED")
