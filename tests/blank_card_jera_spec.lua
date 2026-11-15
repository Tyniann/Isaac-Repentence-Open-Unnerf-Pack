-- Callback/configuration contract only; native charge/duplication use the ledger.
ModCallbacks = {MC_USE_ITEM=1}
CollectibleType = {COLLECTIBLE_BLANK_CARD=286}
Card = {RUNE_JERA=33}
UseFlag = {USE_MIMIC=128, USE_NOANNOUNCER=256}
local enabled, handler, registrations = true, nil, 0
openUnnerfPack = {Config={IsEnabled=function(key) assert(key=='blankCardJera'); return enabled end}}
function RegisterMod()
    return {AddCallback=function(_,id,fn,filter)
        assert(id==1 and filter==286)
        registrations=registrations+1; handler=fn
    end}
end
dofile('Mods/Blank Card Jera Unnerf/main.lua')
assert(registrations==1)
local function player(card,slot,charge)
    local p={card=card,slot=slot,item=286,charge=charge,calls={}}
    function p:GetCard(index) assert(index==0); return self.card end
    function p:GetActiveItem(index) assert(index==self.slot); return self.item end
    function p:GetActiveCharge(index) assert(index==self.slot); return self.charge end
    function p:UseCard(value,flags)
        assert(value==33 and flags==384)
        self.calls[#self.calls+1]='jera'
        if self.swapDuringEffect then self.item=105 end
    end
    function p:AddCollectible(id,value,first,index,varData)
        assert(self.calls[#self.calls]=='jera', 'cost changes only after native Jera dispatch')
        assert(id==286 and value==self.charge and first==false and index==self.slot and varData==4)
        self.calls[#self.calls+1]='next-cost-4'
    end
    return p
end
for slot=0,3 do
    for _,charge in ipairs({0,2,4}) do
        local p=player(33,slot,charge)
        assert(handler(nil,286,{},p,4,slot,0)==nil)
        assert(p.calls[1]=='jera' and p.calls[2]=='next-cost-4' and #p.calls==2)
        assert(p.charge==charge and p.card==33)
    end
end
enabled=false
assert(handler(nil,286,{},nil,4,0,0)==nil, 'disabled callback must not inspect or mutate player')
enabled=true
local other=player(2,0,2)
assert(handler(nil,286,{},other,4,0,0)==nil and #other.calls==0)
other=player(33,0,4); other.item=477
assert(handler(nil,286,{},other,64,0,0)==nil and #other.calls==0, 'Void/mimics must retain their active item')
other=player(33,0,4)
assert(handler(nil,286,{},other,0,-1,0)==nil and #other.calls==0)
other=player(33,0,4); other.swapDuringEffect=true
assert(handler(nil,286,{},other,4,0,0)==nil and #other.calls==1 and other.item==105)
local first,second=player(33,0,2),player(2,0,2)
handler(nil,286,{},first,4,0,0)
assert(#second.calls==0 and second.charge==2 and second.item==286)
print('Blank Card/Jera callback contracts passed; native gameplay validation remains separate')
