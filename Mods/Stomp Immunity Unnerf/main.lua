local pyromaniacunnerf = RegisterMod("pyromaniacunnerf",1)

function pyromaniacunnerf:takeDamage(target, amount, flags)
    local isCrush = (flags & DamageFlag.DAMAGE_CRUSH) ~= 0
    if (target.Type == EntityType.ENTITY_PLAYER and (isCrush)) then
        local player = target:ToPlayer()
        if (player:HasCollectible(CollectibleType.COLLECTIBLE_PYROMANIAC) or player:HasCollectible(CollectibleType.COLLECTIBLE_HOST_HAT)) then
            if (player:HasCollectible(CollectibleType.COLLECTIBLE_PYROMANIAC)) then --heal one red heart (two half-heart units) on cancelled crush damage
                player:AddHearts(2)
            end
            return false
        end

    end
end

pyromaniacunnerf:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, pyromaniacunnerf.takeDamage)
