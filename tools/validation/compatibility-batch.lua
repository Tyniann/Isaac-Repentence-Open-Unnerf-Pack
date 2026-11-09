-- Optional ACTIVE fixture. Explicit Run moves players temporarily and spawns
-- one fireplace at a time. Optional mechanics mode also uses temporary items/
-- health and clears real hostile map rooms. No settings/save/config/RNG writes.
-- Native-event results are evidence only after the recorded setup is checked.
-- Use a disposable room: native explosions can alter nearby room terrain.
assert(OUPBatch == nil, "Stop the existing OUPBatch before loading another version")
local json = require("json")
local mod = openUnnerfPack or RegisterMod("Open Unnerf native batch", 1)
local batch, state, callbacks = {version=4}, nil, {}
local playerContext
OUPBatch = batch
local function pos(v) return {x=v.X,y=v.Y} end
local function id(e)
    if not e then return nil end
    return {type=e.Type,variant=e.Variant,subtype=e.SubType,index=e.Index,
        seed=e.InitSeed,position=pos(e.Position)}
end
local function key(e) return tostring(e.Index)..":"..tostring(e.InitSeed) end
local function distance(a,b)
    local x,y=a.X-b.X,a.Y-b.Y
    return math.sqrt(x*x+y*y)
end
local function emit(kind,data)
    data=data or {}
    data.kind, data.version=kind,batch.version
    data.label=state and state.label
    data.frame=Game():GetFrameCount()
    data.seed=Game():GetSeeds():GetStartSeed()
    data.difficulty=Game().Difficulty
    Isaac.DebugString("OUP_ENGINE_BATCH "..json.encode(data))
end
local function owned(e)
    return {entity=e,seed=e.InitSeed}
end
local function removeOwned(entry)
    local e=entry.entity
    if e:Exists() and e.InitSeed==entry.seed then e:Remove() end
