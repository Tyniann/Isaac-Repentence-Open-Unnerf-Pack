-- Protocol smoke for the disposable capacity probe; no engine claims.
local json = require("dkjson")
package.preload.json = function() return {encode = json.encode} end
CollectibleType = {COLLECTIBLE_BLANK_CARD=286}
PlayerType = {PLAYER_ISAAC=0}
Card = {RUNE_JERA=33}
ModCallbacks = {MC_POST_UPDATE=1,MC_PRE_GAME_EXIT=2}
EntityType = {ENTITY_PICKUP=5}
PickupVariant = {PICKUP_COLLECTIBLE=100,PICKUP_LIL_BATTERY=90}
BatterySubType = {BATTERY_NORMAL=1}
Vector = {Zero={}}
local function run(kind)
    local callbacks, events, batteries = {}, {}, {}
    local frame, maximum, count, charge, childUses = 0,2,1,2,0
    local child={status='complete'}
    OUPBlankCardBatch = {
        Status=function() return child end,
        Run=function() child={status='running'}; childUses=childUses+1 end,
        Stop=function() child.status='stopped' end}
    local player={Position={}}
    function player:GetActiveItem(slot) return slot==0 and 286 or 0 end
    function player:GetActiveCharge(slot) return slot==0 and charge or 0 end
    function player:GetBatteryCharge() return 0 end
    function player:GetCollectibleNum() return count end
    function player:GetCollectibleCount() return count end
    function player:GetCard() return 33 end
    function player:GetPlayerType() return 0 end
    function player:NeedsCharge(slot) assert(slot==0); return charge<maximum end
    function player:AddCollectible(id,value,first,slot,varData)
        assert(id==286 and value==2 and first==false and slot==0 and varData==4)
        if kind=='duplicate' then count=count+1
        elseif kind=='freecharge' then charge=4
        elseif kind~='noop' then maximum=4 end
    end
    if kind=='direct' then
        function player:SetActiveVarData(value,slot) assert(value==4 and slot==0); maximum=value end
    end
    function RegisterMod()
        return {AddCallback=function(_,id,fn) callbacks[id]=fn end,
            RemoveCallback=function(_,id,fn) assert(callbacks[id]==fn); callbacks[id]=nil end}
    end
    local game={GetFrameCount=function() return frame end,
        GetNumPlayers=function() return 1 end,
        GetSeeds=function() return {GetStartSeed=function() return 99 end} end}
    function Game() return game end
    Isaac = {GetPlayer=function() return player end, FindByType=function() return {} end,
        DebugString=function(line) events[#events+1]=assert(json.decode(line:match('^OUP_BLANK_CARD (.+)$'))) end,
        Spawn=function()
            local pickup={InitSeed=5,alive=true}
            function pickup:ToPickup() return self end
            function pickup:Exists() return self.alive end
            function pickup:Remove() self.alive=false end
            batteries[#batteries+1]=pickup
            return pickup
        end}
    dofile('tools/validation/blank-card-jera-capacity.lua')
    for _=1,10 do
        frame=frame+1
        for _,battery in ipairs(batteries) do
            if battery.alive then battery.alive=false; charge=maximum end
        end
        if child.status=='running' then child.status='complete' end
        if callbacks[1] then callbacks[1]() end
    end
    assert(next(callbacks)==nil, 'terminal result removes exact callbacks')
    local result=events[#events].event
    if kind=='duplicate' or kind=='freecharge' then
        assert(result=='capacity_rejected' and childUses==0)
    elseif kind=='noop' then
        assert(result=='capacity_unsupported' and childUses==0)
    else
        assert(result=='capacity_complete' and childUses==1 and charge==4 and count==1)
    end
end
for _,kind in ipairs({'direct','grant','duplicate','freecharge','noop'}) do run(kind) end
print('Capacity probe protocol passed: API/grant paths, invariants, real-pickup boundary and cleanup; native behavior untested')
