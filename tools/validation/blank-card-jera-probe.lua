-- Disposable, read-only native observer for issue #19. Production never loads it.
-- Stage as a separate diagnostic mod; all gameplay inputs remain native.
local json = require("json")
local mod = RegisterMod("OUP Blank Card Jera Probe", 1)
local probe = {}
local callbacks, previous = {}, {}
local label = "baseline"
local sequence = 0

local function playerState(player)
    local slots = {}
    for slot = 0, 3 do
        slots[#slots + 1] = {slot = slot, item = player:GetActiveItem(slot),
            charge = player:GetActiveCharge(slot), battery = player:GetBatteryCharge(slot)}
    end
    return {seed = player.InitSeed, type = player:GetPlayerType(),
        card = player:GetCard(0), secondCard = player:GetCard(1),
        pill = player:GetPill(0), slots = slots}
end

local function emit(event, details)
    sequence = sequence + 1
    local game = Game()
    local record = {event = event, label = label, sequence = sequence,
        frame = game:GetFrameCount(), seed = game:GetSeeds():GetStartSeed(),
        difficulty = game.Difficulty, players = game:GetNumPlayers(),
        repentogon = REPENTOGON ~= nil, details = details}
    Isaac.DebugString("OUP_BLANK_CARD " .. json.encode(record))
end

function probe.Snapshot(nextLabel)
    if nextLabel then label = nextLabel end
    local players = {}
    for index = 0, Game():GetNumPlayers() - 1 do
        players[#players + 1] = playerState(Isaac.GetPlayer(index))
    end
    emit("snapshot", players)
    print("OUP Blank Card snapshot: " .. label)
end

local function add(id, fn, filter)
    mod:AddCallback(id, fn, filter)
    callbacks[#callbacks + 1] = {id, fn}
end

add(ModCallbacks.MC_POST_GAME_STARTED, function(_, continued)
    previous = {}
    emit("game_started", {continued = continued})
    probe.Snapshot()
end)
add(ModCallbacks.MC_USE_ITEM, function(_, item, _, player, flags, slot, varData)
    emit("blank_card_use", {item = item, flags = flags, slot = slot,
        varData = varData, player = playerState(player)})
    -- Nil preserves native effect and discharge handling.
end, CollectibleType.COLLECTIBLE_BLANK_CARD)
add(ModCallbacks.MC_USE_CARD, function(_, card, player, flags)
    emit("card_use", {card = card, flags = flags, player = playerState(player)})
end)
add(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local state = playerState(player)
    local encoded = json.encode(state)
    if previous[player.InitSeed] ~= encoded then
        previous[player.InitSeed] = encoded
        emit("player_changed", state)
    end
end)

function probe.Stop()
    for _, callback in ipairs(callbacks) do
        mod:RemoveCallback(callback[1], callback[2])
    end
    callbacks, previous = {}, {}
    OUPBlankCardProbe = nil
    print("OUP Blank Card probe stopped")
end

OUPBlankCardProbe = probe
return probe
