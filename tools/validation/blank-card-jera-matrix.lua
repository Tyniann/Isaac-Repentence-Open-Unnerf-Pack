-- Disposable issue-19 acceptance runner. No tests start on load. Native input
-- requests and real pickups drive charges; this file never writes charge/clear
-- flags. Room clears and the added co-op actor cannot be undone inside the run.
local json = require("json")
local mod = RegisterMod("OUP Blank Card Matrix", 1)
local matrix = {}
local state = {status = "idle"}
local actor, first, task, wake, pulse, pending, startRoom, batteryOwner, carOwner
local callbacks = {}
local lastStart
local BC = CollectibleType.COLLECTIBLE_BLANK_CARD

local function emit(event, details)
    Isaac.DebugString("OUP_BLANK_CARD " .. json.encode({label = "matrix-" .. (state.mode or "idle"),
        event = event, frame = Game():GetFrameCount(), seed = Game():GetSeeds():GetStartSeed(), details = details}))
end
local function snapshot(p)
    local slots = {}
    for slot = 0, 3 do
        slots[#slots + 1] = {item = p:GetActiveItem(slot), charge = p:GetActiveCharge(slot),
            battery = p:GetBatteryCharge(slot)}
    end
    return {playerSeed = p.InitSeed, controller = p.ControllerIndex, type = p:GetPlayerType(),
        card = p:GetCard(0), count = p:GetCollectibleNum(BC, true), slots = slots,
        theBattery = p:GetCollectibleNum(CollectibleType.COLLECTIBLE_BATTERY, true),
        carBattery = p:GetCollectibleNum(CollectibleType.COLLECTIBLE_CAR_BATTERY, true)}
