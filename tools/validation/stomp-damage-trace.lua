-- Optional read-only trace for native Mom-foot damage and later player health.
-- Never grants an item, changes health, forwards damage, or overrides a callback.
if OUPStompTrace then
    print("STTRACE already exists; call OUPStompTrace.Stop() before reloading")
    return
end
assert(openUnnerfPack and type(openUnnerfPack.AddPriorityCallback) == "function",
    "STTRACE requires AddPriorityCallback")
assert(type(openUnnerfPack.RemoveCallback) == "function", "STTRACE requires RemoveCallback")
local json = require("json")
local mod = openUnnerfPack
local trace = {version = 1, enabled = true, registered = false, sequence = 0}
local callbacks, pending = {}, {}
OUPStompTrace = trace

local function active()
    return trace.enabled and OUPProbe and OUPProbe.active and
        (OUPProbe.label == "ST-off" or OUPProbe.label == "ST-on")
end

local function health(player)
    return {red = player:GetHearts(), soul = player:GetSoulHearts(),
        blackMask = player:GetBlackHearts()}
end

local function emit(phase, data)
    trace.sequence = trace.sequence + 1
    data.traceVersion = trace.version
    data.sequence = trace.sequence
    data.phase = phase
    data.label = OUPProbe.label
    data.frame = Game():GetFrameCount()
    data.seed = Game():GetSeeds():GetStartSeed()
    Isaac.DebugString("OUP_STTRACE " .. json.encode(data))
    return trace.sequence
end

local function observeDamage(_, entity, amount, flags, source, countdown)
    if not active() or entity.Type ~= EntityType.ENTITY_PLAYER then return end
    local player = entity:ToPlayer()
    if not player then return end
    local game = Game()
    local runSeed, frame = game:GetSeeds():GetStartSeed(), game:GetFrameCount()
    local damageSource = source and source.Entity
    local sprite = damageSource and damageSource:GetSprite()
    local npc = damageSource and damageSource:ToNPC()
    local before = health(player)
    local sequence = emit("damage_pre", {
        playerSeed = player.InitSeed, playerType = player:GetPlayerType(),
        amount = amount, flags = flags, countdown = countdown,
        crush = (flags & DamageFlag.DAMAGE_CRUSH) ~= 0,
        stompEnabled = mod.Config.IsEnabled("stompImmunity"),
        hostHatCopies = player:GetCollectibleNum(375),
        pyromaniacCopies = player:GetCollectibleNum(223), healthBefore = before,
        sourcePresent = damageSource ~= nil,
        sourceType = damageSource and damageSource.Type,
        sourceVariant = damageSource and damageSource.Variant,
        sourceSeed = damageSource and damageSource.InitSeed,
        sourceAnimation = sprite and sprite:GetAnimation(),
        sourceAnimationFrame = sprite and sprite:GetFrame(), sourceState = npc and npc.State,
        stage = game:GetLevel():GetStage(), roomIndex = game:GetLevel():GetCurrentRoomIndex(),
    })
    local key = tostring(runSeed) .. ":" .. player.InitSeed .. ":" .. frame
    local group = pending[key]
    if not group then
        group = {runSeed = runSeed, label = OUPProbe.label, playerSeed = player.InitSeed,
            damageFrame = frame, healthBeforeFirst = before, damageSequences = {}}
        pending[key] = group
    end
    group.damageSequences[#group.damageSequences + 1] = sequence
    -- Always nil, including when production will later cancel this damage.
end

local function observePlayer(_, player)
    if not active() then return end
    local game = Game()
    local runSeed, frame = game:GetSeeds():GetStartSeed(), game:GetFrameCount()
    for key, group in pairs(pending) do
        if group.runSeed ~= runSeed or group.label ~= OUPProbe.label then
            emit("pending_discarded", {damageSeed = group.runSeed, damageLabel = group.label,
                damageFrame = group.damageFrame, damageSequences = group.damageSequences,
                reason = "run_or_label_changed"})
            pending[key] = nil
        elseif group.playerSeed == player.InitSeed and frame > group.damageFrame then
            local after = health(player)
            emit("health_after_frame", {playerSeed = player.InitSeed,
                damageFrame = group.damageFrame, damageSequences = group.damageSequences,
                healthBeforeFirst = group.healthBeforeFirst, healthAfter = after,
                redDelta = after.red - group.healthBeforeFirst.red,
                soulDelta = after.soul - group.healthBeforeFirst.soul})
            pending[key] = nil
        end
    end
    -- Outcomes group every source for this player/frame. Mixed-source frames
    -- cannot isolate a stomp; a cancelled hit is not inferred from nil alone.
end

function trace.Stop()
    trace.enabled = false
    for _, callback in ipairs(callbacks) do mod:RemoveCallback(callback.id, callback.fn) end
    callbacks, pending = {}, {}
    trace.registered = false
    OUPStompTrace = nil
    Isaac.DebugString("OUP_STTRACE_REMOVED version=1")
    print("STTRACE stopped; only fixture callbacks removed")
end

local function register(id, priority, fn)
    mod:AddPriorityCallback(id, priority, fn)
    callbacks[#callbacks + 1] = {id = id, fn = fn}
end
register(ModCallbacks.MC_ENTITY_TAKE_DMG, -100, observeDamage)
register(ModCallbacks.MC_POST_PLAYER_UPDATE, 100, observePlayer)
trace.registered = true
Isaac.DebugString("OUP_STTRACE_INSTALLED version=1 damagePriority=-100 playerUpdatePriority=100")
print("STTRACE READY")
