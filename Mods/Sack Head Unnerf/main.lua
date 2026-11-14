-- Native weighting/depletion is shared with the other pool-only unnerfs.
require("Mods/Pool Rules/main").Register("sackHead", 424, "OUP Sack Head Pool Entry")

local mod = RegisterMod("Open Unnerf Pack Sack Head", 1)
local pickupChances = {
    [PickupVariant.PICKUP_COIN] = 10,
    [PickupVariant.PICKUP_BOMB] = 20,
    [PickupVariant.PICKUP_KEY] = 20,
    [PickupVariant.PICKUP_TAROTCARD] = 20,
    [PickupVariant.PICKUP_LIL_BATTERY] = 20,
}
local trollBombs = {
    [BombVariant.BOMB_TROLL] = true,
    [BombVariant.BOMB_SUPERTROLL] = true,
    [BombVariant.BOMB_GOLDENTROLL] = true,
}

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN,
    function(_, kind, variant, _, _, _, spawner, seed)
        -- The native source pilot observes the actual sack entity here. Other
        -- origins, including player-created pickups, retain their native rules.
        if not spawner or spawner.Type ~= EntityType.ENTITY_PICKUP
            or spawner.Variant ~= PickupVariant.PICKUP_GRAB_BAG then return end
        local chance
        if kind == EntityType.ENTITY_PICKUP then
            chance = pickupChances[variant]
        elseif kind == EntityType.ENTITY_BOMB and trollBombs[variant] then
            chance = 20
        end
        if not chance or not openUnnerfPack.Config.IsEnabled("sackHead") or seed == 0 then return end
        local owned = false
        for index = 0, Game():GetNumPlayers() - 1 do
            if Isaac.GetPlayer(index):HasCollectible(424) then owned = true; break end
        end
        if not owned then return end

        -- Use a private draw from the immutable spawn seed. Repeated callbacks
        -- for the same spawn cannot supply another chance or advance native
        -- pickup/item RNG. Converted sacks use this same hook for their rewards.
        local rng = RNG()
        rng:SetSeed(seed, 35)
        if rng:RandomInt(100) < chance then
            return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0, seed}
        end
    end)
