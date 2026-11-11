-- Keep native Void rewards, stored abilities and charge handling. Only remove
-- ordinary choice links while the engine performs this absorption event.
local mod = RegisterMod("Void Choice Unnerf", 1)
local pending = {}

function mod:restoreChoices()
    for _, entry in ipairs(pending) do
        local pickup = entry.pickup
        if pickup:Exists() and pickup.InitSeed == entry.seed
            and pickup.SubType == entry.item and pickup.OptionsPickupIndex == 0 then
            pickup.OptionsPickupIndex = entry.index
        end
    end
    pending = {}
end

function mod:preUseItem(item)
    if item ~= CollectibleType.COLLECTIBLE_VOID
        or not openUnnerfPack.Config.IsEnabled("voidChoiceAbsorption") then return end

    local level = Game():GetLevel()
    if level:GetCurrentRoomIndex() == GridRooms.ROOM_GENESIS_IDX then return end
    local current = level:GetCurrentRoomDesc()
    -- Off-grid rooms (including Angel/Boss Rush/debug rooms) can return the
    -- same descriptor for every dimension. Only on-grid dimension 2 identifies
    -- Death Certificate; never classify an off-grid alias as that selection.
    if current.SafeGridIndex >= 0 then
        local certificate = level:GetRoomByIdx(current.SafeGridIndex, 2)
        if certificate.Data and GetPtrHash(certificate) == GetPtrHash(current) then return end
    end

    local groups = {}
    for _, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)) do
        local pickup = entity:ToPickup()
        if pickup and pickup:Exists() and pickup.SubType > 0 and pickup.Price == 0
            and not pickup.Touched and pickup.OptionsPickupIndex ~= 0 then
            local index = pickup.OptionsPickupIndex
            groups[index] = groups[index] or {}
            groups[index][#groups[index] + 1] = pickup
        end
    end
    for index, group in pairs(groups) do
        if #group > 1 then
            -- Keep one native option marker for room events such as Boss Rush.
            -- Its alternatives no longer share that marker, so native choice
            -- cleanup cannot discard their rewards during the same Void use.
            for position = 2, #group do
                local pickup = group[position]
                pending[#pending + 1] = {pickup = pickup, index = index,
                    seed = pickup.InitSeed, item = pickup.SubType}
                pickup.OptionsPickupIndex = 0
            end
        end
    end
    -- Return nil: a non-nil PRE_USE_ITEM result can block later callbacks or
    -- cancel native behavior. Never replay Void or grant absorbed items here.
end

mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.preUseItem, CollectibleType.COLLECTIBLE_VOID)
-- MC_USE_ITEM sees native pickups before their deferred removal is complete.
-- The first subsequent update is the restoration point verified by the probe.
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.restoreChoices)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.restoreChoices)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.restoreChoices)
openUnnerfPack.Config.AddRunStartListener(function() mod:restoreChoices() end)

return mod
