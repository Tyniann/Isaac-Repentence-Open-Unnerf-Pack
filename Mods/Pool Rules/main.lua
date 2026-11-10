-- A helper ID is one native pool identity. Lua translates its output, while
-- Isaac owns weighting, depletion and saved pool state.
-- Registration requires XML mirroring ALL pools of the original collectible:
-- removal is global. Keep this list in sync with the supported game's data.
local rules = {}
local byHelper, registeredKeys, targets = {}, {}, {}
local mod = RegisterMod("Open Unnerf Pack pool rules", 1)

local function syncOwnership(rule)
    local owned = false
    for index = 0, Game():GetNumPlayers() - 1 do
        if Isaac.GetPlayer(index):HasCollectible(rule.collectible, true) then owned = true; break end
    end
    if not owned then
        rule.collected = false -- Also handles losing an item through a native rewind.
    elseif not rule.collected and openUnnerfPack.Config.IsEnabled(rule.key) then
        Game():GetItemPool():RemoveCollectible(rule.helper)
        rule.collected = true
    end
end

function rules.Register(key, collectible, helperName)
    assert(not registeredKeys[key] and not targets[collectible], "duplicate pool rule")
    local helper = Isaac.GetItemIdByName(helperName)
    if helper <= 0 then
        if Isaac.DebugString then Isaac.DebugString("OUP_POOL_RULE missing helper: " .. helperName) end
        return false -- An incomplete install must not disable the other unnerfs.
    end
    assert(helper ~= collectible and not byHelper[helper], "invalid pool helper")
    local rule = {key = key, collectible = collectible, helper = helper, collected = false}
    registeredKeys[key], targets[collectible], byHelper[helper] = rule, rule, rule
    return true
end

openUnnerfPack.Config.AddRunStartListener(function()
    local pool = Game():GetItemPool()
    for _, rule in pairs(registeredKeys) do
        rule.collected = false
        -- Never add/reset weights here: Continue restores native pool state.
        -- One complete helper identity mirrors every pool of the original ID.
        local enabled = openUnnerfPack.Config.IsEnabled(rule.key)
        local items = Isaac.GetItemConfig()
        local original, helper = items:GetCollectible(rule.collectible), items:GetCollectible(rule.helper)
        local metadataMatches = original and helper and original.Quality == helper.Quality
            and original.Tags == helper.Tags and original.Type == helper.Type
        local excluded = enabled and metadataMatches and rule.collectible or rule.helper
        local removed = pool:RemoveCollectible(excluded)
        if Isaac.DebugString then
            Isaac.DebugString("OUP_POOL_RULE " .. rule.key .. " enabled=" .. tostring(enabled)
                .. " metadata=" .. tostring(not not metadataMatches) .. " excluded=" .. excluded
                .. " removed=" .. tostring(removed))
        end
        syncOwnership(rule)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, function(_, selected)
    local rule = byHelper[selected]
    if rule then return rule.collectible end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    for _, rule in pairs(registeredKeys) do
        -- D4/Tainted Eden can grant helpers without going through the normal
        -- selection callback (the Racing+ placeholder implementation handles
        -- this path too). Never leave a private helper in the inventory.
        if player:HasCollectible(rule.helper, true) then
            local copies = player:GetCollectibleNum(rule.helper, true)
            for _ = 1, copies do player:RemoveCollectible(rule.helper) end
            if not player:HasCollectible(rule.collectible, true) then
                player:AddCollectible(rule.collectible)
            end
        end
        syncOwnership(rule)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
    local rule = byHelper[pickup.SubType]
    if rule then
        -- Defensive path for direct/scripted helper spawns, which bypass rolls.
        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
            rule.collectible, true, true, true)
    end
end, PickupVariant.PICKUP_COLLECTIBLE)

return rules
