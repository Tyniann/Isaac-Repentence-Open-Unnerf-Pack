soulheartgeneratorUnnerf.relicunnerf = { }

function soulheartgeneratorUnnerf.relicunnerf.initRelicClearCount(familiar2)
    --Set Room Clear count to 2 if it's 0 (new relic)
	if (familiar2.Variant == FamiliarVariant.RELIC and (familiar2.RoomClearCount == 0)) then 
		familiar2.RoomClearCount = 2
    end
end

function soulheartgeneratorUnnerf.relicunnerf.pickupInit(pickup)
    local spawner = pickup.SpawnerEntity
    local familiar = spawner and spawner:ToFamiliar()
    if (familiar and pickup.SpawnerType == EntityType.ENTITY_FAMILIAR) then -- Pickup Spawned by familiar
        if (familiar.Variant == FamiliarVariant.RELIC) then --Pickup Spawned by Relic
            familiar.RoomClearCount = 2 --Reset Relic RoomClearCount to 2
        end

    end
end





