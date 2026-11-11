-- Safety checks for the disposable probe, not native Void behavior evidence.
local json = require("dkjson")
package.preload.json = function() return {encode = json.encode} end
ModCallbacks = {MC_PRE_USE_ITEM = 1, MC_USE_ITEM = 2, MC_POST_UPDATE = 3,
    MC_POST_NEW_ROOM = 4, MC_PRE_GAME_EXIT = 5}
CollectibleType = {COLLECTIBLE_VOID = 477, COLLECTIBLE_BOOK_OF_SHADOWS = 58,
    COLLECTIBLE_BOOK_OF_REVELATIONS = 78, COLLECTIBLE_CAR_BATTERY = 356}
ActiveSlot = {SLOT_PRIMARY = 0}
PickupVariant = {PICKUP_COLLECTIBLE = 100}
EntityType = {ENTITY_PICKUP = 5}
Difficulty = {DIFFICULTY_NORMAL = 0}
local callbacks, pickups, records = {}, {}, {}
local mod = {}
function RegisterMod() return mod end
function mod:AddCallback(id, fn) assert(not callbacks[id]); callbacks[id] = fn end
function mod:RemoveCallback(id, fn) assert(callbacks[id] == fn); callbacks[id] = nil end
local function position(x, y)
    return setmetatable({X = x, Y = y, Distance = function() return 200 end}, {
        __add = function(a, b) return position(a.X + b.X, a.Y + b.Y) end})
end
Vector = setmetatable({Zero = position(0, 0)}, {__call = function(_, x, y) return position(x, y) end})
local player = {Position = position(0, 0), charge = 0}
function player:GetPlayerType() return 0 end
function player:GetActiveCharge() return self.charge end
function player:GetActiveItem() return 477 end
function player:GetCollectibleNum() return 0 end
function player:GetSoulHearts() return 0 end
function player:GetEffects() return {GetCollectibleEffectNum = function() return 0 end} end
function player:HasCollectible() return false end
function player:SetActiveCharge(n) self.charge = n end
local room = {}
function room:GetType() return 1 end
function room:IsClear() return true end
function room:GetCenterPos() return position(0, 0) end
local level = {}
function level:GetCurrentRoomDesc() return {Data = {Variant = 0}, SpawnSeed = 10} end
function level:GetCurrentRoomIndex() return 1 end
function level:GetStage() return 1 end
local game = {Difficulty = 0}
function game:GetFrameCount() return 10 end
function game:GetSeeds() return {GetStartSeed = function() return 123 end} end
function game:GetLevel() return level end
function game:GetRoom() return room end
function game:GetNumPlayers() return 1 end
function Game() return game end
Isaac = {}
function Isaac.GetPlayer() return player end
function Isaac.GetRoomEntities() return pickups end
function Isaac.FindByType() return pickups end
function Isaac.DebugString(s) records[#records + 1] = s end
function Isaac.Spawn(_, variant, item)
    local p = {Variant = variant, SubType = item, InitSeed = #pickups + 1,
        Price = 0, FrameCount = 0, Touched = false, exists = true}
    function p:ToPickup() return self end
    function p:Exists() return self.exists end
    function p:Remove() self.exists = false end
    function p:GetSprite() return {GetAnimation = function() return "Idle" end} end
    pickups[#pickups + 1] = p
    return p
end

dofile("tools/validation/void-choice-probe.lua")
assert(#pickups == 0 and player.charge == 0, "loading must not mutate the run")
assert(not pcall(OUPVoidProbe.Start, "invalid", "test"))
assert(#pickups == 0, "invalid mode must fail before spawning")
OUPVoidProbe.Start("baseline", "baseline-safety")
assert(#pickups == 2 and pickups[1].OptionsPickupIndex == 916)
assert(not pcall(OUPVoidProbe.Start, "baseline", "duplicate"), "one fixture at a time")
callbacks[1](mod, 477, nil, player, 0, 0)
assert(pickups[1].OptionsPickupIndex == 916, "baseline leaves native grouping intact")
callbacks[3]()
OUPVoidProbe.Stop()
assert(not pickups[1]:Exists() and not pickups[2]:Exists())
assert(next(callbacks) == nil and OUPVoidProbe == nil, "Stop removes every registered callback")
pickups = {}
dofile("tools/validation/void-choice-probe.lua")
OUPVoidProbe.Start("detach", "detach-safety")
callbacks[1](mod, 58, nil, player, 64, 0)
assert(pickups[1].OptionsPickupIndex == 916, "stored actives do not unlink choices")
callbacks[1](mod, 477, nil, player, 0, 0)
assert(pickups[1].OptionsPickupIndex == 0 and pickups[2].OptionsPickupIndex == 0)
pickups[1]:Remove() -- Simulated native consumption: no resurrection or rewards.
callbacks[3]()
assert(pickups[2].OptionsPickupIndex == 916, "surviving choices restored at next update")
assert(not pickups[1]:Exists(), "removed pedestal stays removed")
callbacks[1](mod, 477, nil, player, 0, 0)
assert(pickups[2].OptionsPickupIndex == 0)
callbacks[5]()
assert(pickups[2].OptionsPickupIndex == 916, "exit restores survivors before saving")
OUPVoidProbe.Stop()
assert(next(callbacks) == nil)
print("Void probe safety checks passed; native callback timing and absorption remain untested")
