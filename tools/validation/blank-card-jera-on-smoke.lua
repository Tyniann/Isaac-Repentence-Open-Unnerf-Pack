-- Execute once after a fresh candidate start. The separate batch mod must
-- already have loaded OUPBlankCardBatch. Mutates only a disposable cleared room.
local json = require("json")
local mod = RegisterMod("OUP Blank Card On Smoke", 1)
local p = Isaac.GetPlayer(0)
local state = {status = "running", jeraUses = 0}
local child, update, cardUse, exit
local started = Game():GetFrameCount()
local BC = CollectibleType.COLLECTIBLE_BLANK_CARD
local kinds = {PickupVariant.PICKUP_COIN, PickupVariant.PICKUP_LIL_BATTERY, PickupVariant.PICKUP_CHEST}
local subtypes = {
    [PickupVariant.PICKUP_COIN] = CoinSubType.COIN_PENNY,
    [PickupVariant.PICKUP_LIL_BATTERY] = BatterySubType.BATTERY_NORMAL,
    [PickupVariant.PICKUP_CHEST] = ChestSubType.CHEST_CLOSED,
}

local function counts()
    local result = {}
    for _, variant in ipairs(kinds) do
        result[tostring(variant)] = #Isaac.FindByType(EntityType.ENTITY_PICKUP, variant, -1, false, false)
    end
    return result
end
local function snapshot()
    return {counts = counts(), card = p:GetCard(0), item = p:GetActiveItem(0),
        charge = p:GetActiveCharge(0), battery = p:GetBatteryCharge(0), count = p:GetCollectibleNum(BC, true)}
end
local function emit(event, details)
    Isaac.DebugString("OUP_BLANK_CARD " .. json.encode({label = "on-smoke", event = event,
        frame = Game():GetFrameCount(), seed = Game():GetSeeds():GetStartSeed(), details = details}))
end
local function finish(status, message)
    state.status, state.message = status, message
    emit("on_smoke_" .. status, {message = message, jeraUses = state.jeraUses, state = snapshot()})
    if child and child.status == "running" then OUPBlankCardBatch.Stop() end
    if update then mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, update) end
    if cardUse then mod:RemoveCallback(ModCallbacks.MC_USE_CARD, cardUse) end
    if exit then mod:RemoveCallback(ModCallbacks.MC_PRE_GAME_EXIT, exit) end
    update, cardUse, exit = nil, nil, nil
    -- The precondition below requires an empty pickup room. All remaining
    -- pickups were created by this fixture, its native Jera use or its battery.
    for _, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, -1, -1, false, false)) do entity:Remove() end
    emit("on_smoke_cleanup", {remainingPickups = #Isaac.FindByType(EntityType.ENTITY_PICKUP, -1, -1, false, false)})
    print("OUP Blank Card On smoke: " .. status .. (message and (" - " .. message) or ""))
end
function state.Status() print(json.encode({status = state.status, message = state.message, jeraUses = state.jeraUses})) end
function state.Stop() if state.status == "running" then finish("stopped", "Owner stopped fixture") end end
OUPBlankCardOnSmoke = state

assert(Game():GetNumPlayers() == 1 and p:GetPlayerType() == PlayerType.PLAYER_ISAAC,
    "Start a fresh Normal Isaac run")
assert(openUnnerfPack.Config.IsEnabled("blankCardJera"), "Blank Card + Jera must be enabled")
assert(Game():GetRoom():IsClear(), "Use a cleared disposable room")
assert(#Isaac.FindByType(EntityType.ENTITY_PICKUP, -1, -1, false, false) == 0,
    "Use an empty starting room; fixture must not remove existing pickups")
assert(p:GetActiveItem(0) == 105 or p:GetActiveItem(0) == 0, "Start with only Isaac's D6 or an empty active slot")
if p:GetActiveItem(0) == 105 then p:RemoveCollectible(105) end
p:AddCollectible(BC, 4, false, 0, 4) -- Initial disposable fixture grant only.
p:SetCard(0, Card.RUNE_JERA)
local center = Game():GetRoom():GetCenterPos()
for index, variant in ipairs(kinds) do
    local desired = center + Vector(120, (index - 2) * 70)
    local position = Game():GetRoom():FindFreePickupSpawnPosition(desired, 0, true)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, variant, subtypes[variant], position, Vector.Zero, nil)
end
emit("on_smoke_started", snapshot())
cardUse = function(_, card, actor, flags)
    if card == Card.RUNE_JERA and GetPtrHash(actor) == GetPtrHash(p) then
        state.jeraUses = state.jeraUses + 1
        emit("on_smoke_jera", {flags = flags, state = snapshot()})
    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, cardUse)
update = function()
    local ok, message = pcall(function()
        if Game():GetFrameCount() - started > 300 then finish("error", "Frame budget exceeded"); return end
        if child.status == "running" then return end
        assert(child.status == "complete", child.message or "Native activation/battery smoke failed")
        local result = snapshot()
        for _, variant in ipairs(kinds) do assert(result.counts[tostring(variant)] == 2, "Native Jera did not double variant " .. variant) end
        assert(state.jeraUses == 1, "Expected exactly one Jera dispatch")
        assert(result.card == Card.RUNE_JERA and result.item == BC and result.count == 1,
            "Held rune, active identity or ownership changed")
        assert(result.charge == 4 and result.battery == 0, "Native full battery must restore four charges")
        finish("complete")
    end)
    if not ok then finish("error", tostring(message)) end
end
exit = function() state.Stop() end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, update)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, exit)
OUPBlankCardBatch.Run()
child = OUPBlankCardBatch.Status()
print("OUP Blank Card On smoke started; close console for five seconds")
