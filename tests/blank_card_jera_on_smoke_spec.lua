-- Disposable smoke-controller contract; the child is a stub, not an engine.
local json = require('dkjson')
package.preload.json=function() return {encode=json.encode} end
ModCallbacks={MC_POST_UPDATE=1,MC_USE_CARD=2,MC_PRE_GAME_EXIT=3}
CollectibleType={COLLECTIBLE_BLANK_CARD=286}
Card={RUNE_JERA=33}
PlayerType={PLAYER_ISAAC=0}
EntityType={ENTITY_PICKUP=5}
PickupVariant={PICKUP_COIN=20,PICKUP_LIL_BATTERY=90,PICKUP_CHEST=50}
CoinSubType={COIN_PENNY=1}
BatterySubType={BATTERY_NORMAL=1}
ChestSubType={CHEST_CLOSED=1}
local vectorMT={__add=function(a,b) return setmetatable({x=a.x+b.x,y=a.y+b.y},getmetatable(a)) end}
Vector=setmetatable({},{__call=function(_,x,y) return setmetatable({x=x,y=y},vectorMT) end})
Vector.Zero=Vector(0,0)
GetPtrHash=function(value) return value end
openUnnerfPack={Config={IsEnabled=function(key) assert(key=='blankCardJera'); return true end}}
local function run(failChild,foreign)
    local callbacks,entities,events={},{},{}
    local frame,grants=0,0
    local child={status='idle'}
    local p={item=105,card=0,charge=6}
    function p:GetActiveItem() return self.item end
    function p:GetActiveCharge() return self.charge end
    function p:GetBatteryCharge() return 0 end
    function p:GetCollectibleNum() return self.item==286 and 1 or 0 end
    function p:GetCard() return self.card end
    function p:SetCard(_,value) self.card=value end
    function p:GetPlayerType() return 0 end
    function p:RemoveCollectible(id) assert(id==105); self.item=0 end
    function p:AddCollectible(id,value,first,slot,varData)
        assert(id==286 and value==4 and first==false and slot==0 and varData==4)
        grants=grants+1; self.item,self.charge=id,value
    end
    function RegisterMod() return {AddCallback=function(_,id,fn) callbacks[id]=fn end,
        RemoveCallback=function(_,id,fn) assert(callbacks[id]==fn); callbacks[id]=nil end} end
    local room={IsClear=function() return true end,GetCenterPos=function() return Vector(320,280) end,
        FindFreePickupSpawnPosition=function(_,position) return position end}
    local game={GetFrameCount=function() return frame end,GetRoom=function() return room end,
        GetNumPlayers=function() return 1 end,GetSeeds=function() return {GetStartSeed=function() return 101 end} end}
    function Game() return game end
    local function spawn(kind,variant,subtype)
        assert(kind==5 and subtype==1)
        local entity={variant=variant,alive=true}
        function entity:Remove() self.alive=false end
        entities[#entities+1]=entity; return entity
    end
    Isaac={GetPlayer=function() return p end,Spawn=spawn,
        FindByType=function(kind,variant)
            assert(kind==5)
            local values={}
            for _,e in ipairs(entities) do if e.alive and (variant==-1 or variant==e.variant) then values[#values+1]=e end end
            return values
        end,
        DebugString=function(line) events[#events+1]=assert(json.decode(line:match('^OUP_BLANK_CARD (.+)$'))) end}
    OUPBlankCardBatch={Run=function() child.status='running' end,Status=function() return child end,
        Stop=function() child.status='stopped' end}
    if foreign then spawn(5,20,1) end
    local ok=pcall(dofile,'tools/validation/blank-card-jera-on-smoke.lua')
    if foreign then assert(not ok and entities[1].alive and grants==0); return end
    assert(ok and grants==1 and #entities==3)
    frame=1
    if failChild then child.status='error'; child.message='mock native failure'
    else
        callbacks[2](nil,33,p,384)
        for _,variant in ipairs({20,90,50}) do spawn(5,variant,1) end
        child.status='complete'
    end
    callbacks[1]()
    assert(next(callbacks)==nil and grants==1)
    for _,entity in ipairs(entities) do assert(not entity.alive) end
    assert(events[#events].event=='on_smoke_cleanup')
    assert(events[#events-1].event==(failChild and 'on_smoke_error' or 'on_smoke_complete'))
end
run(false,false);run(true,false);run(false,true)
print('On-smoke fixture protocol passed: setup, witness, failure, cleanup and foreign-pickup refusal; native pass still pending')
