-- Execute once in the disposable native feasibility run. The verified batch
-- must already be loaded and idle. This probe may replace the held Blank Card
-- through AddCollectible if no direct per-slot accessor exists; it records all
-- observable ownership/charge changes and stops if their invariants fail.
local json = require("json")
local mod = RegisterMod("OUP Blank Card Capacity Probe", 1)
local p = Isaac.GetPlayer(0)
local state = {status = "running"}
local pending, child, update, exit
local start = Game():GetFrameCount()
local BC = CollectibleType.COLLECTIBLE_BLANK_CARD

local function field(name)
    local ok, value = pcall(function() return p[name] end)
    return ok and type(value) or "lookup_error"
end

local function snapshot()
    local slots = {}
    for slot = 0, 3 do
        slots[#slots + 1] = {item = p:GetActiveItem(slot), charge = p:GetActiveCharge(slot),
            battery = p:GetBatteryCharge(slot)}
    end
    return {slots = slots, count = p:GetCollectibleNum(BC, true),
        total = p:GetCollectibleCount(), card = p:GetCard(0),
        pedestals = #Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, BC, false, false)}
end

local function emit(event, details)
    Isaac.DebugString("OUP_BLANK_CARD " .. json.encode({label = "capacity",
        event = event, frame = Game():GetFrameCount(), seed = Game():GetSeeds():GetStartSeed(), details = details}))
end

local function finish(status, message)
    state.status, state.message = status, message
    if pending and pending:Exists() then pending:Remove() end
    pending = nil
    if update then mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, update) end
    if exit then mod:RemoveCallback(ModCallbacks.MC_PRE_GAME_EXIT, exit) end
    update, exit = nil, nil
    emit("capacity_" .. status, {message = message, method = state.method, state = snapshot()})
    print("OUP Blank Card capacity: " .. status .. (message and (" - " .. message) or ""))
end

function state.Status() print(json.encode({status = state.status, message = state.message, method = state.method})) end
function state.Stop()
    if state.status ~= "running" then return end
    if child and child.status == "running" then OUPBlankCardBatch.Stop() end
    finish("stopped", "Owner stopped capacity probe")
end
OUPBlankCardCapacity = state

assert(Game():GetNumPlayers() == 1 and p:GetPlayerType() == PlayerType.PLAYER_ISAAC,
    "Capacity probe requires one disposable Isaac")
assert(p:GetActiveItem(0) == BC and p:GetCard(0) == Card.RUNE_JERA,
    "Capacity probe requires held Blank Card and Jera")
assert(OUPBlankCardBatch.Status().status ~= "running", "Wait for the other batch to finish")
local before = snapshot()
assert(before.slots[1].charge > 0 and before.slots[1].charge < 4,
    "Run the native Magician-to-Jera transitions first; expected an inherited partial charge")
emit("capacity_before", {state = before, api = {
    SetActiveVarData = field("SetActiveVarData"), GetActiveItemDesc = field("GetActiveItemDesc"),
    GetActiveMaxCharge = field("GetActiveMaxCharge"), SecondaryActiveItem = field("SecondaryActiveItem"),
    NeedsCharge = field("NeedsCharge")}})

local ok, err = pcall(function()
    if field("SetActiveVarData") == "function" then
        state.method = "SetActiveVarData"
        p:SetActiveVarData(4, 0)
    elseif field("GetActiveItemDesc") == "function" then
        state.method = "GetActiveItemDesc.VarData"
        p:GetActiveItemDesc(0).VarData = 4
    else
        state.method = "AddCollectible"
        p:AddCollectible(BC, before.slots[1].charge, false, 0, 4)
    end
end)
if not ok then finish("error", tostring(err)); return end
local after = snapshot()
emit("capacity_after_write", after)
if json.encode(before) ~= json.encode(after) then
    -- Compare fields explicitly: native JSON object key order need not be stable.
    local same = before.count == after.count and before.total == after.total
        and before.card == after.card and before.pedestals == after.pedestals
    for slot = 1, 4 do
        for _, key in ipairs({"item", "charge", "battery"}) do
            same = same and before.slots[slot][key] == after.slots[slot][key]
        end
    end
    if not same then finish("rejected", "Capacity write changed ownership, slots, card or charge"); return end
end

update = function()
    local succeeded, failure = pcall(function()
        local elapsed = Game():GetFrameCount() - start
        if elapsed > 300 then finish("error", "Capacity probe frame budget exceeded"); return end
        if child then
            if child.status ~= "running" then finish(child.status, child.message) end
            return
        end
        if elapsed < 3 then return end
        if not pending then
            if not p:NeedsCharge(0) then finish("unsupported", "Native slot still considers inherited charge full"); return end
            pending = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY,
                BatterySubType.BATTERY_NORMAL, p.Position, Vector.Zero, nil):ToPickup()
            pending.Wait = 0
            emit("capacity_battery_spawned", {pickupSeed = pending.InitSeed, state = snapshot()})
        elseif not pending:Exists() then
            pending = nil
            emit("capacity_battery_collected", snapshot())
            if p:GetActiveCharge(0) ~= 4 then finish("rejected", "Native full battery did not restore four charges"); return end
            OUPBlankCardBatch.Run()
            child = OUPBlankCardBatch.Status()
        end
    end)
    if not succeeded then finish("error", tostring(failure)) end
end
exit = function() state.Stop() end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, update)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, exit)
print("OUP Blank Card capacity started; close console for ten seconds")
