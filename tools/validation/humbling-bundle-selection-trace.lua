-- Optional read-only fixture for native chest-content selection observations.
-- Load explicitly; never required by production or the immutable observer.
if OUPHBTrace then
    print("HBTRACE already exists; call OUPHBTrace.Stop() before reloading")
    return
end
assert(openUnnerfPack and type(openUnnerfPack.AddPriorityCallback) == "function",
    "HBTRACE requires AddPriorityCallback")
assert(type(openUnnerfPack.RemoveCallback) == "function",
    "HBTRACE requires RemoveCallback for exact fixture cleanup")
local json = require("json")
local mod = openUnnerfPack
local trace = {version = 1, enabled = true, registered = false, sequence = 0}
local callbacks, firstUpdates = {}, {}
OUPHBTrace = trace

local function active()
    return trace.enabled and OUPProbe and OUPProbe.active and
        (OUPProbe.label == "HB-off" or OUPProbe.label == "HB-on")
end

local function record(phase, pickup, selectedVariant, selectedSubtype)
    if not active() then return end
    local game = Game()
    local copies = {}
    for index = 0, game:GetNumPlayers() - 1 do
        copies[#copies + 1] = Isaac.GetPlayer(index):GetCollectibleNum(203)
    end
    local spawner = pickup and pickup.SpawnerEntity
    trace.sequence = trace.sequence + 1
    Isaac.DebugString("OUP_HBTRACE " .. json.encode({
        traceVersion = trace.version, sequence = trace.sequence,
        label = OUPProbe.label, phase = phase, frame = game:GetFrameCount(),
        seed = game:GetSeeds():GetStartSeed(), bundleCopies = copies,
        humblingBundleEnabled = mod.Config.IsEnabled("humblingBundle"),
        selectedVariant = selectedVariant, selectedSubtype = selectedSubtype,
        pickupPresent = pickup ~= nil,
        pickupIndex = pickup and pickup.Index, pickupSeed = pickup and pickup.InitSeed,
        type = pickup and pickup.Type, variant = pickup and pickup.Variant,
        subtype = pickup and pickup.SubType, entityFrame = pickup and pickup.FrameCount,
        spawnerType = pickup and pickup.SpawnerType,
        spawnerEntityPresent = spawner ~= nil,
        spawnerVariant = spawner and spawner.Variant,
        spawnerSeed = spawner and spawner.InitSeed,
    }))
    -- Always nil: selection observers must never supply a replacement table.
end

function trace.Stop()
    trace.enabled = false
    for _, callback in ipairs(callbacks) do
        mod:RemoveCallback(callback.id, callback.fn)
    end
    callbacks = {}
    trace.registered = false
    OUPHBTrace = nil
    Isaac.DebugString("OUP_HBTRACE_REMOVED version=1")
    print("HBTRACE stopped; only fixture callbacks removed")
end

local function register(id, priority, fn)
    mod:AddPriorityCallback(id, priority, fn)
    callbacks[#callbacks + 1] = {id = id, fn = fn}
end

-- Selection may short-circuit after a production return. A missing late
-- observer is not itself proof of replacement; inspect the actual pickup too.
-- The selection wrapper may be mostly empty. Never join events solely by its
-- index/seed, assume arguments propagate, or count selection calls as payouts.
register(ModCallbacks.MC_POST_PICKUP_SELECTION, -100, function(_, pickup, variant, subtype)
    record("selection_early", pickup, variant, subtype)
end)
register(ModCallbacks.MC_POST_PICKUP_SELECTION, 100, function(_, pickup, variant, subtype)
    record("selection_late", pickup, variant, subtype)
end)
register(ModCallbacks.MC_POST_PICKUP_INIT, 100, function(_, pickup)
    record("init", pickup)
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
Isaac.DebugString("OUP_HBTRACE_INSTALLED version=1 selectionPriorities=-100,100 initUpdatePriority=100")
print("HBTRACE READY")
