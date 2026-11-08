local pyromaniacunnerf = RegisterMod("pyromaniacunnerf",1)

function pyromaniacunnerf:takeDamage(target, amount, flags, source)
    if not openUnnerfPack.Config.IsEnabled("stompImmunity") then return end
    if target.Type ~= EntityType.ENTITY_PLAYER then
        return
    end

    local isCrush = (flags & DamageFlag.DAMAGE_CRUSH) ~= 0
    local damageSource = source and source.Entity
    -- Mom's boss foot also deals unflagged contact damage during its stomp,
    -- even after the crush impact was cancelled (Repentance+ 1.9.7.17).
    local isMomFootContact = flags == 0 and damageSource ~= nil
        and damageSource.Type == EntityType.ENTITY_MOM
        and damageSource.Variant == 10
        and damageSource:GetSprite():IsPlaying("Stomp")

    if not (isCrush or isMomFootContact) then
        return
    end

    local player = target:ToPlayer()
    local hasPyromaniac = player:HasCollectible(CollectibleType.COLLECTIBLE_PYROMANIAC)
    if hasPyromaniac or player:HasCollectible(CollectibleType.COLLECTIBLE_HOST_HAT) then
        -- Heal one full red heart for the crush impact only. The foot's
        -- additional contact events must not grant more healing.
        if hasPyromaniac and isCrush then
            player:AddHearts(2)
        end
        return false
    end
end

pyromaniacunnerf:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, pyromaniacunnerf.takeDamage)
