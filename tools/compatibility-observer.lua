-- Optional console-loaded diagnostic; never required by the production loader.
-- Records observations only. Does not grant items, change stats, spawn entities,
-- cancel damage, alter configuration, or write mod save data.
-- Deploy only with the session owner's agreement; load with luarun <path>.
if OUPProbe then
    print("OUPProbe already loaded; use OUPProbe.Start/Stop/Snapshot")
    return
end

local json = require("json")
local mod = RegisterMod("Open Unnerf Pack compatibility observer", 1)
local probe = { active = false, sequence = 0 }
OUPProbe = probe
local seen = setmetatable({}, { __mode = "k" })
local seenLasers = setmetatable({}, { __mode = "k" })
local keys = {"mawOfTheVoid", "orbitals", "stompImmunity", "humblingBundle",
    "darkBum", "relic", "blueFires"}

local function emit(kind, fields)
    probe.sequence = probe.sequence + 1
    fields = fields or {}
    fields.kind = kind
    fields.sequence = probe.sequence
    fields.label = probe.label
    fields.frame = Game():GetFrameCount()
    local line = "OUP_PROBE " .. json.encode(fields)
    Isaac.DebugString(line)
    print(line)
end

local function identity(entity)
    if not entity then return nil end
    return {type = entity.Type, variant = entity.Variant, subtype = entity.SubType,
        seed = entity.InitSeed}
end

function probe.Snapshot(label)
    local game = Game()
    local settings, players, familiars = {}, {}, {}
    if openUnnerfPack and openUnnerfPack.Config then
        for _, key in ipairs(keys) do
            settings[key] = openUnnerfPack.Config.IsEnabled(key)
        end
    end
    local saved, savedReadError
    if openUnnerfPack then
        local ok, result = pcall(function()
            if not openUnnerfPack:HasData() then return {present = false} end
            local decoded = json.decode(openUnnerfPack:LoadData())
            if type(decoded) ~= "table" then return {present = true, validTable = false} end
            return {present = true, version = decoded.version,
                settings = decoded.settings, run = decoded.run}
        end)
        if ok then saved = result else savedReadError = tostring(result) end
    end
    local mcm = {present = ModConfigMenu ~= nil}
    if type(ModConfigMenu) == "table" then
        -- Preserve literal fields only; the deployment manifest identifies the
        -- source revision. Missing fields must never be interpreted as a version.
        for _, key in ipairs({"Version", "VERSION", "version"}) do
            local value = ModConfigMenu[key]
            if type(value) == "number" or type(value) == "string" then mcm[key] = value end
        end
    end
    for index = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(index)
        players[#players + 1] = {index = index, type = player:GetPlayerType(),
            damage = player.Damage, mawCopies = player:GetCollectibleNum(399),
            cachedMawCopies = player:GetData().openUnnerfMawCount,
            redHalfHearts = player:GetHearts(), soulHalfHearts = player:GetSoulHearts(),
            blackHeartMask = player:GetBlackHearts()}
    end
    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        local familiar = entity:ToFamiliar()
        if familiar then
            local item = identity(familiar)
            item.damage = familiar.CollisionDamage
            item.size = familiar.Size
            item.roomClearCount = familiar.RoomClearCount
            item.state = familiar.State
            item.orbitX = familiar.OrbitDistance.X
            item.orbitY = familiar.OrbitDistance.Y
            item.processed = familiar:GetData().processed
            item.ownerSeed = familiar.Player and familiar.Player.InitSeed or nil
            familiars[#familiars + 1] = item
        end
    end
    emit("snapshot", {checkpoint = label, deployment = probe.deployment,
        seed = game:GetSeeds():GetStartSeed(), difficulty = game.Difficulty,
        settings = settings, saved = saved, savedReadError = savedReadError,
        mcm = mcm, operatorRunKind = probe.operatorRunKind,
        runStartObserved = probe.continuedObserved ~= nil,
        continuedObserved = probe.continuedObserved,
        players = players, familiars = familiars})
end

function probe.Start(label, deployment, runKind)
    assert(type(label) == "string" and type(deployment) == "string",
        "Start requires a test label and recorded deployment SHA")
    probe.label = label
    -- This label is supplied by the operator, not independent build verification.
    probe.deployment = deployment
    probe.operatorRunKind = runKind
    probe.active = true
    seen = setmetatable({}, { __mode = "k" })
    seenLasers = setmetatable({}, { __mode = "k" })
    probe.Snapshot("start")
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, continued)
    probe.continuedObserved = continued
    if probe.active then probe.Snapshot("post_game_started") end
end)

function probe.Stop()
    probe.Snapshot("stop")
    probe.active = false
end

-- Observe pickups on their first update, not init. Provenance may still be absent.
-- Each observed pickup is recorded once per Start, including existing room items.
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    if not probe.active or seen[pickup] then return end
    seen[pickup] = true
    emit("pickup_first_observed", {entity = identity(pickup),
        spawner = identity(pickup.SpawnerEntity), spawnerType = pickup.SpawnerType,
        entityFrame = pickup.FrameCount})
end)

-- Pre-damage observations do not prove damage was applied or cancelled by others.
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, countdown)
    if not probe.active then return end
    if entity.Type == EntityType.ENTITY_PLAYER or entity.Type == EntityType.ENTITY_FIREPLACE then
        emit("damage_callback", {entity = identity(entity), amount = amount,
            flags = flags, source = identity(source and source.Entity), countdown = countdown,
            hitPointsBefore = entity.HitPoints})
    end
    -- Always nil: do not suppress subsequent callbacks or change native damage.
end)

mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, function(_, laser)
    if not probe.active or seenLasers[laser] then return end
    seenLasers[laser] = true
    emit("laser_first_observed", {entity = identity(laser),
        sprite = laser:GetSprite():GetFilename(), blackHpDropChance = laser.BlackHpDropChance,
        spawner = identity(laser.SpawnerEntity)})
end)

print("OUPProbe loaded but inactive; diagnostic callbacks registered. Start requires label and SHA.")
