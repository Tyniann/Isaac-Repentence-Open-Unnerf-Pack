-- Contract regressions only: these doubles do not simulate Isaac's engine.
local dkjson = require("dkjson")
package.preload.json = function()
    return {encode = dkjson.encode, decode = function(value)
        local decoded, _, err = dkjson.decode(value)
        if err then error(err) end
        return decoded
    end}
end
local mods, callbacks = {}, {}
ModCallbacks = setmetatable({}, {__index = function(t, k) rawset(t, k, k); return k end})
local function enums(names)
    local result = {}
    for i, name in ipairs(names) do result[name] = i end
    return result
end
EntityType = {ENTITY_PLAYER=1, ENTITY_FAMILIAR=3, ENTITY_PICKUP=5, ENTITY_FIREPLACE=33}
CollectibleType = enums({'COLLECTIBLE_MAW_OF_THE_VOID','COLLECTIBLE_HUMBLEING_BUNDLE', 'COLLECTIBLE_PYROMANIAC','COLLECTIBLE_HOST_HAT'})
PickupVariant = enums({'PICKUP_HEART','PICKUP_COIN','PICKUP_KEY','PICKUP_BOMB'})
HeartSubType = enums({'HEART_FULL','HEART_DOUBLEPACK','HEART_SOUL'})
CoinSubType = enums({'COIN_PENNY','COIN_DOUBLEPACK'})
KeySubType = enums({'KEY_NORMAL','KEY_DOUBLEPACK'})
BombSubType = enums({'BOMB_NORMAL','BOMB_DOUBLEPACK'})
FamiliarVariant = enums({'RELIC','DARK_BUM','BLUE_FLY'})
PlayerType = enums({'PLAYER_THELOST','PLAYER_KEEPER','PLAYER_THELOST_B','PLAYER_KEEPER_B'})
CacheFlag = {CACHE_DAMAGE=1}
DamageFlag = {DAMAGE_EXPLOSION=4, DAMAGE_CRUSH=8}
Difficulty = {DIFFICULTY_HARD=1, DIFFICULTY_NORMAL=0}
local players, spawned = {}, 0
local game = {Difficulty=1, GetNumPlayers=function() return #players end,
    GetSeeds=function() return {GetStartSeed=function() return 12345 end} end}
