local mod = RegisterMod("Open Unnerf Pack Blank Card Jera", 1)
local BLANK_CARD = CollectibleType.COLLECTIBLE_BLANK_CARD
local pending = {}
local carBatteryUses = {}

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, _, _, player, flags, slot)
    if not openUnnerfPack.Config.IsEnabled("blankCardJera") then return end
    local key = GetPtrHash(player)
    if slot < 0 then
        -- Native Car Battery replays have no active slot on J460. Accept one
        -- only after this player's owned Blank Card use in the current update;
        -- its original callback already owns the next-cost change.
        if flags & UseFlag.USE_CARBATTERY == 0 then return end
        local original = carBatteryUses[key]
        carBatteryUses[key] = nil
        if original and original.seed == player.InitSeed
            and player:GetActiveItem(original.slot) == BLANK_CARD
            and player:GetCard(0) == Card.RUNE_JERA then
            player:UseCard(Card.RUNE_JERA, UseFlag.USE_MIMIC | UseFlag.USE_NOANNOUNCER)
        end
        return
    end
    carBatteryUses[key] = nil
    -- A mimicked Blank Card effect must not replace another active item.
    if player:GetActiveItem(slot) ~= BLANK_CARD then return end
    local entry = pending[key]
    if entry then entry.slots[slot] = nil end -- A later non-Jera use wins.
    if player:GetCard(0) ~= Card.RUNE_JERA then return end
    local charge = player:GetActiveCharge(slot)

    -- Match native Blank Card's card-use flags and let Jera handle duplication.
    player:UseCard(Card.RUNE_JERA, UseFlag.USE_MIMIC | UseFlag.USE_NOANNOUNCER)
    if player:GetActiveItem(slot) == BLANK_CARD then
        carBatteryUses[key] = {seed = player.InitSeed, slot = slot}
    end
    if charge ~= 4 and player:GetActiveItem(slot) == BLANK_CARD then
        -- A charged native use with a four-charge bar already has the desired
        -- capacity. Otherwise wait for native discharge to spend/move Battery
        -- charge: reinserting the active during USE_ITEM clears that reserve.
        if not entry or entry.seed ~= player.InitSeed then
            entry = {seed = player.InitSeed, slots = {}}
            pending[key] = entry
        end
        entry.slots[slot] = true
    end
    -- Nil preserves native discharge, animation and Car Battery handling.
end, BLANK_CARD)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
    local key = GetPtrHash(player)
    carBatteryUses[key] = nil
    local entry = pending[key]
    if not entry then return end
    pending[key] = nil
    if entry.seed ~= player.InitSeed or not openUnnerfPack.Config.IsEnabled("blankCardJera") then return end
    for slot in pairs(entry.slots) do
        if player:GetActiveItem(slot) == BLANK_CARD then
            if player:GetBatteryCharge(slot) == 0 then
                player:AddCollectible(BLANK_CARD, player:GetActiveCharge(slot), false, slot, 4)
            else
                -- Never erase charge if an effect was invoked outside normal
                -- player-update timing. Retry at the next safe player update.
                pending[key] = pending[key] or {seed = entry.seed, slots = {}}
                pending[key].slots[slot] = true
            end
        end
    end
end)
local function reset() pending, carBatteryUses = {}, {} end
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, reset)
openUnnerfPack.Config.AddRunStartListener(reset)

return mod
