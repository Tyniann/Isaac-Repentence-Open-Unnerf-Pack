local mod = RegisterMod("Open Unnerf Pack Blank Card Jera", 1)
local BLANK_CARD = CollectibleType.COLLECTIBLE_BLANK_CARD

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, _, _, player, _, slot)
    if not openUnnerfPack.Config.IsEnabled("blankCardJera")
        or player:GetCard(0) ~= Card.RUNE_JERA then return end
    -- A mimicked Blank Card effect must not replace another active item.
    if slot < 0 or player:GetActiveItem(slot) ~= BLANK_CARD then return end

    -- Match native Blank Card's card-use flags and let Jera handle duplication.
    player:UseCard(Card.RUNE_JERA, UseFlag.USE_MIMIC | UseFlag.USE_NOANNOUNCER)
    if player:GetActiveItem(slot) == BLANK_CARD then
        -- Native Blank Card changes its NEXT recharge cost after use. Updating
        -- the existing active's VarData preserves its charge and ownership on
        -- J460; do not replace the current bar when the held consumable changes.
        player:AddCollectible(BLANK_CARD, player:GetActiveCharge(slot), false, slot, 4)
    end
    -- Nil preserves native discharge, animation and Car Battery handling.
end, BLANK_CARD)

return mod