function Game() return game end
Isaac = {GetPlayer=function(i) assert(i >= 0 and i < #players); return players[i+1] end,
    Spawn=function() spawned = spawned + 1 end}
function Vector(x,y) return {X=x,Y=y} end
function RegisterMod(name)
    local mod = {}
    mods[name] = mod
    function mod:HasData() return false end
    function mod:SaveData() end
    function mod:AddCallback(id, fn)
        callbacks[id] = callbacks[id] or {}
        table.insert(callbacks[id], {self,fn})
    end
    return mod
end
local function emit(id, ...)
    local value
    for _, cb in ipairs(callbacks[id] or {}) do
        local result = cb[2](cb[1], ...)
        if result ~= nil then value = result end
    end
    return value
end
local function player(count, bundle)
    local data = {}
    local p = {count=count, Damage=3.5, evaluations=0}
    function p:GetData() return data end
    function p:GetCollectibleNum() return self.count end
    function p:HasCollectible(item) return item == CollectibleType.COLLECTIBLE_HUMBLEING_BUNDLE and bundle end
    function p:AddCacheFlags(flag) assert(flag == CacheFlag.CACHE_DAMAGE) end
    function p:EvaluateItems()
        self.evaluations = self.evaluations + 1
        self.Damage = 3.5
        emit(ModCallbacks.MC_EVALUATE_CACHE, self, CacheFlag.CACHE_DAMAGE)
    end
    return p
end
dofile('main.lua')
players = {player(0,false)}
emit(ModCallbacks.MC_POST_GAME_STARTED, false)
for _, key in ipairs({"mawOfTheVoid", "orbitals", "stompImmunity", "humblingBundle", "darkBum", "relic", "blueFires"}) do
    assert(openUnnerfPack.Config.IsEnabled(key))
end
assert(not soulheartgeneratorUnnerf.enableNailUnnerf and not soulheartgeneratorUnnerf.enableSatanicBibleUnnerf)
-- Index zero, final player, absence, and pre-doubled pickups.
for _, ownership in ipairs({{true}, {false,true}, {true,false}}) do
    players = {}
    for _, owns in ipairs(ownership) do players[#players+1] = player(0,owns) end
    local selected = emit(ModCallbacks.MC_POST_PICKUP_SELECTION, {}, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY)
    assert(selected[2] == CoinSubType.COIN_DOUBLEPACK)
end
players = {player(0,false)}
assert(emit(ModCallbacks.MC_POST_PICKUP_SELECTION, {}, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY) == nil)
assert(emit(ModCallbacks.MC_POST_PICKUP_SELECTION, {}, PickupVariant.PICKUP_COIN, CoinSubType.COIN_DOUBLEPACK) == nil)
players = {player(0,true)}
for _, pair in ipairs({
    {PickupVariant.PICKUP_HEART,HeartSubType.HEART_FULL,HeartSubType.HEART_DOUBLEPACK},
    {PickupVariant.PICKUP_COIN,CoinSubType.COIN_PENNY,CoinSubType.COIN_DOUBLEPACK},
    {PickupVariant.PICKUP_KEY,KeySubType.KEY_NORMAL,KeySubType.KEY_DOUBLEPACK},
    {PickupVariant.PICKUP_BOMB,BombSubType.BOMB_NORMAL,BombSubType.BOMB_DOUBLEPACK}
}) do
    local selected=emit(ModCallbacks.MC_POST_PICKUP_SELECTION,{},pair[1],pair[2])
    assert(selected[1] == pair[1] and selected[2] == pair[3])
    assert(emit(ModCallbacks.MC_POST_PICKUP_SELECTION,{},pair[1],pair[3]) == nil)
end
-- Distinct players must not continually invalidate one another's damage cache.
local a,b = player(1),player(0)
for _=1,3 do emit(ModCallbacks.MC_POST_PEFFECT_UPDATE,a); emit(ModCallbacks.MC_POST_PEFFECT_UPDATE,b) end
assert(a.evaluations == 1 and b.evaluations == 1 and a.Damage == 4.5 and b.Damage == 3.5)
a.count=2; emit(ModCallbacks.MC_POST_PEFFECT_UPDATE,a); assert(a.Damage == 5.5)
a.count=0; emit(ModCallbacks.MC_POST_PEFFECT_UPDATE,a); assert(a.Damage == 3.5)
-- Registered damage callback must forward amount AND flags; type filter groups both variants.
local fire = {Type=33,Variant=2,Position=Vector(0,0),GetDropRNG=function() return {RandomFloat=function() return 0 end} end}
emit(ModCallbacks.MC_ENTITY_TAKE_DMG,fire,40,DamageFlag.DAMAGE_EXPLOSION); assert(spawned == 1)
fire.Variant=3; emit(ModCallbacks.MC_ENTITY_TAKE_DMG,fire,40,DamageFlag.DAMAGE_EXPLOSION); assert(spawned == 2)
fire.Type=10; emit(ModCallbacks.MC_ENTITY_TAKE_DMG,fire,40,DamageFlag.DAMAGE_EXPLOSION); assert(spawned == 2)
fire.Type=33; emit(ModCallbacks.MC_ENTITY_TAKE_DMG,fire,40,0); assert(spawned == 2)
game.Difficulty=0; emit(ModCallbacks.MC_ENTITY_TAKE_DMG,fire,40,DamageFlag.DAMAGE_EXPLOSION); assert(spawned == 2)
-- A missing familiar spawner must not dereference nil.
emit(ModCallbacks.MC_POST_PICKUP_INIT,{SpawnerType=3})
local familiar={Variant=FamiliarVariant.RELIC,RoomClearCount=0}
function familiar:ToFamiliar() return self end
emit(ModCallbacks.MC_FAMILIAR_UPDATE,setmetatable(familiar,{__index={OrbitDistance=Vector(0,0),GetData=function() return {} end}}))
assert(familiar.RoomClearCount == 2)
familiar.RoomClearCount=5
emit(ModCallbacks.MC_POST_PICKUP_INIT,{SpawnerType=3,SpawnerEntity=familiar})
assert(familiar.RoomClearCount == 2)
-- Orbital processing is idempotent across updates of the same entity.
local orbitalData={}
local orbital={Variant=100,OrbitDistance=Vector(40,40),Size=10,CollisionDamage=7,GetData=function() return orbitalData end}
emit(ModCallbacks.MC_FAMILIAR_UPDATE,orbital); emit(ModCallbacks.MC_FAMILIAR_UPDATE,orbital)
assert(orbital.Size == 13 and orbital.CollisionDamage == 14)
-- Dark Bum morphs only pickup rewards for eligible owners, not missing owners.
local bum={Variant=FamiliarVariant.DARK_BUM,Player={GetPlayerType=function() return 100 end}}
function bum:ToFamiliar() return self end
local morphs=0
local reward={SpawnerType=3,SpawnerEntity=bum,Variant=PickupVariant.PICKUP_COIN,SubType=CoinSubType.COIN_PENNY}
function reward:Morph(kind,variant,subtype)
    assert(kind == EntityType.ENTITY_PICKUP)
    morphs=morphs+1; self.Variant=variant; self.SubType=subtype
end
emit(ModCallbacks.MC_POST_PICKUP_INIT,reward); assert(morphs == 1 and reward.SubType == HeartSubType.HEART_SOUL)
emit(ModCallbacks.MC_POST_PICKUP_INIT,reward); assert(morphs == 1)
for _,excluded in pairs(PlayerType) do
    bum.Player.GetPlayerType=function() return excluded end
    reward.Variant=PickupVariant.PICKUP_COIN; reward.SubType=CoinSubType.COIN_PENNY
    emit(ModCallbacks.MC_POST_PICKUP_INIT,reward); assert(morphs == 1)
end
bum.Player=nil; emit(ModCallbacks.MC_POST_PICKUP_INIT,reward); assert(morphs == 1)
-- Preserve the existing Maw dark-ring selector and assignment.
local laser={SpawnerEntity={ToPlayer=function() return a end},GetSprite=function()
    return {GetFilename=function() return "gfx/007.001.003_Dark Ring.anm2" end}
end}
emit(ModCallbacks.MC_POST_LASER_UPDATE,laser); assert(laser.BlackHpDropChance == 0.05)
print('PASS: callback contract regressions (not engine/gameplay validation)')
