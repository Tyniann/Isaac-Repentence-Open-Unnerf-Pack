-- Driver safety/protocol only. Mocked charges below are not native evidence.
local json = require("dkjson")
package.preload.json = function() return {encode = json.encode} end
ModCallbacks = {MC_INPUT_ACTION=1, MC_USE_ITEM=2, MC_POST_UPDATE=3, MC_PRE_GAME_EXIT=4}
CollectibleType = {COLLECTIBLE_BLANK_CARD=286, COLLECTIBLE_CAR_BATTERY=356}
EntityType = {ENTITY_PICKUP=5}
PickupVariant = {PICKUP_LIL_BATTERY=90}
BatterySubType = {BATTERY_NORMAL=1}
PlayerType = {PLAYER_ISAAC=0}
Card = {RUNE_JERA=33, CARD_MAGICIAN=2}
ButtonAction = {ACTION_ITEM=5}
InputHook = {GET_ACTION_VALUE=0, IS_ACTION_PRESSED=1, IS_ACTION_TRIGGERED=2}
Vector = {Zero={}}
GetPtrHash = function(value) return value end
local registered, events, batteries = {}, {}, {}
local frame, nativeUses, maxCharge = 0, 0, 4
local allowInput, allowBattery = true, true
local mod = {}
function mod:AddCallback(id, fn, filter) registered[id]={fn=fn,filter=filter} end
function mod:RemoveCallback(id, fn) assert(registered[id].fn==fn); registered[id]=nil end
function RegisterMod() return mod end
local player = {InitSeed=19, Position={}, card=33, charge=4}
function player:GetActiveItem(slot) assert(slot==0); return 286 end
function player:GetActiveCharge(slot) assert(slot==0); return self.charge end
function player:GetBatteryCharge(slot) assert(slot==0); return 0 end
function player:GetCard(slot) assert(slot==0); return self.card end
function player:SetCard(slot, value) assert(slot==0); self.card=value end
function player:GetCollectibleNum(id, actual) assert(id==286 and actual); return 1 end
function player:HasCollectible(id) assert(id==356); return false end
function player:GetPlayerType() return 0 end
function player:ToPlayer() return self end
local game = {}
function game:GetFrameCount() return frame end
function game:GetSeeds() return {GetStartSeed=function() return 37 end} end
function game:GetNumPlayers() return 1 end
function game:GetRoom() return {IsClear=function() return true end} end
function Game() return game end
Isaac = {GetPlayer=function() return player end,
    DebugString=function(line)
        local record = assert(json.decode(assert(line:match('^OUP_BLANK_CARD (.+)$'))))
        events[#events+1]=record
    end,
    Spawn=function(kind,variant,subtype,position,velocity,spawner)
        assert(kind==5 and variant==90 and subtype==1 and position==player.Position)
        assert(velocity==Vector.Zero and spawner==nil)
        local pickup={InitSeed=800+#batteries, alive=true}
        function pickup:ToPickup() return self end
        function pickup:Exists() return self.alive end
        function pickup:Remove() self.alive=false end
        batteries[#batteries+1]=pickup
        return pickup
    end}
local batch=dofile('tools/validation/blank-card-jera-batch.lua')
assert(next(registered)==nil and #events==0, 'loading must not run tests')
local function tick()
    frame=frame+1
    local hook=registered[1]
    if hook then
        assert(hook.fn(mod, player, 1, 99)==nil, 'unrelated input must pass through')
        local foreign={ToPlayer=function(self) return self end}
        assert(hook.fn(mod,foreign,1,5)==nil, 'other players must pass through')
        local value=hook.fn(mod,player,2,5)
        if allowInput and value and player.charge>0 then
            nativeUses=nativeUses+1
            local use=registered[2]
            assert(use and use.filter==286)
            assert(use.fn(mod,286,{},player,4,0,maxCharge)==nil)
            if player.card==2 then maxCharge=2 end
            player.charge=0
        end
    end
    if allowBattery then
        for _,pickup in ipairs(batteries) do
            if pickup.alive then pickup.alive=false; player.charge=maxCharge end
        end
    end
    if registered[3] then registered[3].fn(mod) end
end
local function run(mode)
    registered,events,batteries={}, {}, {}
    frame,nativeUses,maxCharge=0,0,4
    player.charge,player.card=4,33
    batch.Run(mode)
    for _=1,200 do tick(); if next(registered)==nil then break end end
    return batch.Status()
end
local result=run('smoke')
assert(result.status=='complete' and nativeUses==1 and player.charge==4)
assert(#batteries==1 and next(registered)==nil)
result=run('transitions')
assert(result.status=='complete' and nativeUses==3 and player.card==33)
assert(#batteries==3 and next(registered)==nil)
allowInput=false
result=run('smoke')
assert(result.status=='error' and result.message:find('exactly one Blank Card use'))
assert(next(registered)==nil)
allowInput,allowBattery=true,false
result=run('smoke')
assert(result.status=='error' and result.message:find('not collected'))
assert(not batteries[1].alive and next(registered)==nil, 'failed battery fixture must clean up')
registered,events,batteries={}, {}, {}
player.charge=4
batch.Run()
for _=1,25 do tick() end
batch.Stop()
assert(next(registered)==nil and not batteries[1].alive)
print('Blank Card batch protocol passed; native input and recharge still require engine verification')
