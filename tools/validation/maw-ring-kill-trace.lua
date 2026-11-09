-- Optional, manually loaded native-event observer. Never required by main.lua.
-- No RNG calls, damage/stat writes, entity spawns, Morph or save/config writes.
-- A death's latest observed damage source is correlation, not universal proof
-- of attribution. Inspect raw events if another source can reach the target.
-- Observe every NPC type, including possible transitions. Summary deaths are
-- not an eligible-trial denominator until reconciled with requested targets.
assert(OUPMawTrace == nil, "Maw trace already loaded; stop it before reloading")
local json = require("json")
local standalone = openUnnerfPack == nil
local mod = openUnnerfPack or RegisterMod("Open Unnerf Maw validation trace", 1)
assert(type(mod.AddPriorityCallback) == "function", "AddPriorityCallback unavailable")
assert(type(mod.RemoveCallback) == "function", "RemoveCallback unavailable")

local trace = {enabled = true, registered = true, sequence = 0, fixtureVersion = 2}
OUPMawTrace = trace
local callbacks, lastDamage, sessions, seenPickups, seenNPCs = {}, {}, {}, {}, {}
local labels = { ["M2-ring-on"] = true, ["M2-ring-off"] = true,
    ["M2-ring-vanilla"] = true, ["M2-ring-on-v2"] = true,
    ["M2-ring-off-v2"] = true, ["M2-ring-vanilla-v2"] = true }

local function active()
    return trace.enabled and OUPProbe and OUPProbe.active and labels[OUPProbe.label]
end

local function sessionKey()
    return tostring(Game():GetSeeds():GetStartSeed()) .. ":" .. tostring(OUPProbe.label)
end

local function stats()
    local key = sessionKey()
    if not sessions[key] then
        sessions[key] = {damageEvents = 0, deaths = 0,
            deathsWithLastRingSource = 0, blackHeartInits = 0, soulHeartInits = 0,
            deathsByType = {}}
    end
    return sessions[key]
end

local function identity(entity)
    if not entity then return nil end
    return {index = entity.Index, seed = entity.InitSeed, type = entity.Type,
        variant = entity.Variant, subtype = entity.SubType,
        position = entity.Position and {x = entity.Position.X, y = entity.Position.Y} or nil}
end

local function entityKey(entity)
    return sessionKey() .. ":" .. tostring(entity.Index) .. ":" .. tostring(entity.InitSeed)
end

local function emit(kind, record)
    trace.sequence = trace.sequence + 1
    record = record or {}
    record.kind, record.sequence = kind, trace.sequence
    record.label = OUPProbe and OUPProbe.label
    record.frame = Game():GetFrameCount()
    record.seed = Game():GetSeeds():GetStartSeed()
    record.difficulty = Game().Difficulty
    record.fixtureVersion = trace.fixtureVersion
    Isaac.DebugString("OUP_MAWTRACE " .. json.encode(record))
end

local function sourceRecord(source)
    local entity = source and source.Entity
    local record = {entity = identity(entity), ringSource = false}
    if entity and entity.Type == EntityType.ENTITY_LASER then
        local laser = entity:ToLaser()
        if laser then
            record.laser = {subtype = laser.SubType,
                sprite = laser:GetSprite():GetFilename(),
                blackHpDropChance = laser.BlackHpDropChance,
                spawner = identity(laser.SpawnerEntity)}
            record.ringSource = laser.SubType == 3 and
                record.laser.sprite == "gfx/007.001.003_Dark Ring.anm2"
        end
    end
    return record
end

