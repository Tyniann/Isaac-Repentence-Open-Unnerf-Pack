-- Disposable-run API feasibility probe for #16. Not loaded by production.
-- Start prepares two real, linked active pedestals; it never uses Void for you.
-- Only the experimental "detach" mode changes their option indices.
assert(OUPVoidProbe == nil, "Void probe already loaded; use Status or Stop")
local json = require("json")
local mod = RegisterMod("OUP Void choice feasibility probe", 1)
local probe, active = {}, nil
OUPVoidProbe = probe
local callbacks = {}

local function emit(kind, fields)
    fields = fields or {}
    fields.kind = kind
    fields.label = active and active.label or "idle"
    fields.frame = Game():GetFrameCount()
    fields.seed = Game():GetSeeds():GetStartSeed()
    Isaac.DebugString("OUP_VOID " .. json.encode(fields))
end

local function state()
    local game, player = Game(), Isaac.GetPlayer(0)
    local desc = game:GetLevel():GetCurrentRoomDesc()
    local pickups = {}
    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        local p = entity:ToPickup()
        if p and p.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            pickups[#pickups + 1] = {seed = p.InitSeed, item = p.SubType,
                options = p.OptionsPickupIndex, price = p.Price, touched = p.Touched,
                animation = p:GetSprite():GetAnimation(), frame = p.FrameCount}
        end
    end
    return {playerType = player:GetPlayerType(), difficulty = game.Difficulty,
        roomType = game:GetRoom():GetType(), roomIndex = game:GetLevel():GetCurrentRoomIndex(),
        roomVariant = desc.Data and desc.Data.Variant,
        stage = game:GetLevel():GetStage(), roomSeed = desc.SpawnSeed,
        charge = player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY),
        activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY),
        shadowsOwned = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, true),
        revelationsOwned = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS, true),
        soulHearts = player:GetSoulHearts(),
        shadowsEffect = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS),
        pickups = pickups, repentogon = REPENTOGON ~= nil,
        mcm = ModConfigMenu ~= nil,
        packVoidSetting = openUnnerfPack and openUnnerfPack.Config
            and openUnnerfPack.Config.IsEnabled("voidChoiceAbsorption") or false}
end

local function restore()
    if not active then return end
    for _, entry in ipairs(active.detached) do
        if entry.pickup:Exists() and entry.pickup.OptionsPickupIndex == 0 then
            entry.pickup.OptionsPickupIndex = entry.index
        end
    end
    active.detached = {}
end

callbacks.pre = function(_, item, _, player, flags, slot)
    if not active then return end
    if item ~= CollectibleType.COLLECTIBLE_VOID then
        emit("pre_other_active", {item = item, flags = flags, slot = slot})
        return
    end
    emit("pre_void", state())
    if active.mode == "detach" then
        for _, pickup in ipairs(active.fixtures) do
            if pickup:Exists() and pickup.SubType > 0 and pickup.Price == 0
                and pickup.OptionsPickupIndex ~= 0 then
                active.detached[#active.detached + 1] = {pickup = pickup, index = pickup.OptionsPickupIndex}
                pickup.OptionsPickupIndex = 0
                assert(pickup.OptionsPickupIndex == 0, "option index write failed")
            end
        end
        emit("detached", state())
    end
    active.uses = active.uses + 1
    active.pending = true
end
callbacks.use = function(_, item, _, _, flags, slot)
    if not active then return end
    emit(item == CollectibleType.COLLECTIBLE_VOID and "use_void" or "use_other_active",
        {item = item, flags = flags, slot = slot, observed = state()})
end
callbacks.tick = function()
    if not active or not active.pending then return end
    emit("next_update", state())
    restore()
    active.pending = false
    emit("restored", state())
    print("OUP_VOID_OBSERVED", active.label, active.uses)
end
callbacks.room = function()
    if active then restore(); emit("room_changed", state()) end
end
callbacks.exit = function() if active then restore() end end

function probe.Start(mode, label)
    assert(not active, "one disposable fixture at a time; Stop first")
    assert(mode == "baseline" or mode == "detach", "expected baseline or detach")
    assert(type(label) == "string" and label ~= "", "label required")
    local game, player = Game(), Isaac.GetPlayer(0)
    assert(game:GetNumPlayers() == 1 and game.Difficulty == Difficulty.DIFFICULTY_NORMAL,
        "single-player Normal disposable run required")
    assert(game:GetRoom():IsClear() and #Isaac.FindByType(EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_COLLECTIBLE, -1, false, false) == 0,
        "empty cleared room required; existing pedestals will not be removed")
    assert(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == CollectibleType.COLLECTIBLE_VOID,
        "start with Void in the primary active slot")
    assert(not player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY), "no Car Battery in pilot")
    assert(player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, true) == 0
        and player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS, true) == 0,
        "start without the fixture items")
    active = {mode = mode, label = label, fixtures = {}, detached = {}, uses = 0}
    emit("before_fixture", state())
    for index, item in ipairs({CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS,
        CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS}) do
        local position = game:GetRoom():GetCenterPos() + Vector(index == 1 and -80 or 80, -60)
        assert(player.Position:Distance(position) > 40, "move below the room center first")
        local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
            item, position, Vector.Zero, nil):ToPickup()
        active.fixtures[#active.fixtures + 1] = pickup
        pickup.OptionsPickupIndex = 916
        assert(pickup.OptionsPickupIndex == 916, "fixture grouping write failed")
    end
    player:SetActiveCharge(4, ActiveSlot.SLOT_PRIMARY)
    emit("fixture_ready", state())
    print("OUP_VOID_READY", label, mode)
end

function probe.Status()
    emit("status", state())
    print("OUP_VOID_STATUS", active and active.label or "idle", active and active.uses or 0)
end

function probe.Stop()
    restore()
    if active then
        for _, pickup in ipairs(active.fixtures) do if pickup:Exists() then pickup:Remove() end end
        emit("stopped_discard_run", state())
    end
    active = nil
    mod:RemoveCallback(ModCallbacks.MC_PRE_USE_ITEM, callbacks.pre)
    mod:RemoveCallback(ModCallbacks.MC_USE_ITEM, callbacks.use)
    mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, callbacks.tick)
    mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, callbacks.room)
    mod:RemoveCallback(ModCallbacks.MC_PRE_GAME_EXIT, callbacks.exit)
    OUPVoidProbe = nil
    print("OUP_VOID_STOPPED_DISCARD_RUN")
end

mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, callbacks.pre)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, callbacks.use)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, callbacks.tick)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, callbacks.room)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, callbacks.exit)
print("OUP_VOID_PROBE_LOADED")