end
local function total(p, slot) return p:GetActiveCharge(slot or 0) + p:GetBatteryCharge(slot or 0) end
local function pickups(variant)
    local result = {}
    for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, variant or -1, -1, false, false)) do
        if e:Exists() then result[#result + 1] = e:ToPickup() end
    end
    return result
end
local function add(id, fn, filter)
    mod:AddCallback(id, fn, filter)
    callbacks[#callbacks + 1] = {id, fn}
end
local function detach()
    for _, entry in ipairs(callbacks) do mod:RemoveCallback(entry[1], entry[2]) end
    callbacks = {}
    pulse = nil
    if pending and pending:Exists() then pending:Remove() end
    pending = nil
    if batteryOwner then batteryOwner:RemoveCollectible(CollectibleType.COLLECTIBLE_BATTERY); batteryOwner = nil end
    if carOwner then carOwner:RemoveCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY); carOwner = nil end
end
local function finish(status, message)
    state.status, state.message = status, message
    emit("matrix_" .. status, {message = message, cases = state.cases, player = snapshot(first)})
    detach()
    task = nil
    print("OUP Blank Card matrix: " .. status .. (message and (" - " .. message) or ""))
end
local function wait(frames) coroutine.yield(Game():GetFrameCount() + frames) end
local function passed(name, details)
    state.cases[#state.cases + 1] = {name = name, status = "pass"}
    emit("case_pass", {name = name, details = details})
end
local function activate(name, item, expectedJera, expectedUses)
    local uses, cards = state.uses, state.jera
    emit("before_use", {name = name, player = snapshot(actor)})
    pulse = Game():GetFrameCount() + 2
    wait(20)
    pulse = nil
    assert(state.uses == uses + (expectedUses or 1), "Unexpected native item-use count: " .. name)
    assert(state.lastItem == item, "Wrong native active item used: " .. name)
    assert(state.jera == cards + expectedJera, "Unexpected Jera activation count: " .. name)
    emit("after_use", {name = name, player = snapshot(actor), jeraUses = state.jera - cards})
end

local refill, cleanPickups
local function carBattery()
    assert(not actor:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY), "Car Battery fixture already present")
    assert(not actor:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY), "Run the stored-charge smoke first")
    actor:AddCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY, 0, false)
    carOwner = actor
    actor:SetCard(0, Card.CARD_MAGICIAN)
    wait(3)
    local cards = state.cards
    activate("car_battery_native_magician", BC, 0, 2)
    local copies = state.cards - cards
    assert(copies > 0 and total(actor) == 0, "Native Car Battery control did not spend one bar")
    emit("car_battery_reference", {nativeCardUses = copies, player = snapshot(actor)})
    refill("car_battery_magician")
    assert(total(actor) == 2)
    actor:SetCard(0, Card.RUNE_JERA)
    wait(3)
    activate("car_battery_inherited_jera", BC, copies, 2)
    assert(total(actor) == 0 and actor:GetCard(0) == Card.RUNE_JERA)
    refill("car_battery_inherited_jera")
    assert(total(actor) == 4)
    passed("car_battery_cost_transition", {nativeCardUses = copies, player = snapshot(actor)})
    local position = Game():GetRoom():GetCenterPos() + Vector(140, 80)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, position, Vector.Zero, nil)
    activate("car_battery_single_bar", BC, copies, 2)
    assert(total(actor) == 0 and #pickups(PickupVariant.PICKUP_COIN) == 2 ^ copies)
    passed("car_battery_single_charge_expenditure", {nativeCardUses = copies, pennies = #pickups(PickupVariant.PICKUP_COIN)})
    cleanPickups()
    actor:AddCollectible(CollectibleType.COLLECTIBLE_BATTERY, 0, false)
    batteryOwner = actor
    refill("both_batteries_first")
    if total(actor) < 8 then refill("both_batteries_second") end
    assert(total(actor) == 8)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, position, Vector.Zero, nil)
    activate("both_batteries_first_jera", BC, copies, 2)
    assert(total(actor) == 4 and #pickups(PickupVariant.PICKUP_COIN) == 2 ^ copies)
    activate("both_batteries_second_jera", BC, copies, 2)
    assert(total(actor) == 0 and #pickups(PickupVariant.PICKUP_COIN) == 2 ^ (copies * 2))
    cleanPickups()
    actor:RemoveCollectible(CollectibleType.COLLECTIBLE_BATTERY)
    batteryOwner = nil
    actor:RemoveCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY)
    carOwner = nil
    refill("after_car_battery")
    assert(total(actor) == 4 and actor:GetCard(0) == Card.RUNE_JERA and actor:GetCollectibleNum(BC, true) == 1)
    passed("car_battery_with_stored_charge", {nativeCardUses = copies, player = snapshot(actor)})
end
local function collect(pickup, name)
    local seed, before = pickup.InitSeed, snapshot(actor)
    pickup.Position, pickup.Wait = actor.Position, 0
    pending = pickup
    emit("battery_presented", {name = name, pickupSeed = seed, before = before})
    for _ = 1, 90 do
        wait(1)
        if not pickup:Exists() then
            pending = nil
            wait(2)
            emit("battery_collected", {name = name, pickupSeed = seed, after = snapshot(actor)})
            return
        end
    end
    error("Native battery was not collected: " .. name)
end
refill = function(name)
    local battery = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY,
        BatterySubType.BATTERY_NORMAL, actor.Position, Vector.Zero, nil):ToPickup()
    collect(battery, name)
end
cleanPickups = function()
    for _, pickup in ipairs(pickups()) do pickup:Remove() end
    wait(2) -- Native removal is deferred; inspect after real updates.
    assert(#pickups() == 0, "Fixture pickup cleanup incomplete")
    emit("pickup_cleanup", {remaining = 0})
end

local function batterySmoke()
    assert(not actor:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY), "Use the prepared disposable run without The Battery")
    if total(actor) == 0 then refill("recover_empty_bar") end
    assert(total(actor) == 4, "Expected a full four-charge bar")
    -- Establish ordinary native card behavior before testing the restored rune.
    actor:SetCard(0, Card.CARD_MAGICIAN)
    wait(3)
    activate("native_magician_setup", BC, 0)
    assert(total(actor) == 0)
    refill("native_magician_setup")
    assert(total(actor) == 2)
    actor:AddCollectible(CollectibleType.COLLECTIBLE_BATTERY, 0, false)
    batteryOwner = actor
    refill("native_magician_reserve")
    assert(actor:GetActiveCharge(0) == 2 and actor:GetBatteryCharge(0) == 2)
    activate("first_native_magician_reserve", BC, 0)
    assert(total(actor) == 2, "Native Magician lost or granted stored battery charge")
    activate("second_native_magician_reserve", BC, 0)
    assert(total(actor) == 0)
    passed("native_magician_stored_charge_control", snapshot(actor))
    -- Native Magician establishes a two-charge bar with a two-charge reserve.
    -- The first Jera use must retain those spare two charges while changing
    -- the next capacity to four; the following real battery proves that cost.
    refill("two_charge_reserve_setup")
    assert(actor:GetActiveCharge(0) == 2 and actor:GetBatteryCharge(0) == 2,
        "Native Magician did not establish the two-charge reserve control")
    actor:SetCard(0, Card.RUNE_JERA)
    wait(3)
    activate("jera_with_two_charge_reserve", BC, 1)
    assert(total(actor) == 2, "Cost transition lost or granted the two-charge reserve")
    refill("after_two_charge_jera")
    assert(actor:GetActiveCharge(0) == 4, "Post-use Jera capacity did not become four")
    if total(actor) < 8 then refill("finish_transition_overcharge") end
    assert(actor:GetActiveCharge(0) == 4 and actor:GetBatteryCharge(0) == 4,
        "Post-use Jera capacity did not become four with The Battery")
    passed("stored_charge_across_cost_transition", snapshot(actor))
    activate("transitioned_first_jera", BC, 1)
    assert(total(actor) == 4)
    activate("transitioned_second_jera", BC, 1)
    assert(total(actor) == 0)
    actor:RemoveCollectible(CollectibleType.COLLECTIBLE_BATTERY)
    batteryOwner = nil
    refill("after_overcharge")
    assert(total(actor) == 4 and actor:GetCollectibleNum(BC, true) == 1)
    passed("stored_battery_charge", snapshot(actor))
end

local function chain()
    actor:SetCard(0, Card.RUNE_JERA)
    assert(total(actor) == 4 and #pickups() == 0, "Chain requires a full bar and empty room")
    local position = Game():GetRoom():GetCenterPos() + Vector(140, 80)
    local original = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY,
        BatterySubType.BATTERY_NORMAL, position, Vector.Zero, nil)
    emit("chain_seed", {pickupSeed = original.InitSeed, artificialBatterySpawns = 1})
    -- No further battery spawns or item grants occur in this loop.
    for cycle = 1, 3 do
        activate("chain_" .. cycle, BC, 1)
        assert(total(actor) == 0 and actor:GetCard(0) == Card.RUNE_JERA)
        local available = pickups(PickupVariant.PICKUP_LIL_BATTERY)
        assert(#available == 2, "Native Jera did not leave two chain batteries")
        collect(available[1], "chain_" .. cycle)
        assert(total(actor) == 4 and #pickups(PickupVariant.PICKUP_LIL_BATTERY) == 1)
    end
    passed("three_battery_fed_cycles", {artificialBatterySpawns = 1, player = snapshot(actor)})
    cleanPickups()
end

local function ordinaryPickups()
    local variants = {PickupVariant.PICKUP_KEY, PickupVariant.PICKUP_BOMB, PickupVariant.PICKUP_HEART}
    local subtypes = {KeySubType.KEY_NORMAL, BombSubType.BOMB_NORMAL, HeartSubType.HEART_FULL}
    local center = Game():GetRoom():GetCenterPos()
    for index, variant in ipairs(variants) do
        Isaac.Spawn(EntityType.ENTITY_PICKUP, variant, subtypes[index], center + Vector(140, (index - 2) * 70), Vector.Zero, nil)
    end
    actor:SetCard(0, Card.RUNE_JERA)
    activate("keys_bombs_hearts", BC, 1)
    local result = {}
    for _, variant in ipairs(variants) do
        result[tostring(variant)] = #pickups(variant)
        assert(result[tostring(variant)] == 2, "Native Jera did not double pickup variant " .. variant)
    end
    refill("ordinary_pickups")
    assert(total(actor) == 4)
    passed("ordinary_keys_bombs_hearts", result)
    cleanPickups()
end

local function transitions(enabled)
    actor:SetCard(0, Card.CARD_MAGICIAN)
    wait(3)
    assert(total(actor) == 4, "Selecting Magician changed the existing charge bar")
    activate("magician", BC, 0)
    assert(total(actor) == 0)
    refill("magician")
    assert(total(actor) == 2, "Vanilla Magician recharge changed")
    actor:SetCard(0, Card.RUNE_JERA)
    wait(3)
    assert(total(actor) == 2, "Selecting Jera changed or granted charges")
    activate("jera_after_magician", BC, enabled and 1 or 0)
    assert(total(actor) == 0 and actor:GetCard(0) == Card.RUNE_JERA)
    refill("jera_after_magician")
    assert(total(actor) == (enabled and 4 or 2), "Wrong post-Jera recharge cost")
    passed(enabled and "post_use_cost_timing" or "disabled_native_cost_timing", snapshot(actor))
    local cost, cards = total(actor), state.cards
    actor:SetCard(0, Card.RUNE_DAGAZ)
    wait(3)
    assert(total(actor) == cost, "Selecting another rune changed charge")
    activate("non_jera_rune", BC, 0)
    assert(state.cards == cards, "Blank Card unexpectedly invoked another rune")
    refill("non_jera_rune")
    assert(total(actor) == cost)
    passed(enabled and "other_rune_passthrough" or "disabled_other_rune", snapshot(actor))
end

local function slots()
    actor:SetCard(0, Card.RUNE_JERA)
    wait(3)
    assert(not actor:HasCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG), "Schoolbag fixture already present")
    actor:AddCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG, 0, false)
    actor:AddCollectible(105, 6, false, 1)
    local before = snapshot(actor)
    local uses, jera = state.uses, state.jera
    actor:SwapActiveItems()
    wait(3)
    assert(actor:GetActiveItem(0) == 105 and actor:GetActiveItem(1) == BC)
    assert(total(actor, 1) == 4 and state.uses == uses and state.jera == jera, "Swap granted charge or activated an item")
    activate("d6_with_jera_held", 105, 0)
    assert(total(actor, 1) == 4, "Using D6 changed the stored Blank Card")
    actor:SwapActiveItems()
    wait(3)
    assert(actor:GetActiveItem(0) == BC and total(actor) == 4 and total(actor, 1) == 0)
    activate("blank_card_after_swap", BC, 1)
    assert(total(actor) == 0 and total(actor, 1) == 0, "Blank Card changed the other active's charge")
    refill("after_schoolbag")
    assert(total(actor) == 4)
    passed("schoolbag_swaps", {before = before, after = snapshot(actor)})
end

local function ordinaryCandidates()
    local rooms, candidates = Game():GetLevel():GetRooms(), {}
    for index = 0, rooms.Size - 1 do
        local desc = rooms:Get(index)
        if #candidates < 12 and desc.Data and desc.Data.Type == 1 and desc.VisitedCount == 0
            and desc.Data.Shape == RoomShape.ROOMSHAPE_1x1
            and desc.SafeGridIndex ~= startRoom then candidates[#candidates + 1] = desc.SafeGridIndex end
    end
    return candidates
end

local function roomClears()
    local candidates = ordinaryCandidates()
    -- Earlier diagnostics may have visited the remaining small rooms. Prepare
    -- a mapped floor before discharging, without setting charge or clear flags.
    for _, stage in ipairs({2, 3}) do
        if #candidates >= 4 then break end
        if Game():GetLevel():GetStage() ~= stage then
            emit("room_floor_setup", {fromStage = Game():GetLevel():GetStage(), toStage = stage,
                availableSmallRooms = #candidates, player = snapshot(actor)})
            Isaac.ExecuteCommand("stage " .. stage)
            wait(30)
            assert(Game():GetLevel():GetStage() == stage, "Native floor preparation did not reach requested stage")
            first, actor = Isaac.GetPlayer(0), Isaac.GetPlayer(0)
            startRoom = Game():GetLevel():GetStartingRoomIndex()
            candidates = ordinaryCandidates()
        end
    end
    assert(#candidates >= 4, "Four unvisited ordinary 1x1 rooms unavailable on bounded floors")
    emit("ordinary_room_plan", {stage = Game():GetLevel():GetStage(), rooms = candidates})
    actor:SetCard(0, Card.RUNE_JERA)
    assert(total(actor) == 4 and actor:GetActiveItem(0) == BC, "Floor preparation changed the full Blank Card")
    activate("before_room_clears", BC, 1)
    assert(total(actor) == 0)
    local cleared = 0
    for _, index in ipairs(candidates) do
        if cleared == 4 then break end
        Game():ChangeRoom(index)
        wait(10)
        local room = Game():GetRoom()
        assert(room:GetRoomShape() == RoomShape.ROOMSHAPE_1x1, "Selected room was not ordinary 1x1")
        actor.Position = room:FindFreePickupSpawnPosition(room:GetTopLeftPos() + Vector(80, 80), 0, true)
        if not room:IsClear() and room:GetAliveEnemiesCount() > 0 then
            local before = total(actor)
            for _ = 1, 8 do
                if room:IsClear() then break end
                for _, entity in ipairs(Isaac.GetRoomEntities()) do
                    local npc = entity:ToNPC()
                    if npc and npc.Type ~= 33 and not npc:IsDead() then npc:Kill() end
                end
                wait(15)
            end
            assert(room:IsClear(), "Mapped hostile room did not clear within bounded retries")
            wait(15)
            cleared = cleared + 1
            emit("ordinary_room_clear", {ordinal = cleared, room = index, shape = room:GetRoomShape(),
                stage = Game():GetLevel():GetStage(), before = before, after = total(actor)})
            assert(before == cleared - 1 and total(actor) == cleared, "Room clear did not add exactly one charge")
        end
    end
    assert(cleared == 4 and total(actor) == 4, "Four mapped hostile clears unavailable")
    Game():ChangeRoom(startRoom)
    wait(10)
    passed("four_ordinary_room_clears", snapshot(actor))
end

local function coOp()
    if Game():GetNumPlayers() == 1 then
        -- A bounded native command feasibility probe, not an assumption that
        -- the undocumented command works. Missing second actor stays pending.
        emit("co_op_command_probe", {command = "addplayer 0 1"})
        Isaac.ExecuteCommand("addplayer 0 1")
        wait(30)
    end
    if Game():GetNumPlayers() ~= 2 then
        state.coOpPending = true
        emit("co_op_pending", {players = Game():GetNumPlayers()})
        return
    end
    local second = Isaac.GetPlayer(1)
    assert(second:GetPlayerType() == PlayerType.PLAYER_ISAAC and GetPtrHash(second) ~= GetPtrHash(first),
        "Co-op probe did not create a distinct Isaac")
    local center = Game():GetRoom():GetCenterPos()
    first.Position, second.Position = center + Vector(-100, -70), center + Vector(100, 70)
    if second:GetActiveItem(0) == 105 then second:RemoveCollectible(105) end
    assert(second:GetActiveItem(0) == 0, "Second player has an unexpected active")
    second:AddCollectible(BC, 4, false, 0, 4)
    second:SetCard(0, Card.CARD_MAGICIAN)
    actor = first
    first:SetCard(0, Card.RUNE_JERA)
    if total(first) < 4 then refill("co_op_initial_first") end
    assert(total(first) == 4)
    local other = snapshot(second)
    activate("co_op_first_jera", BC, 1)
    assert(total(second) == 4 and second:GetCard(0) == Card.CARD_MAGICIAN)
    actor = second
    activate("co_op_second_magician", BC, 0)
    assert(total(first) == 0, "Other player's activation changed first player's charge")
    refill("co_op_magician")
    assert(total(second) == 2 and total(first) == 0)
    second:SetCard(0, Card.RUNE_JERA)
    wait(3)
    assert(total(second) == 2)
    activate("co_op_second_jera", BC, 1)
    assert(total(first) == 0)
    refill("co_op_second_jera")
    assert(total(second) == 4 and total(first) == 0)
    actor = first
    refill("co_op_first_jera")
    assert(total(first) == 4 and total(second) == 4)
    passed("co_op_player_isolation", {secondBefore = other, first = snapshot(first), second = snapshot(second)})
end

local function nextOff()
    local category = assert(ModConfigMenu.GetCategoryIDByName("Open Unnerf Pack 2"))
    local seen, matches = {}, {}
    local function visit(value)
        if type(value) ~= "table" or seen[value] then return end
        seen[value] = true
        if type(value.Display) == "function" and type(value.OnChange) == "function" then
            local ok, text = pcall(value.Display)
            if ok and type(text) == "string" and text:find("Blank Card + Jera:", 1, true) == 1 then matches[#matches + 1] = value end
        end
        for _, child in pairs(value) do if type(child) == "table" then visit(child) end end
    end
    visit(ModConfigMenu.MenuData[category])
    assert(#matches == 1, "MCM setting lookup was not unique")
    local charge, uses, jera = total(first), state.uses, state.jera
    matches[1].OnChange(false)
    assert(matches[1].CurrentSetting() == false and openUnnerfPack.Config.IsEnabled("blankCardJera"))
    assert(total(first) == charge, "Changing next-run choice granted charge")
    assert(state.uses == uses and state.jera == jera, "Setting change activated an item")
    local saved = json.decode(openUnnerfPack:LoadData())
    assert(saved.settings.blankCardJera == false and saved.run.settings.blankCardJera == true)
    passed("next_run_off_keeps_current_on", {active = true, nextRun = false, player = snapshot(first)})
end

local function run()
    if state.mode == "battery-smoke" then batterySmoke()
    elseif state.mode == "car-battery" then carBattery()
    elseif state.mode == "on" then
        ordinaryPickups(); chain(); transitions(true); slots(); roomClears(); coOp(); nextOff()
    elseif state.mode == "finish-on" then
        Game():ChangeRoom(startRoom)
        wait(10)
        assert(#pickups() == 0, "Starting room is not empty for remaining checks")
        roomClears(); coOp(); nextOff()
    elseif state.mode == "co-op" then coOp(); nextOff()
    elseif state.mode == "prepare-continue" then nextOff()
    elseif state.mode == "continue" then
        assert(lastStart and lastStart.continued, "Engine did not observe Continue")
        local saved = json.decode(openUnnerfPack:LoadData())
        assert(saved.run.seed == Game():GetSeeds():GetStartSeed())
        assert(saved.settings.blankCardJera == false and saved.run.settings.blankCardJera == true)
        assert(actor:GetActiveItem(0) == BC and actor:GetCard(0) == Card.RUNE_JERA and total(actor) == 4)
        activate("continued_jera", BC, 1); refill("continued_jera")
        assert(total(actor) == 4)
        passed("continue_retains_on_and_four_charge_state", snapshot(actor))
    elseif state.mode == "off" then
        assert(actor:GetActiveItem(0) == 105 or actor:GetActiveItem(0) == 0, "Use a new Isaac run for Off")
        if actor:GetActiveItem(0) == 105 then actor:RemoveCollectible(105) end
        actor:AddCollectible(BC, 4, false, 0, 4)
        actor:SetCard(0, Card.RUNE_JERA)
        activate("disabled_jera", BC, 0); refill("disabled_jera")
        assert(total(actor) == 4 and actor:GetCard(0) == Card.RUNE_JERA)
        passed("disabled_native_jera", snapshot(actor))
        transitions(false)
    end
    finish(state.coOpPending and "pending" or "complete")
end

function matrix.Run(mode)
    assert(state.status ~= "running", "Matrix already running")
    local modes = {["battery-smoke"] = true, ["car-battery"] = true, on = true, ["continue"] = true,
        off = true, ["co-op"] = true, ["prepare-continue"] = true, ["finish-on"] = true}
    assert(modes[mode], "Unknown matrix mode")
    first, actor = Isaac.GetPlayer(0), Isaac.GetPlayer(0)
    assert(first:GetPlayerType() == PlayerType.PLAYER_ISAAC and Game():GetRoom():IsClear(), "Use a cleared disposable Isaac room")
    assert(mode == "finish-on" or #pickups() == 0, "Starting room still contains pickups")
    local enabled = openUnnerfPack.Config.IsEnabled("blankCardJera")
    assert(enabled == (mode ~= "off"), "Active feature setting does not match requested matrix")
    if mode ~= "off" then
        assert(actor:GetActiveItem(0) == BC, "Use the prepared Blank Card")
        if mode ~= "co-op" then
            assert(total(actor) == 4 or (mode == "battery-smoke" and total(actor) == 0),
                "Use the prepared full Blank Card")
        end
    end
    assert(not first:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY), "Car Battery requires a separate multiplier control")
    startRoom = mode == "finish-on" and Game():GetLevel():GetStartingRoomIndex()
        or Game():GetLevel():GetCurrentRoomIndex()
    state = {status = "running", mode = mode, cases = {}, uses = 0, cards = 0, jera = 0, startFrame = Game():GetFrameCount()}
    emit("matrix_started", {fixtureRevision = 4, players = Game():GetNumPlayers(), player = snapshot(first),
        startingPickups = #pickups(), enabled = enabled, room = Game():GetLevel():GetCurrentRoomIndex(),
        roomShape = Game():GetRoom():GetRoomShape(), stage = Game():GetLevel():GetStage()})
    add(ModCallbacks.MC_INPUT_ACTION, function(_, entity, hook, action)
        if not entity or action ~= ButtonAction.ACTION_ITEM then return end
        local p = entity:ToPlayer()
        if not p or GetPtrHash(p) ~= GetPtrHash(actor) then return end
        local pressed = Game():GetFrameCount() == pulse
        if hook == InputHook.GET_ACTION_VALUE then return pressed and 1 or 0 end
        if hook == InputHook.IS_ACTION_PRESSED or hook == InputHook.IS_ACTION_TRIGGERED then return pressed end
    end)
    add(ModCallbacks.MC_USE_ITEM, function(_, item, _, p, flags, slot)
        if GetPtrHash(p) ~= GetPtrHash(actor) then return end
        -- The engine can query ACTION_ITEM again in the same frame after a
        -- stored bar becomes available. Release the synthetic button as soon
        -- as its first native use starts; native Car Battery repeats continue.
        pulse = nil
        state.uses, state.lastItem = state.uses + 1, item
        emit("native_item_use", {item = item, flags = flags, slot = slot, player = snapshot(p)})
    end)
    add(ModCallbacks.MC_USE_CARD, function(_, card, p, flags)
        if GetPtrHash(p) ~= GetPtrHash(actor) then return end
        state.cards = state.cards + 1
        if card == Card.RUNE_JERA then state.jera = state.jera + 1 end
        emit("native_card_use", {card = card, flags = flags, player = snapshot(p)})
    end)
    add(ModCallbacks.MC_POST_UPDATE, function()
        for index = 0, Game():GetNumPlayers() - 1 do Isaac.GetPlayer(index):SetMinDamageCooldown(90) end
        if Game():GetFrameCount() - state.startFrame > 2400 then finish("error", "Matrix frame budget exceeded"); return end
        if not wake or Game():GetFrameCount() >= wake then
            local ok, result = coroutine.resume(task)
            if not ok then finish("error", tostring(result)) elseif task then wake = result end
        end
    end)
    add(ModCallbacks.MC_PRE_GAME_EXIT, function() matrix.Stop() end)
    task, wake = coroutine.create(run), nil
    print("OUP Blank Card matrix started; close console")
end
function matrix.Status()
    print("OUP Blank Card matrix " .. (state.mode or "idle") .. ": " .. state.status
        .. (state.message and (" - " .. state.message) or ""))
    return state
end
function matrix.Stop() if state.status == "running" then finish("stopped", "Owner stopped matrix") end end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, continued)
    lastStart = {continued = continued, seed = Game():GetSeeds():GetStartSeed()}
    emit("matrix_game_started", lastStart)
end)
OUPBlankCardMatrix = matrix
return matrix
