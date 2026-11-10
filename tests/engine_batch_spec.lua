-- Driver accounting/cleanup contracts only; NOT an Isaac engine/drop simulation.
local callbacks, records, entities, frame, seed = {}, {}, {}, 0, 100
local vectorMT = {}
vectorMT.__add = function(a,b) return Vector(a.X+b.X,a.Y+b.Y) end
vectorMT.__sub = function(a,b) return Vector(a.X-b.X,a.Y-b.Y) end
vectorMT.__mul = function(a,b) return Vector(a.X*b,a.Y*b) end
Vector = function(x,y) return setmetatable({X=x,Y=y},vectorMT) end
ModCallbacks = {MC_POST_UPDATE=1,MC_POST_NEW_ROOM=18,MC_ENTITY_TAKE_DMG=11,
    MC_POST_PICKUP_INIT=34,MC_POST_PICKUP_UPDATE=35,
    MC_PRE_NPC_UPDATE=1000} -- Arbitrary test-double ID, not an SDK declaration.
DamageFlag={DAMAGE_CRUSH=16777216}
EntityFlag={FLAG_FREEZE=32,FLAG_NO_KNOCKBACK=1<<26,FLAG_NO_PHYSICS_KNOCKBACK=1<<30}
EntityRef=function(entity) return {Entity=entity} end
local mod = {Config={IsEnabled=function() return true end}}
function mod:AddPriorityCallback(id,priority,fn)
    callbacks[#callbacks+1]={id=id,priority=priority,fn=fn}
end
function mod:RemoveCallback(id,fn)
    for i=#callbacks,1,-1 do
        if callbacks[i].id==id and callbacks[i].fn==fn then table.remove(callbacks,i);return end
    end
    error("removed a foreign callback")
end
openUnnerfPack=mod
package.preload.json=function() return {encode=function(record)
    records[#records+1]=record
    return "record"
end} end
local function dispatch(id,...)
    local list={}
    for _,c in ipairs(callbacks) do if c.id==id then list[#list+1]=c end end
    table.sort(list,function(a,b) return a.priority<b.priority end)
    for _,c in ipairs(list) do
        local result=c.fn(mod,...)
        if id==ModCallbacks.MC_PRE_NPC_UPDATE and result~=nil then
            assert(result==true,"target controller returned an unsupported value")
            return true
        end
        assert(result==nil,"observer changed native dispatch")
    end
end
local player={Position=Vector(320,380),InitSeed=1,Type=1,Size=10,hearts=6,items={}}
function player:GetCollectibleNum(item) return self.items[item] or 0 end
function player:AddCollectible(item) self.items[item]=(self.items[item] or 0)+1 end
function player:RemoveCollectible(item) self.items[item]=math.max(0,(self.items[item] or 0)-1) end
function player:GetHearts() return self.hearts end
function player:AddHearts(amount) self.hearts=self.hearts+amount end
function player:GetMaxHearts() return 6 end
function player:GetSoulHearts() return self.soul or 0 end
function player:GetBlackHearts() return 0 end
function player:GetPlayerType() return 0 end
function player:SetMinDamageCooldown(n) self.fixtureCooldown=n end
local room={}
local roomScenario,currentRoomIndex,hostileClear=false,84,false
local pendingRoomChild,roomKillHook
function room:IsClear() return not roomScenario or currentRoomIndex==84 or hostileClear end
function room:GetAliveEnemiesCount()
    local n=0
    for _,e in ipairs(entities) do
        if e.exists and e.Type==10 and e.room==currentRoomIndex then n=n+1 end
    end
    return n
end
function room:GetCenterPos() return Vector(320,280) end
function room:IsPositionInRoom() return true end
function room:GetGridCollisionAtPos() return 0 end
local level={GetCurrentRoomIndex=function() return currentRoomIndex end}
function level:GetRooms()
    return {Size=2,Get=function(_,i)
        return {Data={Type=1},VisitedCount=i==0 and 1 or 0,Clear=i==0,
            SafeGridIndex=i==0 and 84 or 86}
    end}
end
local game={Difficulty=1}
function game:GetNumPlayers() return 1 end
function game:GetFrameCount() return frame end
function game:GetRoom() return room end
function game:GetLevel() return level end
function game:GetSeeds() return {GetStartSeed=function() return 42 end} end
function game:ChangeRoom(index) currentRoomIndex=index; dispatch(ModCallbacks.MC_POST_NEW_ROOM) end
Game=function() return game end
local function entity(t,v,s,pos,spawner)
    seed=seed+1
    local e={Type=t,Variant=v,SubType=s,Position=pos,Index=seed,
        InitSeed=seed,SpawnerEntity=spawner,SpawnerType=spawner and spawner.Type or 0,
        SpawnerVariant=spawner and spawner.Variant or 0,exists=true,HitPoints=1,
        anim="Flickering",room=currentRoomIndex}
    function e:Exists() return self.exists end
    function e:IsDead() return not self.exists end
    function e:Remove() self.exists=false end
    function e:Kill() self.exists=false; if roomKillHook then roomKillHook(self) end end
    function e:ToNPC() if self.Type==33 or self.Type==15 or self.Type==10 then return self end end
    function e:ToFamiliar() return nil end
    function e:AddEntityFlags() end
    e.Size=13
    function e:GetSprite() return {GetAnimation=function() return self.anim end} end
    function e:GetDropRNG() error("driver consumed native drop RNG") end
    entities[#entities+1]=e
    return e
end
local untouched=entity(5,20,1,Vector(70,70))
local explosions,ambient=0,nil
local contactSetup,targetSpawned=false,nil
local dagger={Type=3,Variant=35,SubType=0,Index=900,InitSeed=900,Size=13,
    Player=player,CollisionDamage=30,OrbitDistance=Vector(30,30)}
function dagger:ToFamiliar() return self end
function dagger:ToNPC() return nil end
function dagger:GetData() return {} end
local relic={Type=3,Variant=23,SubType=0,Index=901,InitSeed=901,Size=13,
    Player=player,CollisionDamage=0,OrbitDistance=Vector(0,0),RoomClearCount=2}
function relic:ToFamiliar() return self end
function relic:ToNPC() return nil end
function relic:GetData() return {} end
Isaac={}
function Isaac.GetPlayer(index) assert(index==0);return player end
function Isaac.GetRoomEntities()
    local list={}
    for _,e in ipairs(entities) do
        if e.exists and (not roomScenario or e.room==currentRoomIndex) then list[#list+1]=e end
    end
    if contactSetup and player:GetCollectibleNum(172)>0 then
        dagger.Position=player.Position+Vector(30,0)
        list[#list+1]=dagger
    end
    if roomScenario and player:GetCollectibleNum(98)>0 then
        relic.Position=player.Position
        list[#list+1]=relic
    end
    return list
end
function Isaac.Spawn(t,v,s,pos,velocity,spawner)
    assert((t==33 and (v==2 or v==3)) or (contactSetup and t==15),"unexpected fixture spawn")
    local e=entity(t,v,s,pos,spawner)
    if t==15 then targetSpawned=e end
    return e
end
function Isaac.DebugString(line) assert(line:find("OUP_ENGINE_BATCH ",1,true)==1) end
function Isaac.Explode(pos,source,amount)
    explosions=explosions+1
    assert(source==player and amount==100)
    local fire
    for _,e in ipairs(entities) do if e.exists and e.Type==33 then assert(not fire);fire=e end end
    dispatch(11,fire,100,4,{Entity=player},0)
    if fire.Variant==2 then
        local heart=entity(5,10,3,Vector(pos.X,pos.Y),fire)
        dispatch(34,heart)
    else
        -- E.g. a nearby destroyed rock can create a heart which later moves
        -- close to the fire. Proximity at the final frame alone is insufficient.
        ambient=entity(5,10,3,Vector(pos.X+40,pos.Y))
        dispatch(34,ambient)
        ambient.Position=Vector(pos.X+15,pos.Y)
    end
    -- An extinguished fireplace may retain positive HP.
    fire.anim="NoFire"
end
local function tick()
    frame=frame+1
    if pendingRoomChild then local spawn=pendingRoomChild;pendingRoomChild=nil;spawn() end
    for _,e in ipairs(entities) do
        if contactSetup and e.exists and e.Type==15 then
            if not dispatch(ModCallbacks.MC_PRE_NPC_UPDATE,e) then
                e.Position=e.Position+Vector(20,0) -- Native AI can outlive freeze.
                e.attackAttempts=(e.attackAttempts or 0)+1
            end
            if roomScenario and not e.loggedContact then
                e.loggedContact=true
                dispatch(11,e,13,0,{Entity=dagger},0)
                e.HitPoints=e.HitPoints-13
            end
        end
        if e.exists and e.Type==5 then dispatch(35,e) end
    end
    dispatch(1)
end
dofile("tools/validation/compatibility-batch.lua")
OUPBatch.Run({trialsPerVariant=1,label="contract"})
for _=1,30 do tick() end
local result=OUPBatch.Status()
assert(result.status=="complete" and result.completed==2)
assert(result.groups["2"].valid==1 and result.groups["2"].histogram["1"]==1)
assert(result.groups["3"].valid==1 and result.groups["3"].histogram["0"]==1)
assert(explosions==2 and #callbacks==0,"trial repeated or leaked callbacks")
assert(player.Position.X==320 and player.Position.Y==380)
assert(untouched:Exists(),"removed an unrelated pickup")
assert(ambient:Exists(),"removed an unattributed ambient pickup")
for _,e in ipairs(entities) do
    if e~=untouched and e~=ambient then assert(not e:Exists()) end
end
player.Position=Vector(100,200)
OUPBatch.Stop()
assert(player.Position.X==100 and player.Position.Y==200,"inactive Stop replayed position rollback")
player.Position=Vector(320,380)
dofile("tools/validation/compatibility-batch.lua")
-- Unsupported protected health must be rejected before any fixture mutation.
player.soul=2
local admitted=pcall(OUPBatch.Run,{mechanics=true,trialsPerVariant=1})
assert(not admitted,"mechanics admitted unsupported soul-heart health")
assert(player:GetSoulHearts()==2 and player:GetHearts()==6 and #callbacks==0)
assert(player:GetCollectibleNum(223)==0 and player.Position.X==320 and player.Position.Y==380)
player.soul=0
-- Stop must restore temporary items/health too, while a mechanics coroutine is
-- suspended between native operations. This is fixture rollback, not heal proof.
OUPBatch.Run({trialsPerVariant=1,mechanics=true,smoke=true,label="mechanics-stop"})
for _=1,98 do tick() end
assert(player:GetCollectibleNum(223)==1 and player:GetHearts()==4)
local stoppedBatch=OUPBatch
OUPBatch.Stop()
assert(player:GetCollectibleNum(223)==0 and player:GetHearts()==6 and #callbacks==0)
assert(OUPBatch==nil and player.Position.X==320 and player.Position.Y==380)
player.Position=Vector(100,200)
player:AddCollectible(223)
stoppedBatch.Stop()
assert(player:GetCollectibleNum(223)==1 and player.Position.X==100 and player.Position.Y==200,
    "repeated Stop replayed completed rollback")
player:RemoveCollectible(223)
player.Position=Vector(320,380)
dofile("tools/validation/compatibility-batch.lua")
local crushCalls=0
function player:TakeDamage()
    crushCalls=crushCalls+1
    self.soul=math.max(0,self:GetSoulHearts()-2)
end
OUPBatch.Run({trialsPerVariant=1,mechanics=true,smoke=true,label="protected-health-arrived"})
for _=1,98 do tick() end
assert(player:GetHearts()==4)
player.soul=2 -- An existing pickup can arrive during the yielded frame.
tick()
assert(crushCalls==0,"crush attempted after protected health arrived")
assert(OUPBatch.Status().status=="error" and player:GetHearts()==6 and player:GetSoulHearts()==2)
assert(player:GetCollectibleNum(223)==0 and #callbacks==0)
OUPBatch.Stop()
player.soul=0
dofile("tools/validation/compatibility-batch.lua")
-- A short native orbit must permit a safe overlapping target beyond the
-- familiar's center, rather than require the center to be 40 units away.
contactSetup=true
OUPBatch.Run({trialsPerVariant=1,mechanics=true,smoke=true,label="short-orbit-placement"})
for _=1,180 do tick(); if targetSpawned then break end end
assert(targetSpawned,"short orbital radius prevented all contact samples")
local gap=targetSpawned.Position.X-player.Position.X
assert(gap>=40 and math.abs(gap-30)<dagger.Size+targetSpawned.Size,
    "contact fixture must clear the player while overlapping the familiar")
local anchor=Vector(targetSpawned.Position.X,targetSpawned.Position.Y)
targetSpawned.Position=targetSpawned.Position+Vector(40,0)
targetSpawned.Velocity=Vector(20,0) -- Simulate damage knockback/status loss.
tick()
assert(targetSpawned.Position.X==anchor.X and targetSpawned.Position.Y==anchor.Y,
    "contact target escaped after knockback/freeze loss")
assert(targetSpawned.Velocity.X==0 and targetSpawned.Velocity.Y==0)
assert(not targetSpawned.attackAttempts,"owned contact target ran native AI")
assert(player.fixtureCooldown==90,"active contact fixture did not protect players")
local foreign=entity(15,0,0,Vector(600,300))
assert(dispatch(ModCallbacks.MC_PRE_NPC_UPDATE,foreign)==nil,
    "fixture controlled an unrelated native NPC")
targetSpawned.Position=nil -- A controller API failure must still suppress AI.
assert(dispatch(ModCallbacks.MC_PRE_NPC_UPDATE,targetSpawned)==true)
tick()
assert(OUPBatch.Status().status=="error" and foreign:Exists(),
    "controller error did not defer owned-only cleanup")
OUPBatch.Stop()
assert(not targetSpawned:Exists() and player:GetCollectibleNum(172)==0 and #callbacks==0)
foreign:Remove()
contactSetup=false
dofile("tools/validation/compatibility-batch.lua")
-- Removing the fireplace while its native damage stack is executing is unsafe.
-- Observer errors must defer mutation/cleanup until the native call unwinds.
local normalExplode,normalDebug=Isaac.Explode,Isaac.DebugString
local removedDuringExplosion=false
Isaac.DebugString=function(line)
    if records[#records].kind=="damage_early" then error("damage logger unavailable") end
    normalDebug(line)
end
Isaac.Explode=function(...)
    local fire
    for _,e in ipairs(entities) do if e.exists and e.Type==33 then fire=e end end
    normalExplode(...)
    removedDuringExplosion=not fire:Exists()
end
OUPBatch.Run({trialsPerVariant=1,label="damage-failure"})
for _=1,10 do tick() end
assert(not removedDuringExplosion,"fixture removed target inside native damage stack")
assert(OUPBatch.Status().status=="error" and #callbacks==0)
assert(player.Position.X==320 and player.Position.Y==380)
Isaac.DebugString=normalDebug
-- An engine/API error must abort, remove only owned fixtures/callbacks and
-- restore positions even if the diagnostic output channel is unavailable.
Isaac.Explode=function() error("native explosion unavailable") end
Isaac.DebugString=function() error("logger unavailable") end
OUPBatch.Run({trialsPerVariant=1,label="failure"})
for _=1,10 do tick() end
assert(OUPBatch.Status().status=="error" and #callbacks==0)
assert(player.Position.X==320 and player.Position.Y==380 and untouched:Exists())
OUPBatch.Stop()
assert(OUPBatch==nil and #callbacks==0)
-- A native death may leave a child alive on a later update. The driver must
-- wait for and clear it; these doubles test room orchestration, not cadence.
Isaac.Explode,Isaac.DebugString=normalExplode,normalDebug
contactSetup,roomScenario=true,true
local parent=entity(10,0,0,Vector(320,280));parent.room=86
roomKillHook=function(npc)
    if npc==parent then
        pendingRoomChild=function() entity(10,1,0,Vector(320,280)) end
    elseif npc.Type==10 then hostileClear=true;relic.RoomClearCount=relic.RoomClearCount+1 end
end
dofile("tools/validation/compatibility-batch.lua")
local firstRoomRecord=#records+1
OUPBatch.Run({trialsPerVariant=1,mechanics=true,label="native-room-child"})
for _=1,1100 do tick() end
local roomResult=OUPBatch.Status()
assert(roomResult.status=="complete" and roomResult.completed==2,
    "child left by native kill blocked the remaining fixture")
assert(roomResult.mechanics.relic.clearCount==1 and hostileClear)
assert(roomResult.mechanics.relic.clears[1].after.roomClearCount==3)
assert(currentRoomIndex==84 and player:GetCollectibleNum(98)==0 and #callbacks==0)
assert(#roomResult.mechanics.orbital[1].events==1,"detailed Status lost event data")
for i=firstRoomRecord,#records do
    local record=records[i]
    if record.kind=="orbital_result" then
        assert(record.events==nil and record.damageEventCount==1,
            "phase log duplicated the unbounded native event array")
    end
end
assert(records[#records].mechanics.orbitalSamples==2 and records[#records].mechanics.orbital==nil,
    "terminal log duplicated detailed mechanics instead of bounded counts")
OUPBatch.Stop()
-- A room which remains unresolved must be reported incomplete, preserve its
-- foreign NPC, and allow unrelated fire sampling and fixture cleanup to finish.
roomKillHook=nil;hostileClear=false;relic.RoomClearCount=2
local immortal=entity(10,2,0,Vector(320,280));immortal.room=86
function immortal:Kill() end
dofile("tools/validation/compatibility-batch.lua")
OUPBatch.Run({trialsPerVariant=1,mechanics=true,label="unresolved-room"})
for _=1,1300 do tick() end
local unresolved=OUPBatch.Status()
assert(unresolved.status=="complete" and unresolved.completed==2)
assert(unresolved.mechanics.relic.status=="native_clears_unresolved" and
    unresolved.mechanics.relic.clearCount==0 and #unresolved.mechanics.relic.skippedRooms==1)
assert(immortal:Exists() and currentRoomIndex==84 and #callbacks==0)
assert(player:GetCollectibleNum(98)==0 and player:GetHearts()==6)
OUPBatch.Stop();immortal:Remove();contactSetup,roomScenario=false,false
print("PASS batch accounting/cleanup contracts; NOT native fire probability evidence")
