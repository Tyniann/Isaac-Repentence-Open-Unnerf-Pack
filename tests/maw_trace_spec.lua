-- Observer contract checks only. No Isaac engine, kill or reward simulation.
local records, callbacks, removed = {}, {}, {}
local frame = 10
local function checkJSON(value, seen)
    if type(value) ~= "table" then
        assert(type(value) ~= "function" and type(value) ~= "userdata")
        return
    end
    seen = seen or {}
    assert(not seen[value], "cyclic diagnostic record")
    seen[value] = true
    for _, entry in pairs(value) do checkJSON(entry, seen) end
    seen[value] = nil
end
package.preload.json = function() return {encode = function(record)
    checkJSON(record)
    records[#records + 1] = record
    return "test-record"
end} end
ModCallbacks = {MC_NPC_UPDATE=0, MC_ENTITY_TAKE_DMG=11, MC_POST_NPC_DEATH=29,
    MC_POST_PICKUP_INIT=34, MC_POST_PICKUP_UPDATE=35}
EntityType = {ENTITY_LASER=7, ENTITY_GAPER=10}
PickupVariant = {PICKUP_HEART=10}
HeartSubType = {HEART_SOUL=3, HEART_BLACK=6}
local pack = {}
function pack:AddPriorityCallback(id, priority, callback)
    assert(priority == -100 or priority == 100)
    callbacks[id] = callback
end
function pack:RemoveCallback(id, callback)
    assert(callbacks[id] == callback, "removed a foreign callback")
    removed[#removed + 1] = {id=id, fn=callback}
    callbacks[id] = nil
end
openUnnerfPack = pack
OUPProbe = {active=true, label="M2-ring-on-v2"}
Game = function() return {Difficulty=0, GetFrameCount=function() return frame end,
    GetSeeds=function() return {GetStartSeed=function() return 123 end} end} end
Isaac = {DebugString=function(line) assert(line:find("OUP_MAWTRACE ",1,true)==1) end,
    Spawn=function() error("observer spawned an entity") end,
    Explode=function() error("observer created damage") end}
local function emit(id, ...)
    return callbacks[id](pack, ...)
end
dofile("tools/validation/maw-ring-kill-trace.lua")
local trace = OUPMawTrace
assert(trace.registered and #removed == 0)
local laser = {Type=7,Variant=1,SubType=3,Index=8,InitSeed=99,BlackHpDropChance=0.05,
    GetSprite=function() return {GetFilename=function() return "gfx/007.001.003_Dark Ring.anm2" end} end}
function laser:ToLaser() return self end
local npc = {Type=10,Variant=0,SubType=0,Index=12,InitSeed=31,HitPoints=4}
function npc:ToNPC() return self end
assert(emit(11,npc,3.5,0,{Entity=laser},0) == nil)
frame=11
assert(emit(29,npc) == nil)
local death = records[#records]
assert(death.kind == "native_death" and death.lastSourceWasRing)
assert(death.framesSinceObservedDamage == 1)
assert(death.lastObservedDamage.source.laser.blackHpDropChance == 0.05)
-- A later observed tear source must not be classified as a ring source.
local tear = {Type=2,Variant=0,SubType=0,Index=9,InitSeed=98}
assert(emit(11,npc,3.5,0,{Entity=tear},0) == nil)
assert(emit(29,npc) == nil and not records[#records].lastSourceWasRing)
-- Native evidence uses a player EntityRef and flags 8, not a laser EntityRef.
-- Observe other NPC types without promoting a player source to direct attribution.
local player = {Type=1,Variant=0,SubType=0,Index=0,InitSeed=77}
function player:ToNPC() return nil end
local clotty = {Type=15,Variant=0,SubType=0,Index=13,InitSeed=32,HitPoints=1,
    Position={X=120,Y=80},Size=10}
function clotty:ToNPC() return self end
assert(emit(11,clotty,4.5,8,{Entity=player},30) == nil)
assert(records[#records].kind == "damage_attempt" and
    records[#records].target.type == 15, "non-Gaper NPC damage was omitted")
assert(emit(29,clotty) == nil)
assert(records[#records].target.type == 15 and not records[#records].lastSourceWasRing)
assert(records[#records].lastObservedDamage.flags == 8 and
    records[#records].lastObservedDamage.source.entity.type == 1)
local previousCount = #records
assert(emit(11,player,1,0,{Entity=laser},0) == nil and #records == previousCount)
-- A type change must not hide the death; this simulates the observer contract,
-- not a claim that the engine performed this transition in the owner trial.
assert(emit(11,npc,4.5,8,{Entity=player},30) == nil)
npc.Type=11
assert(emit(29,npc) == nil)
assert(records[#records].target.type == 11 and
    records[#records].lastObservedDamage.target.type == 10)
npc.Type=10
assert(emit(0,clotty) == nil and records[#records].kind == "npc_first_observed")
previousCount = #records
assert(emit(0,clotty) == nil and #records == previousCount)
clotty.Type=11
assert(emit(0,clotty) == nil and records[#records].entity.type == 11)
clotty.Type=15
trace.RecordTargets({clotty})
assert(records[#records].kind == "targets_requested" and
    #records[#records].targets == 1 and records[#records].targets[1].type == 15)
assert(records[#records].targets[1].position.x == 120 and clotty.HitPoints == 1)
local heart = {Type=5,Variant=10,SubType=6,Index=15,InitSeed=42,FrameCount=0,
    SpawnerType=10,SpawnerVariant=0,SpawnerEntity=npc}
assert(emit(34,heart) == nil)
assert(emit(35,heart) == nil)
local afterFirst = #records
assert(emit(35,heart) == nil and #records == afterFirst)
assert(npc.HitPoints == 4 and heart.SubType == 6 and laser.BlackHpDropChance == 0.05)
OUPProbe.label="DB-on"
assert(emit(11,npc,3.5,0,{Entity=laser},0) == nil and #records == afterFirst)
OUPProbe.label="M2-ring-on-v2"
trace.Summary()
assert(records[#records].deaths == 4 and records[#records].deathsWithLastRingSource == 1)
assert(records[#records].blackHeartInits == 1)
assert(records[#records].fixtureVersion == 2 and
    records[#records].deathsByType["10"] == 2 and
    records[#records].deathsByType["15"] == 1 and
    records[#records].deathsByType["11"] == 1)
trace.Stop()
assert(#removed == 5 and OUPMawTrace == nil)
trace.Stop()
assert(#removed == 5)
-- Diagnostic read failure must return nil and stop logging, not cancel damage.
dofile("tools/validation/maw-ring-kill-trace.lua")
local badSource = {Type=7,ToLaser=function() error("fixture source unavailable") end}
assert(emit(11,npc,1,0,{Entity=badSource},0) == nil)
assert(not OUPMawTrace.enabled and records[#records].kind == "diagnostic_error")
OUPMawTrace.Stop()
assert(#removed == 10)
-- A logger failure while reporting another failure must not escape a callback.
dofile("tools/validation/maw-ring-kill-trace.lua")
local originalDebug = Isaac.DebugString
Isaac.DebugString = function() error("fixture logger unavailable") end
local ok, result = pcall(emit,11,npc,1,0,{Entity=laser},0)
assert(ok and result == nil, "diagnostic-report failure escaped the callback")
assert(not OUPMawTrace.enabled)
local stopped = pcall(OUPMawTrace.Stop)
Isaac.DebugString = originalDebug
assert(stopped and OUPMawTrace == nil and #removed == 15,
    "logger failure interrupted exact callback/global cleanup")
print("PASS Maw trace callback/cleanup contracts; NOT engine attribution or drop validation")