local function register(id, priority, observe)
    local function callback(...)
        if not active() then return end
        local ok, message = pcall(observe, ...)
        if not ok then
            trace.enabled = false
            -- Reporting can fail too (including error-object formatting). Keep
            -- both output paths contained so native callbacks still receive nil.
            pcall(function() emit("diagnostic_error", {message = tostring(message)}) end)
            pcall(print, "M2TRACE ERROR; logging disabled. Report the error before continuing.")
        end
        -- Always nil, including after diagnostic failure. Never cancel damage
        -- or prevent subsequent callbacks from executing.
        return nil
    end
    mod:AddPriorityCallback(id, priority, callback)
    callbacks[#callbacks + 1] = {id = id, fn = callback}
end

register(ModCallbacks.MC_ENTITY_TAKE_DMG, -100, function(_, entity, amount, flags, source, countdown)
    if not entity:ToNPC() then return end
    local sourceInfo = sourceRecord(source)
    local record = {target = identity(entity), hpBefore = entity.HitPoints,
        amount = amount, flags = flags, countdown = countdown, source = sourceInfo,
        frame = Game():GetFrameCount()}
    lastDamage[entityKey(entity)] = record
    stats().damageEvents = stats().damageEvents + 1
    emit("damage_attempt", record)
end)

register(ModCallbacks.MC_POST_NPC_DEATH, 100, function(_, npc)
    local previous = lastDamage[entityKey(npc)]
    local counts = stats()
    counts.deaths = counts.deaths + 1
    local typeKey = tostring(npc.Type)
    counts.deathsByType[typeKey] = (counts.deathsByType[typeKey] or 0) + 1
    local ring = previous and previous.source.ringSource or false
    if ring then counts.deathsWithLastRingSource = counts.deathsWithLastRingSource + 1 end
    emit("native_death", {target = identity(npc), lastObservedDamage = previous,
        framesSinceObservedDamage = previous and Game():GetFrameCount() - previous.frame or nil,
        lastSourceWasRing = ring})
    lastDamage[entityKey(npc)] = nil
end)

register(ModCallbacks.MC_NPC_UPDATE, 100, function(_, npc)
    local key = entityKey(npc) .. ":" .. tostring(npc.Type) .. ":" ..
        tostring(npc.Variant) .. ":" .. tostring(npc.SubType)
    if seenNPCs[key] then return end
    seenNPCs[key] = true
    emit("npc_first_observed", {entity = identity(npc), hp = npc.HitPoints,
        maxHp = npc.MaxHitPoints, size = npc.Size, state = npc.State,
        spawner = identity(npc.SpawnerEntity)})
end)

register(ModCallbacks.MC_POST_PICKUP_INIT, 100, function(_, pickup)
    if pickup.Variant ~= PickupVariant.PICKUP_HEART then return end
    local counts = stats()
    if pickup.SubType == HeartSubType.HEART_BLACK then
        counts.blackHeartInits = counts.blackHeartInits + 1
    elseif pickup.SubType == HeartSubType.HEART_SOUL then
        counts.soulHeartInits = counts.soulHeartInits + 1
    end
    emit("heart_init", {pickup = identity(pickup), entityFrame = pickup.FrameCount,
        spawnerType = pickup.SpawnerType, spawnerVariant = pickup.SpawnerVariant,
        spawner = identity(pickup.SpawnerEntity)})
end)

register(ModCallbacks.MC_POST_PICKUP_UPDATE, 100, function(_, pickup)
    if pickup.Variant ~= PickupVariant.PICKUP_HEART then return end
    local key = entityKey(pickup)
    if seenPickups[key] then return end
    seenPickups[key] = true
    emit("heart_first_observed_update", {pickup = identity(pickup),
        entityFrame = pickup.FrameCount, spawnerType = pickup.SpawnerType,
        spawnerVariant = pickup.SpawnerVariant, spawner = identity(pickup.SpawnerEntity)})
end)

function trace.Summary()
    assert(OUPProbe and labels[OUPProbe.label], "Start an M2 ring probe label first")
    local counts = stats()
    emit("summary", counts)
    print("M2TRACE SUMMARY", counts.deaths, counts.deathsWithLastRingSource,
        counts.blackHeartInits, counts.soulHeartInits)
end

-- Called explicitly by the owner-authored setup after spawning its NPCs. This
-- records requests, not proof that every NPC survived to an engine update.
function trace.RecordTargets(targets)
    assert(active(), "Start an active M2 ring probe label first")
    assert(type(targets) == "table", "Expected a table of fixture NPCs")
    local requested = {}
    for _, entity in ipairs(targets) do
        assert(entity:ToNPC(), "Expected an NPC fixture target")
        local record = identity(entity)
        record.hp, record.size = entity.HitPoints, entity.Size
        requested[#requested + 1] = record
    end
    emit("targets_requested", {targets = requested})
    print("M2 TARGETS READY", #requested)
end

function trace.Stop()
    if not trace.registered then return end
    trace.enabled = false
    for _, callback in ipairs(callbacks) do
        mod:RemoveCallback(callback.id, callback.fn)
    end
    callbacks, lastDamage, seenPickups, seenNPCs = {}, {}, {}, {}
    trace.registered = false
    OUPMawTrace = nil
    -- Finish cleanup even when the diagnostic output channel is unavailable.
    pcall(emit, "callbacks_removed", {standaloneDiagnostic = standalone})
    pcall(print, "M2TRACE STOPPED")
end

emit("registered", {standaloneDiagnostic = standalone, callbackCount = #callbacks})
print("M2TRACE READY", #callbacks, "v" .. trace.fixtureVersion)
