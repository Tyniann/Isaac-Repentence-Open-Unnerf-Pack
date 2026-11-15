-- Callback/state contract only; native charge and duplication use the ledger.
ModCallbacks = {MC_USE_ITEM=1,MC_POST_PLAYER_UPDATE=2,MC_PRE_GAME_EXIT=3}
CollectibleType = {COLLECTIBLE_BLANK_CARD=286}
Card = {RUNE_JERA=33}
UseFlag = {USE_MIMIC=128,USE_NOANNOUNCER=256,USE_CARBATTERY=32}
GetPtrHash = function(value) return value end
local enabled, runStart = true, nil
local handlers = {}
openUnnerfPack = {Config={
    IsEnabled=function(key) assert(key=='blankCardJera');return enabled end,
    AddRunStartListener=function(fn) runStart=fn end}}
function RegisterMod()
    return {AddCallback=function(_,id,fn,filter)
        assert((id==1 and filter==286) or (id~=1 and filter==nil))
        assert(not handlers[id]);handlers[id]=fn
    end}
end
dofile('Mods/Blank Card Jera Unnerf/main.lua')
assert(handlers[1] and handlers[2] and handlers[3] and runStart)
local serial=0
local function player(card,slot,charge,battery)
    serial=serial+1
    local p={InitSeed=serial,card=card,slot=slot,item=286,charge=charge,battery=battery or 0,calls={}}
    function p:GetCard(index) assert(index==0);return self.card end
    function p:GetActiveItem(index) assert(index==self.slot);return self.item end
    function p:GetActiveCharge(index) assert(index==self.slot);return self.charge end
    function p:GetBatteryCharge(index) assert(index==self.slot);return self.battery end
    function p:UseCard(value,flags)
        assert(value==33 and flags==384)
        self.calls[#self.calls+1]='jera'
        if self.swapDuringEffect then self.item=105 end
    end
    function p:AddCollectible(id,value,first,index,varData)
        assert(self.calls[1]=='jera' and self.battery==0)
        assert(id==286 and value==self.charge and first==false and index==self.slot and varData==4)
        self.calls[#self.calls+1]='next-cost-4'
    end
    return p
end
local function use(p) return handlers[1](nil,286,{},p,4,p.slot,0) end
local function replay(p) return handlers[1](nil,286,{},p,1569,-1,2) end
local function update(p) return handlers[2](nil,p) end
for slot=0,3 do
    for _,charge in ipairs({0,2,4,6}) do
        local p=player(33,slot,charge)
        assert(use(p)==nil and #p.calls==1)
        assert(p.charge==charge and p.card==33)
        p.charge=0 -- Native discharge, outside the product callback.
        update(p)
        assert(#p.calls==(charge==4 and 1 or 2))
        assert(p.charge==0)
        update(p)
        assert(#p.calls==(charge==4 and 1 or 2), 'apply at most once')
    end
end
local p=player(33,0,4,4)
use(p);update(p)
assert(p.charge==4 and p.battery==4 and #p.calls==1)
p.battery=0 -- Engine spends one bar, leaving the other four charges.
update(p)
assert(p.charge==4 and #p.calls==1)
p=player(33,0,2,2)
use(p);update(p)
assert(#p.calls==1 and p.battery==2)
p.battery=0 -- Engine spends two and retains two in the normal bar.
update(p)
assert(#p.calls==2 and p.charge==2)
for slot=0,3 do
    for _,charge in ipairs({2,4}) do
        p=player(33,slot,charge)
        use(p)
        replay(p) -- J460's observed no-slot replay, before one discharge.
        assert(#p.calls==2 and p.charge==charge)
        replay(p)
        assert(#p.calls==2, 'accept only one native replay for the owned use')
        p.charge=0
        update(p)
        local expected=charge==2 and 3 or 2
        assert(#p.calls==expected, 'two effects retain one primary cost update')
        update(p);replay(p)
        assert(#p.calls==expected, 'do not replay a completed player update')
    end
end
p=player(33,0,2);replay(p);assert(#p.calls==0,'unpaired no-slot calls remain ignored')
p=player(33,0,2);use(p)
assert(handlers[1](nil,286,{},p,128,-1,0)==nil and #p.calls==1,'mimic flag is not Car Battery')
replay(p);assert(#p.calls==2)
enabled=false
assert(handlers[1](nil,286,{},nil,4,0,0)==nil)
enabled=true
p=player(2,0,2);use(p);update(p);assert(#p.calls==0)
p=player(33,0,4);p.item=477;use(p);update(p);assert(#p.calls==0)
p=player(33,0,4)
assert(handlers[1](nil,286,{},p,0,-1,0)==nil and #p.calls==0)
p=player(33,0,2);p.swapDuringEffect=true;use(p);update(p)
assert(#p.calls==1 and p.item==105)
p=player(33,0,2);use(p);p.item=105;replay(p);update(p);assert(#p.calls==1)
p=player(33,0,2);use(p);p.card=2;use(p);replay(p);update(p);assert(#p.calls==1,'later card use cancels pending cost/replay')
p=player(33,0,2);use(p);p.InitSeed=p.InitSeed+100;replay(p);update(p);assert(#p.calls==1)
p=player(33,0,2);use(p);runStart();replay(p);update(p);assert(#p.calls==1)
p=player(33,0,2);use(p);handlers[3]();replay(p);update(p);assert(#p.calls==1)
local first,second=player(33,0,2),player(33,0,2)
use(first);replay(second);update(second);assert(#second.calls==0)
update(first);assert(#first.calls==2)
print('Blank Card/Jera contracts passed: native timing, reserve protection, slot/player isolation and pending-state cleanup')
