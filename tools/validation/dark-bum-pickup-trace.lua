-- Optional read-only engine fixture, loaded explicitly for the Dark Bum case.
-- Never required by production or the immutable compatibility observer.
-- Adds its own observers; never replaces an existing callback or its priority.
if OUPDBTrace then
    print("DBTRACE already exists; call OUPDBTrace.Stop() before reloading")
    return
end
assert(openUnnerfPack and type(openUnnerfPack.AddPriorityCallback) == "function",
    "DBTRACE requires the pack's AddPriorityCallback API")
assert(type(openUnnerfPack.RemoveCallback) == "function",
    "DBTRACE requires RemoveCallback for exact fixture cleanup")
local json = require("json")
local mod = openUnnerfPack
local trace = {version = 1, enabled = true, registered = false, sequence = 0}
local callbacks, firstUpdates = {}, {}
OUPDBTrace = trace

local function active()
    return trace.enabled and OUPProbe and OUPProbe.active and
        (OUPProbe.label == "DB-off" or OUPProbe.label == "DB-on")
end

local function describe(phase, pickup)
    local spawner = pickup.SpawnerEntity
    local familiar = spawner and spawner:ToFamiliar()
    local owner = familiar and familiar.Player
    trace.sequence = trace.sequence + 1
    return {
        traceVersion = trace.version, sequence = trace.sequence,
        label = OUPProbe.label, phase = phase,
        frame = Game():GetFrameCount(), seed = Game():GetSeeds():GetStartSeed(),
        pickupIndex = pickup.Index, pickupSeed = pickup.InitSeed,
        type = pickup.Type, variant = pickup.Variant, subtype = pickup.SubType,
        entityFrame = pickup.FrameCount, spawnerType = pickup.SpawnerType,
        spawnerEntityPresent = spawner ~= nil,
        spawnerVariant = spawner and spawner.Variant,
        spawnerSeed = spawner and spawner.InitSeed,
        spawnerConvertsToFamiliar = familiar ~= nil,
        ownerPresent = owner ~= nil, ownerType = owner and owner:GetPlayerType(),
        darkBumEnabled = openUnnerfPack.Config.IsEnabled("darkBum"),
    }
end

local function record(phase, pickup)
    if not active() then return end
    Isaac.DebugString("OUP_DBTRACE " .. json.encode(describe(phase, pickup)))
    -- Always nil: no return-value override of production or native callbacks.
end

function trace.Stop()
    trace.enabled = false
    for _, callback in ipairs(callbacks) do
        mod:RemoveCallback(callback.id, callback.fn)
    end
    callbacks = {}
    trace.registered = false
    OUPDBTrace = nil
    Isaac.DebugString("OUP_DBTRACE_REMOVED version=1")
    print("DBTRACE stopped; only fixture callbacks removed")
end

local function register(id, priority, fn)
    mod:AddPriorityCallback(id, priority, fn)
    callbacks[#callbacks + 1] = {id = id, fn = fn}
end

register(ModCallbacks.MC_POST_PICKUP_INIT, -100, function(_, pickup)
    record("init_before", pickup)
end)
register(ModCallbacks.MC_POST_PICKUP_INIT, 100, function(_, pickup)
    record("init_after", pickup)
end)
register(ModCallbacks.MC_POST_PICKUP_UPDATE, 100, function(_, pickup)
    if not active() then return end
    local key = OUPProbe.label .. ":" .. Game():GetSeeds():GetStartSeed() ..
        ":" .. pickup.Index .. ":" .. pickup.InitSeed
    if firstUpdates[key] then return end
    firstUpdates[key] = true
    record("first_update", pickup)
end)
trace.registered = true
Isaac.DebugString("OUP_DBTRACE_INSTALLED version=1 initPriorities=-100,100 firstUpdatePriority=100")
print("DBTRACE READY")
