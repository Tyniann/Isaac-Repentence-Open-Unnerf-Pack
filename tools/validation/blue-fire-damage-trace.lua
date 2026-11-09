-- Optional read-only fixture for real explosion damage and fireplace drops.
-- Never spawns entities, damages a target, consumes RNG, or replaces callbacks.
if OUPFireTrace then
    print("BFTRACE already exists; call OUPFireTrace.Stop() before reloading")
    return
end
assert(openUnnerfPack and type(openUnnerfPack.AddPriorityCallback) == "function",
    "BFTRACE requires AddPriorityCallback")
assert(type(openUnnerfPack.RemoveCallback) == "function", "BFTRACE requires RemoveCallback")
local json = require("json")
local mod = openUnnerfPack
local trace = {version = 1, enabled = true, registered = false, sequence = 0}
local callbacks, firstUpdates = {}, {}
OUPFireTrace = trace

local function active()
    return trace.enabled and OUPProbe and OUPProbe.active and
        (OUPProbe.label == "BF-off" or OUPProbe.label == "BF-on")
end

local function record(phase, entity, amount, flags, source)
    if not active() then return end
    local game = Game()
    local spawner = entity.SpawnerEntity
    local damageSource = source and source.Entity
    trace.sequence = trace.sequence + 1
    Isaac.DebugString("OUP_BFTRACE " .. json.encode({
        traceVersion = trace.version, sequence = trace.sequence,
        label = OUPProbe.label, phase = phase, frame = game:GetFrameCount(),
        seed = game:GetSeeds():GetStartSeed(), difficulty = game.Difficulty,
        blueFiresEnabled = mod.Config.IsEnabled("blueFires"),
        index = entity.Index, entitySeed = entity.InitSeed,
        type = entity.Type, variant = entity.Variant, subtype = entity.SubType,
        entityFrame = entity.FrameCount, hitPoints = entity.HitPoints,
        amount = amount, flags = flags,
        explosion = flags ~= nil and (flags & DamageFlag.DAMAGE_EXPLOSION) ~= 0,
        damageSourceType = damageSource and damageSource.Type,
        damageSourceVariant = damageSource and damageSource.Variant,
        damageSourceSeed = damageSource and damageSource.InitSeed,
        spawnerType = entity.SpawnerType, spawnerEntityPresent = spawner ~= nil,
        spawnerEntityType = spawner and spawner.Type,
        spawnerVariant = spawner and spawner.Variant,
        spawnerSeed = spawner and spawner.InitSeed,
    }))
    -- Always nil: neither damage nor pickup handling is overridden.
end

function trace.Stop()
    trace.enabled = false
    for _, callback in ipairs(callbacks) do
        mod:RemoveCallback(callback.id, callback.fn)
    end
    callbacks = {}
    trace.registered = false
    OUPFireTrace = nil
    Isaac.DebugString("OUP_BFTRACE_REMOVED version=1")
    print("BFTRACE stopped; only fixture callbacks removed")
end

local function register(id, priority, fn)
    mod:AddPriorityCallback(id, priority, fn)
    callbacks[#callbacks + 1] = {id = id, fn = fn}
end

local function damage(phase, entity, amount, flags, source)
    if entity.Type == EntityType.ENTITY_FIREPLACE and
        (entity.Variant == 2 or entity.Variant == 3) then
        record(phase, entity, amount, flags, source)
    end
end
register(ModCallbacks.MC_ENTITY_TAKE_DMG, -100, function(_, entity, amount, flags, source)
    damage("damage_early", entity, amount, flags, source)
end)
register(ModCallbacks.MC_ENTITY_TAKE_DMG, 100, function(_, entity, amount, flags, source)
    damage("damage_late", entity, amount, flags, source)
end)
register(ModCallbacks.MC_POST_PICKUP_INIT, 100, function(_, pickup)
    if pickup.Variant == PickupVariant.PICKUP_HEART then record("pickup_init", pickup) end
end)
register(ModCallbacks.MC_POST_PICKUP_UPDATE, 100, function(_, pickup)
    if not active() or pickup.Variant ~= PickupVariant.PICKUP_HEART then return end
    local key = OUPProbe.label .. ":" .. Game():GetSeeds():GetStartSeed() ..
        ":" .. pickup.Index .. ":" .. pickup.InitSeed
    if firstUpdates[key] then return end
    firstUpdates[key] = true
    record("pickup_first_update", pickup)
end)
trace.registered = true
Isaac.DebugString("OUP_BFTRACE_INSTALLED version=1 damagePriorities=-100,100 pickupPriority=100")
print("BFTRACE READY")
