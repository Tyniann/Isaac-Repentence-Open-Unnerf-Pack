-- Matrix-controller protocol only. This tiny fake engine is deliberately able
-- to lose overcharge, proving that the fixture rejects that fault.
local json = require('dkjson')
package.preload.json=function() return {encode=json.encode,decode=json.decode} end
ModCallbacks={MC_USE_ITEM=1,MC_USE_CARD=2,MC_INPUT_ACTION=3,MC_POST_UPDATE=4,MC_PRE_GAME_EXIT=5,MC_POST_GAME_STARTED=6,MC_POST_PLAYER_UPDATE=7}
CollectibleType={COLLECTIBLE_BLANK_CARD=286,COLLECTIBLE_BATTERY=63,COLLECTIBLE_CAR_BATTERY=356,COLLECTIBLE_SCHOOLBAG=534}
Card={RUNE_JERA=33,CARD_MAGICIAN=2,RUNE_DAGAZ=35}
RoomShape={ROOMSHAPE_1x1=1,ROOMSHAPE_2x2=8}
UseFlag={USE_MIMIC=128,USE_NOANNOUNCER=256,USE_CARBATTERY=32}
PlayerType={PLAYER_ISAAC=0}
EntityType={ENTITY_PICKUP=5}
PickupVariant={PICKUP_LIL_BATTERY=90,PICKUP_COIN=20,PICKUP_KEY=30,PICKUP_BOMB=40,PICKUP_HEART=10}
CoinSubType={COIN_PENNY=1}
BatterySubType={BATTERY_NORMAL=1}
ButtonAction={ACTION_ITEM=5}
InputHook={IS_ACTION_PRESSED=0,IS_ACTION_TRIGGERED=1,GET_ACTION_VALUE=2}
local vectorMeta={__add=function(a,b) return {x=(a.x or 0)+b.x,y=(a.y or 0)+b.y} end}
Vector=setmetatable({Zero={}}, {__call=function(_,x,y) return setmetatable({x=x,y=y},vectorMeta) end})
GetPtrHash=function(value) return value end
local function check(mode,resetBlue,startEmpty,shortMap)
    local handlers,events,entities={}, {}, {}
    local frame,charge,maximum=0,4,4
    if startEmpty then charge=0 end
    local inventory={[286]=1}
    local enabled=mode~='off'
    local currentRoom,stage,stageCommands=84,1,0
    local rooms,byIndex
    local function map(smallCount)
        rooms={{SafeGridIndex=84,VisitedCount=1,Data={Type=1,Shape=1},alive=false},
            {SafeGridIndex=101,VisitedCount=0,Data={Type=1,Shape=8},alive=true}}
        for index=1,smallCount do rooms[#rooms+1]={SafeGridIndex=101+index,VisitedCount=0,Data={Type=1,Shape=1},alive=true} end
        byIndex={}
        for _,desc in ipairs(rooms) do byIndex[desc.SafeGridIndex]=desc end
    end
    map(shortMap and 3 or 4)
    local function emit(id,...)
        local copy={}
        for _,entry in ipairs(handlers[id] or {}) do copy[#copy+1]=entry end
        for _,entry in ipairs(copy) do
            if not entry.filter or entry.filter==select(1,...) then entry.fn(entry.mod,...) end
        end
    end
    function RegisterMod(name)
        local mod={name=name}
        function mod:AddCallback(id,fn,filter)
            handlers[id]=handlers[id] or {}
            handlers[id][#handlers[id]+1]={mod=self,fn=fn,filter=filter}
        end
        function mod:RemoveCallback(id,fn)
            for index,entry in ipairs(handlers[id]) do
                if entry.mod==self and entry.fn==fn then table.remove(handlers[id],index);return end
            end
            error('removed a foreign callback')
        end
        return mod
    end
    local p={InitSeed=19,ControllerIndex=0,Position={},item=enabled and 286 or 105,card=33}
    if not enabled then inventory={[105]=1};charge=6;maximum=6 end
    function p:ToPlayer() return self end
    function p:GetPlayerType() return 0 end
    function p:GetActiveItem(slot) return slot==0 and self.item or 0 end
    function p:GetActiveCharge(slot) return slot==0 and math.min(charge,maximum) or 0 end
    function p:GetBatteryCharge(slot) return slot==0 and math.max(0,charge-maximum) or 0 end
    function p:GetCollectibleNum(id) return inventory[id] or 0 end
    function p:HasCollectible(id) return (inventory[id] or 0)>0 end
    function p:GetCard(index) assert(index==0);return self.card end
    function p:SetCard(index,value) assert(index==0);self.card=value end
    function p:SetMinDamageCooldown(value) assert(value==90) end
    function p:AddCollectible(id,value,first,slot,varData)
        assert(first==false)
        if id==286 then
            if inventory[id] then
                assert(slot==0 and varData==4)
            else inventory[id]=1;self.item=id;charge=value end
            maximum=4
        else assert(id==63 or id==356);inventory[id]=1 end
    end
    function p:RemoveCollectible(id)
        inventory[id]=nil
        if self.item==id then self.item=0 end
        if id==63 then charge=math.min(charge,maximum) end
    end
    function p:UseCard(card,flags)
        assert(card==33 and flags==384);emit(2,card,self,flags)
        local originalCount=#entities
        for index=1,originalCount do
            local e=entities[index]
            if e.alive and e.Variant==20 then Isaac.Spawn(5,20,1,e.Position) end
        end
    end
    local room={IsClear=function() return not byIndex[currentRoom].alive end,
        GetAliveEnemiesCount=function() return byIndex[currentRoom].alive and 1 or 0 end,
        GetRoomShape=function() return byIndex[currentRoom].Data.Shape end,
        GetCenterPos=function() return Vector(0,0) end,GetTopLeftPos=function() return Vector(0,0) end,
        FindFreePickupSpawnPosition=function(_,pos) return pos end}
    local level={GetCurrentRoomIndex=function() return currentRoom end,GetStartingRoomIndex=function() return 84 end,
        GetStage=function() return stage end,GetRooms=function() return {Size=#rooms,Get=function(_,i) return rooms[i+1] end} end}
    local game={GetFrameCount=function() return frame end,GetNumPlayers=function() return 1 end,
        GetSeeds=function() return {GetStartSeed=function() return 93 end} end,
        GetLevel=function() return level end,GetRoom=function() return room end,
        ChangeRoom=function(_,index) currentRoom=index;byIndex[index].VisitedCount=byIndex[index].VisitedCount+1 end}
    function Game() return game end
    Isaac={GetPlayer=function() return p end,
        ExecuteCommand=function(command)
            local nextStage=command:match('^stage ([23])$')
            if nextStage then stage=tonumber(nextStage);stageCommands=stageCommands+1;map(4);currentRoom=84
            else assert(command=='addplayer 0 1') end
        end,
        GetRoomEntities=function()
            local desc=byIndex[currentRoom]
            if not desc.alive then return {} end
            local npc={Type=10,IsDead=function() return not desc.alive end}
            function npc:ToNPC() return self end
            function npc:Kill() desc.alive=false;charge=math.min(maximum,charge+(desc.Data.Shape==1 and 1 or 2)) end
            return {npc}
        end,
        DebugString=function(line) events[#events+1]=assert(json.decode(line:match('^OUP_BLANK_CARD (.+)$'))) end,
        FindByType=function(kind,variant)
            assert(kind==5);local result={}
            for _,e in ipairs(entities) do if e.alive and (variant==-1 or variant==e.Variant) then result[#result+1]=e end end
            return result
        end,
        Spawn=function(kind,variant,subtype,position)
            assert(kind==5 and (variant==90 or variant==20) and subtype==1)
            local e={InitSeed=#entities+100,alive=true,Position=position,Variant=variant}
            function e:Exists() return self.alive end
            function e:ToPickup() return self end
            function e:Remove() self.alive=false end
            entities[#entities+1]=e;return e
        end}
    local nextSetting=true
    ModConfigMenu={GetCategoryIDByName=function(name) assert(name=='Open Unnerf Pack 2');return 1 end,
        MenuData={{{Display=function() return 'Blank Card + Jera: On' end,
            OnChange=function(value) nextSetting=value end,CurrentSetting=function() return nextSetting end}}}}
    openUnnerfPack={LoadData=function() return json.encode({settings={blankCardJera=nextSetting},run={settings={blankCardJera=true}}}) end,
        Config={IsEnabled=function(key) assert(key=='blankCardJera');return enabled end,
        AddRunStartListener=function() end}}
    dofile('Mods/Blank Card Jera Unnerf/main.lua')
    local matrix=dofile('tools/validation/blank-card-jera-matrix.lua')
    assert(not handlers[3] and not handlers[4], 'load must be passive')
    matrix.Run(mode)
    local result=matrix.Status()
    for _=1,400 do
        frame=frame+1
        local input=handlers[3] and handlers[3][1]
        if input then
            assert(input.fn(input.mod,p,1,99)==nil)
            local foreign={ToPlayer=function(self)return self end}
            assert(input.fn(input.mod,foreign,1,5)==nil)
            local trigger=input.fn(input.mod,p,1,5)
            if trigger and charge>=maximum then
                local spent=maximum
                for repetition=1,(p:HasCollectible(356) and 2 or 1) do
                    if p.card==2 then emit(2,2,p,384);maximum=2 end
                    emit(1,p.item,{},p,repetition==1 and 4 or 1569,
                        repetition==1 and 0 or -1,repetition==1 and 0 or spent)
                end
                if resetBlue then charge=math.min(charge,maximum) end -- Inject the old reserve-loss fault.
                charge=math.max(0,charge-spent)
                assert(input.fn(input.mod,p,1,5)==false and input.fn(input.mod,p,0,5)==false
                    and input.fn(input.mod,p,2,5)==0, 'release every input hook after the first native use in that frame')
            end
        end
        emit(7,p)
        for _,e in ipairs(entities) do
            local capacity=maximum*(p:HasCollectible(63) and 2 or 1)
            if e.alive and e.Variant==90 and e.Position==p.Position and charge<capacity then e.alive=false;charge=math.min(capacity,charge+6) end
        end
        emit(4)
        if result.status~='running' then break end
    end
    if resetBlue then assert(result.status=='error' and result.message:find('stored battery charge'))
    elseif mode=='finish-on' then
        assert(result.status=='pending' and #result.cases==2,result.message)
        local clears=0
        for _,event in ipairs(events) do if event.event=='ordinary_room_clear' then
            clears=clears+1;assert(event.details.shape==1 and event.details.before==clears-1 and event.details.after==clears)
        end end
        assert(clears==4 and stageCommands==(shortMap and 1 or 0))
    else assert(result.status=='complete' and #result.cases==3,result.message) end
    assert(not p:HasCollectible(63) and not p:HasCollectible(356), 'test-owned passives must be removed on success/error')
    assert(#(handlers[3] or {})==0 and #(handlers[4] or {})==0)
    assert(#handlers[1]==1 and #handlers[5]==1 and #handlers[7]==1 and #handlers[6]==1,
        'production callbacks and passive start observation survive')
end
check('battery-smoke',false);check('battery-smoke',false,true);check('battery-smoke',true);check('car-battery',false);check('off',false)
check('finish-on',false)
check('finish-on',false,false,true)
print('Matrix protocol passed: input scoping, stored-charge fault detection, Car Battery control, disabled control and exact cleanup; native proof remains separate')
