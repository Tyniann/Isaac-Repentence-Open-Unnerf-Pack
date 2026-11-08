local mawofvoidunnerf = RegisterMod("mawofvoidunnerf", 1)
local mawofvoid = CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID

function mawofvoidunnerf:blackheats(laser)
    if not openUnnerfPack.Config.IsEnabled("mawOfTheVoid") then return end
    local spawner = laser.SpawnerEntity
    if spawner and spawner:ToPlayer() and
        laser:GetSprite():GetFilename() == "gfx/007.001.003_Dark Ring.anm2" then
        laser.BlackHpDropChance = 0.05
    end
end

function mawofvoidunnerf:statChange(player, flag)
    if not openUnnerfPack.Config.IsEnabled("mawOfTheVoid") then return end
    if flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + player:GetCollectibleNum(mawofvoid)
    end
end

function mawofvoidunnerf:update(player)
    if not openUnnerfPack.Config.IsEnabled("mawOfTheVoid") then return end
    local data = player:GetData()
    local count = player:GetCollectibleNum(mawofvoid)
    if data.openUnnerfMawCount ~= count then
        data.openUnnerfMawCount = count
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end
end

mawofvoidunnerf:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, mawofvoidunnerf.blackheats)
mawofvoidunnerf:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mawofvoidunnerf.statChange)
mawofvoidunnerf:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mawofvoidunnerf.update)
