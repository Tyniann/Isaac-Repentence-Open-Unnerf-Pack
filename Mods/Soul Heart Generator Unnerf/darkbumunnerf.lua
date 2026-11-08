soulheartgeneratorUnnerf.darkbumunnerf = {  }
soulheartgeneratorUnnerf.darkbumunnerf.excludedChars = { PlayerType.PLAYER_THELOST, PlayerType.PLAYER_KEEPER, PlayerType.PLAYER_THELOST_B, PlayerType.PLAYER_KEEPER_B }

function soulheartgeneratorUnnerf.darkbumunnerf.pickupInit(pickup)
    local spawner = pickup.SpawnerEntity
    local familiar = spawner and spawner:ToFamiliar()
    if (familiar and familiar.Player and pickup.SpawnerType == EntityType.ENTITY_FAMILIAR and (pickup.Variant ~= PickupVariant.PICKUP_HEART or pickup.SubType ~= HeartSubType.HEART_SOUL )) then -- Pickup Spawned by familiar
        if (familiar.Variant == FamiliarVariant.DARK_BUM and not --Pickup Spawned by Dark Bum
            soulheartgeneratorUnnerf.darkbumunnerf:isCharacterExcluded(familiar.Player:GetPlayerType())) then --character is not excluded
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL)
        end

    end
end

function soulheartgeneratorUnnerf.darkbumunnerf.isCharacterExcluded(this ,charType)
    local isExcluded = false
    

    for i, exChar in ipairs(this.excludedChars) do 
        if exChar == charType then 
            isExcluded = true 
        end 
    end

    return isExcluded


end