end
local function captureTrialDrops()
    local t=state and state.trial
    if not t or Game():GetLevel():GetCurrentRoomIndex()~=state.roomIndex then return end
    local already={}
    for _,entry in ipairs(state.owned) do
        if entry.entity:Exists() then already[key(entry.entity)]=true end
    end
    for _,e in ipairs(Isaac.GetRoomEntities()) do
        if e.Type==5 and e.Variant==10 and not t.existing[key(e)] and not already[key(e)] then
            local spawner=e.SpawnerEntity
            local fromFire=spawner and spawner.Type==33 and
                spawner.Index==t.identity.index and spawner.InitSeed==t.identity.seed
            if t.candidateSeeds[tostring(e.InitSeed)] or fromFire or
                distance(e.Position,state.targetPosition)<=8 then
                state.owned[#state.owned+1]=owned(e)
            end
        end
    end
end
local function cleanup()
    local errors={}
    for _,c in ipairs(callbacks) do
        local ok,message=pcall(mod.RemoveCallback,mod,c.id,c.fn)
        if not ok then errors[#errors+1]=tostring(message) end
    end
    callbacks={}
    if state then
        local captured,message=pcall(captureTrialDrops)
        if not captured then errors[#errors+1]=tostring(message) end
        for _,entry in ipairs(state.owned) do
            local ok,message=pcall(removeOwned,entry)
            if not ok then errors[#errors+1]=tostring(message) end
        end
        state.owned={}
        for _,entry in ipairs(state.managedItems or {}) do
            local ok,message=pcall(function()
                while entry.player:GetCollectibleNum(entry.item)>entry.count do
                    local before=entry.player:GetCollectibleNum(entry.item)
                    entry.player:RemoveCollectible(entry.item)
                    assert(entry.player:GetCollectibleNum(entry.item)<before,"Item removal made no progress")
                end
            end)
            if not ok then errors[#errors+1]=tostring(message) end
        end
        if state.healthMutation then
            local ok,message=pcall(function()
                local h=state.healthMutation
                h.player:AddHearts(h.original-h.player:GetHearts())
            end)
            if not ok then errors[#errors+1]=tostring(message) end
            state.healthMutation=nil
        end
        if state.mechanics and Game():GetLevel():GetCurrentRoomIndex()~=state.roomIndex then
            local ok,message=pcall(function()
                for _,entry in ipairs(state.players) do entry.player:SetMinDamageCooldown(90) end
                Game():ChangeRoom(state.roomIndex)
            end)
            if not ok then errors[#errors+1]=tostring(message) end
        end
        if Game():GetLevel():GetCurrentRoomIndex()==state.roomIndex then
            for _,entry in ipairs(state.players) do
                local ok,message=pcall(function()
                    entry.player.Position=Vector(entry.position.X,entry.position.Y)
                end)
                if not ok then errors[#errors+1]=tostring(message) end
            end
        end
    end
    return errors
end
local function report()
    if not state then return {status="idle",version=batch.version} end
    return {status=state.status,label=state.label,completed=state.completed,
        total=state.total,groups=state.groups,error=state.error,
        cleanupErrors=state.cleanupErrors,afterCleanup=state.afterCleanup,
        context=state.context,mechanics=state.mechanics}
end
local function finish(status,message)
    if not state or not state.active then return end
    state.active=false
    state.status,state.error=status,message
    state.cleanupErrors=cleanup()
    local observed,after=pcall(function()
        local out={room=Game():GetLevel():GetCurrentRoomIndex(),players={},managedItems={}}
        for _,entry in ipairs(state.players) do
            out.players[#out.players+1]=playerContext(entry.player,entry.index)
        end
        for _,entry in ipairs(state.managedItems) do
            out.managedItems[#out.managedItems+1]={item=entry.item,
                expected=entry.count,actual=entry.player:GetCollectibleNum(entry.item)}
        end
        return out
    end)
    if observed then state.afterCleanup=after else
        state.cleanupErrors[#state.cleanupErrors+1]=tostring(after)
    end
    if #state.cleanupErrors>0 then state.status="error" end
    local terminal=report()
    if state.mechanics then
        local m=state.mechanics
        terminal.mechanics={orbitalSamples=#m.orbital,meatStateObserved=m.meat~=nil,
            crushContract=m.crushContract,relicStatus=m.relic.status,
            relicClearCount=#m.relic.clears,relicPayoutCount=#m.relic.payouts,
            relicUnresolvedRooms=#(m.relic.skippedRooms or {})}
    end
    pcall(emit,"complete",terminal)
    pcall(print,"OUP BATCH "..string.upper(state.status),state.completed,state.total)
end
local function registerContactController()
    local which=ModCallbacks.MC_PRE_NPC_UPDATE
    local function callback(_,npc)
        if not state or not state.active then return nil end
        local control=state.contactTarget
        if not control or npc.Index~=control.index or npc.InitSeed~=control.seed then return nil end
        local ok,message=pcall(function()
            local drift=distance(npc.Position,control.position)
            control.stats.maxObservedDrift=math.max(control.stats.maxObservedDrift,drift)
            npc.Position=Vector(control.position.X,control.position.Y)
            npc.Velocity=Vector(0,0)
            control.stats.aiSuppressedFrames=control.stats.aiSuppressedFrames+1
        end)
        if not ok then state.pendingError=tostring(message) end
        -- Installed enums.lua:89: true skips internal AI. This is an active
        -- fixture controller, exclusively for the exact owned contact target.
        -- Suppress AI even on a controller error until POST_UPDATE cleans up.
        return true
    end
    mod:AddPriorityCallback(which,-100,callback)
    callbacks[#callbacks+1]={id=which,fn=callback}
end
local function register(which,priority,fn)
    local function callback(...)
        if not state or not state.active then return nil end
        if state.pendingError then
            if which==ModCallbacks.MC_POST_UPDATE then finish("error",state.pendingError) end
            return nil
        end
        local ok,message=pcall(fn,...)
        if not ok then state.pendingError=tostring(message) end
        -- Damage/pickup callbacks can run inside a native Spawn/Explode call.
        -- Unwind that call before removing entities or restoring positions.
        if which==ModCallbacks.MC_POST_UPDATE and state.pendingError then
            finish("error",state.pendingError)
        end
        return nil
    end
    mod:AddPriorityCallback(which,priority,callback)
    callbacks[#callbacks+1]={id=which,fn=callback}
end
local function clearPoint(room,v)
    for _,d in ipairs({Vector(0,0),Vector(16,0),Vector(-16,0),Vector(0,16),Vector(0,-16)}) do
        if not room:IsPositionInRoom(v+d,0) or room:GetGridCollisionAtPos(v+d)~=0 then
            return false
        end
    end
    return true
end
local function chooseSetup(room,players)
    local center=room:GetCenterPos()
    for _,side in ipairs({1,-1}) do
        for _,dy in ipairs({0,-40,40}) do
            local target=center+Vector(side*160,dy)
            local valid=clearPoint(room,target)
            for _,e in ipairs(Isaac.GetRoomEntities()) do
                if e:ToNPC() and distance(e.Position,target)<140 then valid=false end
            end
            local positions={}
            for i=1,#players do
                positions[i]=center+Vector(-side*160,dy+(i-1)*40-20)
                valid=valid and clearPoint(room,positions[i])
            end
            if valid then return target,positions end
        end
    end
    error("No clear isolated fire-test area in this room")
end
playerContext=function(player,index)
    return {index=index,type=player:GetPlayerType(),redHalfHearts=player:GetHearts(),
        soulHalfHearts=player:GetSoulHearts(),blackMask=player:GetBlackHearts(),
        damage=player.Damage,luck=player.Luck,position=pos(player.Position),conflictingItems={
            relic=player:GetCollectibleNum(98),bundle=player:GetCollectibleNum(203),
            darkBum=player:GetCollectibleNum(278),maw=player:GetCollectibleNum(399)}}
end
local function checkHealth()
    for _,p in ipairs(state.players) do
        local a,b=playerContext(p.player,p.index),p.health
        assert(a.soulHalfHearts==b.soulHalfHearts and a.blackMask==b.blackMask,
            "Player protected health changed during fixture")
        if not state.healthMutation or state.healthMutation.player~=p.player then
            assert(a.redHalfHearts==b.redHalfHearts,"Player red health changed during fixture")
        end
    end
end
local function waitFrames(n) return coroutine.yield(n) end
local function addItem(player,item)
    if not state.managedKeys[item] then
        local count=player:GetCollectibleNum(item)
        assert(count==0,"Mechanics fixture requires no pre-existing test item "..item)
        state.managedItems[#state.managedItems+1]={player=player,item=item,count=count}
        state.managedKeys[item]=true
    end
    player:AddCollectible(item,0,false)
end
local function removeItem(player,item)
    while player:GetCollectibleNum(item)>0 do
        local before=player:GetCollectibleNum(item)
        player:RemoveCollectible(item)
        assert(player:GetCollectibleNum(item)<before,"Item removal made no progress")
    end
end
local function findFamiliar(variant,player)
    for _,e in ipairs(Isaac.GetRoomEntities()) do
        local f=e:ToFamiliar()
        if f and f.Variant==variant and f.Player and f.Player.InitSeed==player.InitSeed then return f end
    end
end
local function familiarRecord(f)
    if not f then return nil end
    local record=id(f)
    record.damage,record.size=f.CollisionDamage,f.Size
    record.orbitX,record.orbitY=f.OrbitDistance.X,f.OrbitDistance.Y
    record.processed=f:GetData().processed
    record.roomClearCount=f.RoomClearCount
    return record
end
local function protectPlayers()
    for _,entry in ipairs(state.players) do entry.player:SetMinDamageCooldown(90) end
end
local function orbitalContact(player,withBffs,window)
    local familiar,point
    for _=1,120 do
        familiar=findFamiliar(35,player)
        if familiar and distance(familiar.Position,player.Position)>0 then
            -- Put the target just outside the orbit. Its body can overlap the
            -- dagger without requiring the familiar's center itself to clear
            -- the player by 40 units (a short native orbit cannot do that).
            local radial=familiar.Position-player.Position
            local radius=distance(familiar.Position,player.Position)
            local candidate=familiar.Position+Vector(radial.X/radius*14,radial.Y/radius*14)
            local safe=true
            for _,entry in ipairs(state.players) do
                safe=safe and distance(entry.player.Position,candidate)>=40
            end
            if safe and clearPoint(Game():GetRoom(),candidate) then point=candidate;break end
        end
        waitFrames(1)
    end
    if not familiar or not point then
        local sample={bffs=withBffs,familiar=familiarRecord(familiar),
            status="setup_unavailable",reason="No clear orbital contact point"}
        state.mechanics.orbital[#state.mechanics.orbital+1]=sample
        emit("orbital_result",sample)
        return
    end
    local entity=Isaac.Spawn(15,0,0,point,Vector(0,0),nil)
    state.owned[#state.owned+1]=owned(entity)
    local target=assert(entity:ToNPC(),"Contact target is not an NPC")
    assert(target.Size<=16,"Contact target exceeds verified clearance footprint")
    for _,entry in ipairs(state.players) do
        assert(distance(entry.player.Position,point)>=entry.player.Size+target.Size+8,
            "Contact target overlaps player safety margin")
    end
    target.MaxHitPoints,target.HitPoints=10000,10000
    target:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
    local sample={bffs=withBffs,familiar=familiarRecord(familiar),target=id(target),
        hpBefore=target.HitPoints,events={},startFrame=Game():GetFrameCount(),
        targetControl={anchor=pos(point),aiSuppressedFrames=0,maxObservedDrift=0}}
    state.contactTarget={index=target.Index,seed=target.InitSeed,position=point,stats=sample.targetControl}
    state.orbitalSample=sample
    waitFrames(window)
    sample.endFrame=Game():GetFrameCount()
    sample.hpAfter=target:Exists() and target.HitPoints or nil
    sample.familiarAfter=familiarRecord(findFamiliar(35,player))
    sample.targetAtEnd=target:Exists() and id(target) or nil
    sample.status=#sample.events>0 and "observed" or "no_contact_observed"
    state.mechanics.orbital[#state.mechanics.orbital+1]=sample
    local logged={}
    for field,value in pairs(sample) do if field~="events" then logged[field]=value end end
    logged.damageEventCount=#sample.events
    emit("orbital_result",logged) -- Individual native damage records were already emitted.
    state.orbitalSample=nil
    state.contactTarget=nil
    removeOwned(owned(target))
    waitFrames(3)
end
local function mechanicsWorker(smoke)
    local player=state.players[1].player
    -- Let this fixture's previous <=90-frame protection expire before the
    -- controlled crush input. Do not mistake invulnerability for an unnerf.
    waitFrames(95)
    -- Real engine damage request, not evidence of a native Mom attack.
    addItem(player,223)
    waitFrames(2)
    local original=player:GetHearts()
    assert(original>=6 and player:GetMaxHearts()>=6,"Crush contract needs six red half-hearts")
    assert(player:GetSoulHearts()==0 and player:GetBlackHearts()==0,
        "Crush contract needs no soul or black hearts on actor zero")
    state.healthMutation={player=player,original=original}
    player:AddHearts(4-player:GetHearts())
    waitFrames(1)
    local before=player:GetHearts()
    state.crushActive=true
    local accepted=player:TakeDamage(2,DamageFlag.DAMAGE_CRUSH,EntityRef(player),0)
    state.crushActive=false
    waitFrames(2)
    state.mechanics.crushContract={input="synthetic_engine_crush",before=before,
        after=player:GetHearts(),returned=accepted}
    emit("crush_engine_contract",state.mechanics.crushContract)
    player:AddHearts(original-player:GetHearts())
    state.healthMutation=nil
    removeItem(player,223)
    state.protectActors=true
    protectPlayers()
    waitFrames(30)

    addItem(player,172)
    waitFrames(20)
    orbitalContact(player,false,180)
    addItem(player,247)
    waitFrames(20)
    orbitalContact(player,true,180)
    removeItem(player,172)
    removeItem(player,247)
    waitFrames(5)
    -- Two levels exercise native familiar creation/type-state handling without
    -- manufacturing a transition or assuming an InitSeed survives it.
    addItem(player,73)
    waitFrames(20)
    local first={}
    for _,e in ipairs(Isaac.GetRoomEntities()) do
        local f=e:ToFamiliar()
        if f and f.Player and f.Player.InitSeed==player.InitSeed then first[#first+1]=familiarRecord(f) end
    end
    addItem(player,73)
    waitFrames(20)
    local second={}
    for _,e in ipairs(Isaac.GetRoomEntities()) do
        local f=e:ToFamiliar()
        if f and f.Player and f.Player.InitSeed==player.InitSeed then second[#second+1]=familiarRecord(f) end
    end
    state.mechanics.meat={oneCopy=first,twoCopies=second}
    emit("meat_native_states",state.mechanics.meat)
    removeItem(player,73)
    waitFrames(5)

    addItem(player,98)
    waitFrames(25)
    local relic=findFamiliar(23,player)
    assert(relic,"Relic familiar did not appear")
    state.mechanics.relic.initial=familiarRecord(relic)
    state.mechanics.relic.skippedRooms={}
    state.relicActive=true
    local rooms=Game():GetLevel():GetRooms()
    assert(type(rooms.Size)=="number" and type(rooms.Get)=="function","Room list interface unavailable")
    local candidates={}
    for i=0,rooms.Size-1 do
        local desc=rooms:Get(i)
        if #candidates<12 and desc.Data and desc.Data.Type==1 and desc.VisitedCount==0 and
            desc.SafeGridIndex~=state.roomIndex then candidates[#candidates+1]=desc.SafeGridIndex end
    end
    local cleared,limit=0,smoke and 1 or 8
    for _,index in ipairs(candidates) do
        if cleared>=limit then break end
        protectPlayers()
        Game():ChangeRoom(index)
        waitFrames(10)
        local room=Game():GetRoom()
        if not room:IsClear() and room:GetAliveEnemiesCount()>0 then
            state.relicClearOrdinal=cleared+1
            local beforeCount=findFamiliar(23,player)
            local before=familiarRecord(beforeCount)
            -- Native deaths can leave children or later waves alive. Retry
            -- living NPCs across real updates, without writing clear flags.
            for _=1,8 do
                if room:IsClear() then break end
                for _,e in ipairs(Isaac.GetRoomEntities()) do
                    local npc=e:ToNPC()
                    if npc and npc.Type~=33 and not npc:IsDead() then npc:Kill() end
                end
                waitFrames(15)
            end
            if room:IsClear() then
                waitFrames(90) -- Let native familiar payout animation settle.
                cleared=cleared+1
                local result={ordinal=cleared,room=index,before=before,
                    after=familiarRecord(findFamiliar(23,player))}
                state.mechanics.relic.clears[#state.mechanics.relic.clears+1]=result
                emit("relic_native_clear",result)
            else
                local unresolved={room=index,aliveEnemies=room:GetAliveEnemiesCount(),
                    before=before,after=familiarRecord(findFamiliar(23,player)),
                    reason="Native hostile room did not clear within bounded retries"}
                state.mechanics.relic.skippedRooms[#state.mechanics.relic.skippedRooms+1]=unresolved
                emit("relic_unresolved_room",unresolved)
            end
        end
    end
    state.mechanics.relic.clearCount=cleared
    state.mechanics.relic.status=cleared>0 and "native_clears_observed" or
        (#state.mechanics.relic.skippedRooms>0 and "native_clears_unresolved" or "no_hostile_rooms_available")
    emit("relic_result",{initial=state.mechanics.relic.initial,clearCount=cleared,
        payoutCount=#state.mechanics.relic.payouts,
        unresolvedCount=#state.mechanics.relic.skippedRooms,status=state.mechanics.relic.status})
    state.relicActive=false
    removeItem(player,98)
    waitFrames(5)
    protectPlayers()
    Game():ChangeRoom(state.roomIndex)
    waitFrames(15)
end
local function trialPickups(trial)
    local pickups={}
    for _,e in ipairs(Isaac.GetRoomEntities()) do
        if e.Type==5 and e.Variant==10 and not trial.existing[key(e)] and
            trial.candidateSeeds[tostring(e.InitSeed)] then
            pickups[#pickups+1]=e
        end
    end
    return pickups
end
local function advance()
    assert(Game():GetNumPlayers()==#state.players,"Player count changed during batch")
    if state.protectActors then protectPlayers() end
    checkHealth()
    local frame=Game():GetFrameCount()
    for _,entry in ipairs(state.owned) do
        if entry.removeAfter and frame>=entry.removeAfter then removeOwned(entry) end
    end
    if state.worker then
        if frame<(state.due or 0) then return end
        local ok,delay=coroutine.resume(state.worker)
        assert(ok,delay)
        if coroutine.status(state.worker)=="dead" then
            state.worker=nil
            assert(Game():GetLevel():GetCurrentRoomIndex()==state.roomIndex,"Mechanics did not return to start room")
            for i,entry in ipairs(state.players) do entry.player.Position=state.fixturePositions[i] end
            state.step="spawn"
        else
            state.due=frame+(tonumber(delay) or 1)
        end
        return
    end
    assert(Game():GetLevel():GetCurrentRoomIndex()==state.roomIndex,"Room changed during batch")
    if state.step=="spawn" then
        local variant=state.completed<state.perVariant and 2 or 3
        local trial={number=state.completed+1,variant=variant,damageEvents=0,existing={},
            initEvents=0,firstUpdates={},candidateSeeds={},phase="spawn"}
        for _,e in ipairs(Isaac.GetRoomEntities()) do
            if e.Type==5 then trial.existing[key(e)]=true end
        end
        state.trial=trial
        trial.fire=Isaac.Spawn(33,variant,0,state.targetPosition,Vector(0,0),nil)
        trial.identity=id(trial.fire)
        state.owned[#state.owned+1]=owned(trial.fire)
        state.due=frame+2
        state.step="explode"
        emit("trial_spawn",{trial=trial.number,target=trial.identity})
    elseif state.step=="explode" and frame>=state.due then
        state.trial.phase="explode"
        Isaac.Explode(state.targetPosition,state.players[1].player,100)
        state.trial.phase="after_explode"
        state.due=frame+3
        state.step="settle"
    elseif state.step=="settle" and frame>=state.due then
        local t=state.trial
        local exists=t.fire:Exists()
        local animation=exists and t.fire:GetSprite():GetAnimation() or nil
        local extinguished=not exists or t.fire:IsDead() or animation=="NoFire"
        local pickups=trialPickups(t)
        local observed={}
        for _,pickup in ipairs(pickups) do
            observed[#observed+1]=id(pickup)
            state.owned[#state.owned+1]=owned(pickup)
        end
        emit("trial_result",{trial=t.number,variant=t.variant,damageEvents=t.damageEvents,
            extinguished=extinguished,animation=animation,hp=exists and t.fire.HitPoints or nil,
            heartInitEvents=t.initEvents,heartPickups=observed})
        assert(t.damageEvents>0 and extinguished,"Fire trial did not reach an observed extinguishing hit")
        local group=state.groups[tostring(t.variant)]
        group.valid=group.valid+1
        local count=tostring(#pickups)
        group.histogram[count]=(group.histogram[count] or 0)+1
        for _,pickup in ipairs(pickups) do
            local subtype=tostring(pickup.SubType)
            group.subtypes[subtype]=(group.subtypes[subtype] or 0)+1
        end
        for _,entry in ipairs(state.owned) do removeOwned(entry) end
        state.owned={}
        state.completed=state.completed+1
        state.trial=nil
        if state.completed==state.total then finish("complete") else state.step="spawn" end
    end
end
function batch.Run(options)
    options=options or {}
    assert(not state or not state.active,"Batch already running")
    assert(options.mechanics==nil or type(options.mechanics)=="boolean","mechanics must be boolean")
    assert(options.smoke==nil or type(options.smoke)=="boolean","smoke must be boolean")
    assert(options.label==nil or (type(options.label)=="string" and #options.label<=80),
        "label must be a short string")
    local n=options.trialsPerVariant or 200
    assert(type(n)=="number" and n==math.floor(n) and n>=1 and n<=200,
        "trialsPerVariant must be an integer from 1 to 200")
    local game,room=Game(),Game():GetRoom()
    assert(room:IsClear() and room:GetAliveEnemiesCount()==0,"Use a cleared disposable room")
    local players,context={},{packPresent=openUnnerfPack~=nil,players={},settings={}}
    for index=0,game:GetNumPlayers()-1 do
        local p=Isaac.GetPlayer(index)
        for _,item in ipairs({98,203,278,399}) do
            assert(p:GetCollectibleNum(item)==0,"Remove conflicting fixture items before this batch")
        end
        local health=playerContext(p,index)
        players[#players+1]={player=p,index=index,position=Vector(p.Position.X,p.Position.Y),health=health}
        context.players[#context.players+1]=health
    end
    if options.mechanics then
        assert(type(ModCallbacks.MC_PRE_NPC_UPDATE)=="number","Native target controller API unavailable")
        local player=players[1].player
        assert(player:GetHearts()>=6 and player:GetMaxHearts()>=6 and
            player:GetSoulHearts()==0 and player:GetBlackHearts()==0,
            "Mechanics needs six red half-hearts and no soul or black hearts on actor zero")
    end
    local target,positions=chooseSetup(room,players)
    if openUnnerfPack then
        for _,k in ipairs({"mawOfTheVoid","orbitals","stompImmunity","humblingBundle","darkBum","relic","blueFires"}) do
            context.settings[k]=openUnnerfPack.Config.IsEnabled(k)
        end
    end
    state={active=true,status="running",label=options.label or "fire-batch",players=players,
        context=context,roomIndex=game:GetLevel():GetCurrentRoomIndex(),targetPosition=target,
        completed=0,total=n*2,perVariant=n,owned={},managedItems={},managedKeys={},
        fixturePositions=positions,step="spawn",
        protectActors=not options.mechanics,
        groups={["2"]={valid=0,histogram={},subtypes={}},
            ["3"]={valid=0,histogram={},subtypes={}}}}
    if options.mechanics then
        state.mechanics={orbital={},relic={clears={},payouts={}}}
        state.worker=coroutine.create(function() mechanicsWorker(options.smoke==true) end)
    end
    local ok,message=pcall(function()
        if options.mechanics then registerContactController() end
        register(ModCallbacks.MC_ENTITY_TAKE_DMG,-100,function(_,e,amount,flags,source)
            if state.crushActive and e.Type==1 then
                emit("crush_requested_damage",{target=id(e),amount=amount,flags=flags,
                    source=id(source and source.Entity)})
            end
            local sample=state.orbitalSample
            if sample and key(e)==tostring(sample.target.index)..":"..tostring(sample.target.seed) then
                local event={frame=Game():GetFrameCount(),amount=amount,flags=flags,
                    hpBefore=e.HitPoints,source=id(source and source.Entity),target=id(e),bffs=sample.bffs}
                sample.events[#sample.events+1]=event
                emit("orbital_damage",event)
            end
            local t=state.trial
            if not t or key(e)~=key(t.fire) then return end
            t.damageEvents=t.damageEvents+1
            t.phase="damage_callbacks"
            emit("damage_early",{trial=t.number,target=id(e),amount=amount,flags=flags,
                source=id(source and source.Entity),hpBefore=e.HitPoints})
        end)
        register(ModCallbacks.MC_ENTITY_TAKE_DMG,100,function(_,e)
            local t=state.trial
            if t and key(e)==key(t.fire) then t.phase="after_callbacks" end
        end)
        register(ModCallbacks.MC_POST_PICKUP_INIT,100,function(_,pickup)
            if state.relicActive then
                local spawner=pickup.SpawnerEntity
                local familiar=spawner and spawner:ToFamiliar()
                if familiar and familiar.Variant==23 then
                    local payout={ordinal=state.relicClearOrdinal,frame=Game():GetFrameCount(),
                        familiar=familiarRecord(familiar),pickup=id(pickup)}
                    state.mechanics.relic.payouts[#state.mechanics.relic.payouts+1]=payout
                    local entry=owned(pickup)
                    entry.removeAfter=Game():GetFrameCount()+1
                    state.owned[#state.owned+1]=entry
                    emit("relic_native_pickup",payout)
                end
            end
            local t=state.trial
            if not t or pickup.Variant~=10 or distance(pickup.Position,state.targetPosition)>96 then return end
            t.initEvents=t.initEvents+1
            local spawner=pickup.SpawnerEntity
            local fromFire=spawner and spawner.Type==33 and key(spawner)==key(t.fire)
            local atFire=distance(pickup.Position,state.targetPosition)<=8
            if fromFire or atFire then t.candidateSeeds[tostring(pickup.InitSeed)]=true end
            emit("heart_init",{trial=t.number,phase=t.phase,pickup=id(pickup),
                spawner=id(spawner),spawnerType=pickup.SpawnerType,
                candidate=not not (fromFire or atFire)})
        end)
        register(ModCallbacks.MC_POST_PICKUP_UPDATE,100,function(_,pickup)
            local t=state.trial
            if not t or pickup.Variant~=10 or t.existing[key(pickup)] or
                distance(pickup.Position,state.targetPosition)>96 or t.firstUpdates[key(pickup)] then return end
            t.firstUpdates[key(pickup)]=true
            local spawner=pickup.SpawnerEntity
            if spawner and spawner.Type==33 and key(spawner)==key(t.fire) then
                t.candidateSeeds[tostring(pickup.InitSeed)]=true
            end
            emit("heart_first_update",{trial=t.number,pickup=id(pickup),
                spawner=id(pickup.SpawnerEntity),spawnerType=pickup.SpawnerType})
        end)
        register(ModCallbacks.MC_POST_UPDATE,100,advance)
        if options.mechanics then
            register(ModCallbacks.MC_POST_NEW_ROOM,100,function()
                if state.relicActive then protectPlayers() end
            end)
        end
        if state.protectActors then protectPlayers() end
        for i,entry in ipairs(players) do entry.player.Position=positions[i] end
        local fixturePositions={}
        for i,v in ipairs(positions) do fixturePositions[i]=pos(v) end
        emit("start",{context=context,trialsPerVariant=n,target=pos(target),
            fixturePositions=fixturePositions})
    end)
    if not ok then finish("error",tostring(message)) end
    if state.active then pcall(print,"OUP BATCH START",state.label,state.total) end
end
function batch.Status()
    local result=report()
    pcall(print,"OUP BATCH STATUS",result.status,result.completed or 0,result.total or 0)
    return result
end
function batch.Stop()
    if state and state.active then finish("stopped") end
    if OUPBatch==batch then OUPBatch=nil end
end
print("OUP BATCH READY; explicit Run required, Stop restores owned fixture state")
