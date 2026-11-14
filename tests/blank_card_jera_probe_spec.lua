-- Observer contract only; no Isaac charge or Blank Card behavior is simulated.
local dkjson = require("dkjson")
package.preload.json = function() return {encode = dkjson.encode} end

ModCallbacks = {MC_POST_GAME_STARTED = 1, MC_USE_ITEM = 2,
    MC_USE_CARD = 3, MC_POST_PEFFECT_UPDATE = 4}
CollectibleType = {COLLECTIBLE_BLANK_CARD = 286}

local registrations, removals, lines = {}, {}, {}
local mod = {}
function RegisterMod(name, version)
    assert(name == "OUP Blank Card Jera Probe" and version == 1)
    return mod
end
function mod:AddCallback(id, fn, filter)
    registrations[#registrations + 1] = {id = id, fn = fn, filter = filter}
end
function mod:RemoveCallback(id, fn)
    local found
    for index, entry in ipairs(registrations) do
        if entry.id == id and entry.fn == fn then
            found = index
            break
        end
    end
    assert(found, "Stop must remove the exact registered callback")
    table.remove(registrations, found)
    removals[#removals + 1] = {id = id, fn = fn}
end

local player = {InitSeed = 321, card = 45, secondCard = 0, pill = 0,
    active = 286, charge = 2, battery = 0}
function player:GetPlayerType() return 0 end
function player:GetCard(slot) return slot == 0 and self.card or self.secondCard end
function player:GetPill() return self.pill end
function player:GetActiveItem(slot)
    assert(slot >= 0 and slot <= 3)
    return slot == 0 and self.active or 0
end
function player:GetActiveCharge(slot)
    assert(slot >= 0 and slot <= 3)
    return slot == 0 and self.charge or 0
end
function player:GetBatteryCharge(slot)
    assert(slot >= 0 and slot <= 3)
    return slot == 0 and self.battery or 0
end

local game = {Difficulty = 0, frame = 100, seed = 987654, players = 1}
function game:GetFrameCount() return self.frame end
function game:GetSeeds() return {GetStartSeed = function() return game.seed end} end
function game:GetNumPlayers() return self.players end
function Game() return game end
Isaac = {GetPlayer = function(index) assert(index == 0); return player end,
    DebugString = function(line) lines[#lines + 1] = line end}

local function records()
    local result = {}
    for _, line in ipairs(lines) do
        local prefix, payload = line:match("^(OUP_BLANK_CARD )(.+)$")
        assert(prefix, "observer logs must use the stable prefix")
        local record, _, err = dkjson.decode(payload)
        assert(not err, err)
        result[#result + 1] = record
    end
    return result
end

local function callback(id)
    for _, entry in ipairs(registrations) do
        if entry.id == id then return entry end
    end
    error("missing callback " .. id)
end

local probe = dofile("tools/validation/blank-card-jera-probe.lua")
assert(#registrations == 4 and #lines == 0,
    "loading the separate observer must be passive")
assert(probe == OUPBlankCardProbe)
assert(callback(ModCallbacks.MC_USE_ITEM).filter == 286,
    "only Blank Card is observed at MC_USE_ITEM")

callback(ModCallbacks.MC_POST_GAME_STARTED).fn(mod, false)
local captured = records()
assert(#captured == 2 and captured[1].event == "game_started"
    and captured[1].details.continued == false)
assert(captured[2].event == "snapshot" and captured[2].label == "baseline")
local initial = captured[2].details[1]
assert(initial.seed == 321 and initial.card == 45 and initial.slots[1].item == 286
    and initial.slots[1].charge == 2 and initial.slots[1].battery == 0)

local use = callback(ModCallbacks.MC_USE_ITEM).fn(mod, 286, {}, player, 4, 0, 0)
assert(use == nil, "native Blank Card effect and discharge handling must remain intact")
captured = records()
assert(captured[#captured].event == "blank_card_use")
assert(captured[#captured].details.item == 286
    and captured[#captured].details.flags == 4
    and captured[#captured].details.slot == 0
    and captured[#captured].details.varData == 0)

local changed = callback(ModCallbacks.MC_POST_PEFFECT_UPDATE).fn
changed(mod, player)
local afterFirst = #records()
changed(mod, player)
assert(#records() == afterFirst, "unchanged player state must be deduplicated")
player.charge, player.card = 0, 45
changed(mod, player)
assert(#records() == afterFirst + 1, "changed state must be logged once")
changed(mod, player)
assert(#records() == afterFirst + 1)

local registered = {}
for _, entry in ipairs(registrations) do registered[#registered + 1] = entry end
probe.Stop()
assert(#registrations == 0 and #removals == 4 and OUPBlankCardProbe == nil)
for _, entry in ipairs(registered) do
    local found = false
    for _, removed in ipairs(removals) do
        if removed.id == entry.id and removed.fn == entry.fn then found = true end
    end
    assert(found, "Stop must remove each exact callback reference")
end
print("Blank Card/Jera observer contracts passed; native behavior untested")
