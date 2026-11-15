-- Disposable issue-19 fixture. Uses native ACTION_ITEM and real battery pickups,
-- never UseActiveItem or charge writes. Does not run until Run() is called.
local json = require("json")
local mod = RegisterMod("OUP Blank Card Jera Batch", 1)
local batch = {}
local callbacks = {}
local state = {status = "idle"}
local task, player, pulseFrame, wakeFrame, pendingPickup
local sequence = 0
local BC = CollectibleType.COLLECTIBLE_BLANK_CARD

local function snapshot()
    return {playerSeed = player.InitSeed, item = player:GetActiveItem(0),
        charge = player:GetActiveCharge(0), battery = player:GetBatteryCharge(0),
        card = player:GetCard(0), count = player:GetCollectibleNum(BC, true)}
end

local function emit(event, details)
    sequence = sequence + 1
    Isaac.DebugString("OUP_BLANK_CARD " .. json.encode({event = event,
        label = "batch-" .. (state.mode or "idle"), sequence = sequence,
        frame = Game():GetFrameCount(), seed = Game():GetSeeds():GetStartSeed(),
        details = details}))
end

local function add(id, fn, filter)
    mod:AddCallback(id, fn, filter)
    callbacks[#callbacks + 1] = {id, fn}
end

local function detach()
    for _, entry in ipairs(callbacks) do mod:RemoveCallback(entry[1], entry[2]) end
    callbacks = {}
    pulseFrame = nil
    if pendingPickup and pendingPickup:Exists() then pendingPickup:Remove() end
    pendingPickup = nil
end

local function finish(status, message)
    state.status, state.message = status, message
    emit("batch_" .. status, {message = message, state = snapshot(), uses = state.uses})
    detach()
    task = nil
    print("OUP Blank Card batch: " .. status .. (message and (" - " .. message) or ""))
end

local function wait(frames)
    coroutine.yield(Game():GetFrameCount() + frames)
end

local function activate(name)
    local before = state.uses
    emit("before_" .. name, snapshot())
    pulseFrame = Game():GetFrameCount() + 2
    wait(20)
    pulseFrame = nil
    assert(state.uses == before + 1, "Native input did not produce exactly one Blank Card use: " .. name)
    emit("after_" .. name, snapshot())
end

local function refill(name)
    local before = snapshot()
    local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY,
        BatterySubType.BATTERY_NORMAL, player.Position, Vector.Zero, nil):ToPickup()
    pendingPickup = pickup
    pickup.Wait = 0
    local pickupSeed = pickup.InitSeed
    emit("battery_spawned", {name = name, state = before, pickupSeed = pickupSeed})
    for _ = 1, 90 do
        wait(1)
        if not pickup:Exists() then
            pendingPickup = nil
            wait(2)
            assert(player:GetActiveCharge(0) > before.charge, "Battery disappeared without recharging Blank Card")
            emit("battery_collected", {name = name, state = snapshot(), pickupSeed = pickupSeed})
            return
        end
    end
    error("Native battery was not collected within 90 frames")
end

local function run()
    -- Explicit disposable setup only: install the held rune, retaining the real
    -- Blank Card and its native charge state. Later refills are real pickups.
    player:SetCard(0, Card.RUNE_JERA)
    wait(3)
    if player:GetActiveCharge(0) == 0 then refill("initial_empty") end
    activate("jera_initial")
    refill("jera_initial")
    if state.mode == "transitions" then
        player:SetCard(0, Card.CARD_MAGICIAN)
        wait(3)
        activate("magician")
        refill("magician")
        player:SetCard(0, Card.RUNE_JERA)
        wait(3)
        activate("jera_after_magician")
        refill("jera_after_magician")
    end
    finish("complete")
end

function batch.Run(mode)
    assert(state.status ~= "running", "Batch already running; use Status or Stop")
    mode = mode or "smoke"
    assert(mode == "smoke" or mode == "transitions", "Unknown batch mode")
    assert(Game():GetNumPlayers() == 1, "Feasibility batch requires one Isaac")
    player = Isaac.GetPlayer(0)
    assert(player:GetPlayerType() == PlayerType.PLAYER_ISAAC, "Feasibility batch requires Isaac")
    assert(player:GetActiveItem(0) == BC, "Equip Blank Card first")
    assert(not player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY), "Remove Car Battery for the single-use smoke")
    assert(Game():GetRoom():IsClear(), "Start in a cleared disposable room")
    state = {status = "running", mode = mode, uses = 0, startFrame = Game():GetFrameCount()}
    emit("batch_started", snapshot())
    add(ModCallbacks.MC_INPUT_ACTION, function(_, entity, hook, action)
        if action ~= ButtonAction.ACTION_ITEM or not entity then return end
        local actor = entity:ToPlayer()
        if not actor or GetPtrHash(actor) ~= GetPtrHash(player) then return end
        local pressed = Game():GetFrameCount() == pulseFrame
        if hook == InputHook.GET_ACTION_VALUE then return pressed and 1 or 0 end
        if hook == InputHook.IS_ACTION_PRESSED or hook == InputHook.IS_ACTION_TRIGGERED then return pressed end
    end)
    add(ModCallbacks.MC_USE_ITEM, function(_, _, _, actor, flags, slot, varData)
        if GetPtrHash(actor) ~= GetPtrHash(player) then return end
        state.uses = state.uses + 1
        emit("batch_native_use", {flags = flags, slot = slot, varData = varData, state = snapshot()})
    end, BC)
    add(ModCallbacks.MC_POST_UPDATE, function()
        if Game():GetFrameCount() - state.startFrame > 600 then
            finish("error", "Batch frame budget exceeded")
            return
        end
        if not wakeFrame or Game():GetFrameCount() >= wakeFrame then
            local ok, result = coroutine.resume(task)
            if not ok then finish("error", tostring(result))
            elseif task then wakeFrame = result end
        end
    end)
    add(ModCallbacks.MC_PRE_GAME_EXIT, function() batch.Stop() end)
    task, wakeFrame = coroutine.create(run), nil
    print("OUP Blank Card batch started; close console and wait five seconds")
end

function batch.Status()
    print(json.encode(state))
    return state
end

function batch.Stop()
    if state.status == "running" then finish("stopped", "Owner stopped the disposable fixture") end
    detach()
    task = nil
end

OUPBlankCardBatch = batch
return batch
