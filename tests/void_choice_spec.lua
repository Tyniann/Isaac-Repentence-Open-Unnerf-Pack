-- Contract checks at the real callback seam. Native rewards need engine tests.
ModCallbacks = {MC_PRE_USE_ITEM = 1, MC_POST_UPDATE = 2, MC_POST_NEW_ROOM = 3, MC_PRE_GAME_EXIT = 4}
CollectibleType = {COLLECTIBLE_VOID = 477}
EntityType = {ENTITY_PICKUP = 5}
PickupVariant = {PICKUP_COLLECTIBLE = 100}
GridRooms = {ROOM_GENESIS_IDX = -12}
local callbacks, listener, mod = {}, nil, nil
function RegisterMod()
    mod = {}
    function mod:AddCallback(id, fn, filter) callbacks[id] = {fn = fn, filter = filter} end
    return mod
end
local enabled, fixtures, roomIndex, inCertificate, pointerCalls
local current = {SafeGridIndex = 84, ptr = 1, Data = {}}
local function reset()
    enabled, fixtures, roomIndex, inCertificate, pointerCalls = true, {}, 84, false, 0
    current.SafeGridIndex = 84
end
local level = {}
function level:GetCurrentRoomIndex() return roomIndex end
function level:GetCurrentRoomDesc() return current end
function level:GetRoomByIdx(index, dimension)
    assert(index == current.SafeGridIndex and dimension == 2)
    return inCertificate and {Data = {}, ptr = 1} or {Data = nil, ptr = 0}
end
function GetPtrHash(desc) pointerCalls = pointerCalls + 1; return desc.ptr end
function Game() return {GetLevel = function() return level end} end
Isaac = {FindByType = function(...) return fixtures end}
openUnnerfPack = {Config = {
    IsEnabled = function(key) assert(key == "voidChoiceAbsorption"); return enabled end,
    AddRunStartListener = function(fn) listener = fn end}}
local function pickup(item, index, price, touched)
    local p = {InitSeed = #fixtures + 1, SubType = item, OptionsPickupIndex = index,
        Price = price or 0, Touched = touched or false, exists = true}
    function p:Exists() return self.exists end
    function p:ToPickup() return self end
    fixtures[#fixtures + 1] = p
    return p
end
reset()
dofile("Mods/Void Choice Unnerf/main.lua")
assert(callbacks[1].filter == 477, "only native Void triggers the pre-use callback")
local function absorb() assert(mod:preUseItem(477) == nil, "never override native result") end
local count = 0
local function test(name, fn)
    mod:restoreChoices(); reset(); fn(); count = count + 1; print("ok " .. count .. " - " .. name)
end
test("independent groups and unlinked controls", function()
    local a,b,c,d = pickup(58, 10),pickup(78, 10),pickup(1, 20),pickup(2, 20)
    local unlinked, singleton = pickup(3, 0), pickup(4, 30)
    absorb()
    assert(a.OptionsPickupIndex == 10 and b.OptionsPickupIndex == 0)
    assert(c.OptionsPickupIndex == 20 and d.OptionsPickupIndex == 0)
    assert(unlinked.OptionsPickupIndex == 0 and singleton.OptionsPickupIndex == 30)
    callbacks[2].fn(mod)
    assert(a.OptionsPickupIndex == 10 and b.OptionsPickupIndex == 10
        and c.OptionsPickupIndex == 20 and d.OptionsPickupIndex == 20)
end)
test("Off and unrelated item uses are complete no-ops", function()
    local a,b = pickup(58, 10),pickup(78, 10)
    enabled = false; absorb(); assert(a.OptionsPickupIndex == 10)
    enabled = true; mod:preUseItem(58); assert(b.OptionsPickupIndex == 10)
end)
test("paid, touched, empty and removed pedestals remain native", function()
    local a,b = pickup(58, 10),pickup(78, 10)
    local coin, devil, touched, empty, dead = pickup(3,10,15),pickup(4,10,-1),
        pickup(5,10,0,true),pickup(0,10),pickup(6,10)
    dead.exists = false
    absorb(); assert(a.OptionsPickupIndex == 10 and b.OptionsPickupIndex == 0)
    for _, p in ipairs({coin,devil,touched,empty,dead}) do assert(p.OptionsPickupIndex == 10) end
end)
test("one free option plus a paid alternative keeps native links", function()
    local free, paid = pickup(58,10),pickup(78,10,15)
    absorb(); assert(free.OptionsPickupIndex == 10 and paid.OptionsPickupIndex == 10)
end)
test("Genesis and Death Certificate are excluded", function()
    local a,b = pickup(58,10),pickup(78,10)
    roomIndex = -12; absorb(); assert(a.OptionsPickupIndex == 10 and pointerCalls == 0)
    roomIndex, inCertificate = 84, true
    absorb(); assert(b.OptionsPickupIndex == 10 and pointerCalls == 2)
end)
test("off-grid descriptor aliases are not Death Certificate", function()
    local a,b = pickup(58,1),pickup(78,1)
    -- Native goto rooms use -3; their off-grid descriptor can alias in every
    -- dimension. The real Death Certificate selection lives on the grid.
    roomIndex, current.SafeGridIndex, inCertificate = -3, -3, true
    absorb()
    assert(a.OptionsPickupIndex == 1 and b.OptionsPickupIndex == 0,
        "off-grid choices were misclassified as Death Certificate")
end)
test("restoration never resurrects, rewrites a morph or replaces another mod's group", function()
    local a,b,c,d = pickup(58,10),pickup(78,10),pickup(1,10),pickup(2,10)
    absorb(); a.exists = false; b.SubType = 3; c.OptionsPickupIndex = 44; d.InitSeed = 99
    mod:restoreChoices()
    assert(not a.exists and b.OptionsPickupIndex == 0 and c.OptionsPickupIndex == 44 and d.OptionsPickupIndex == 0)
end)
test("repeated calls before deferred cleanup preserve one transaction", function()
    local a,b = pickup(58,10),pickup(78,10)
    absorb(); absorb(); assert(a.OptionsPickupIndex == 10 and b.OptionsPickupIndex == 0)
    mod:restoreChoices(); assert(a.OptionsPickupIndex == 10 and b.OptionsPickupIndex == 10)
    -- No leftovers can affect a later ordinary manual pickup.
    a.OptionsPickupIndex = 12; mod:restoreChoices(); assert(a.OptionsPickupIndex == 12)
end)
test("room change, exit and run start all restore surviving links", function()
    for _, finish in ipairs({function() callbacks[3].fn(mod) end,
        function() callbacks[4].fn(mod) end, function() listener(false) end,
        function() listener(true) end}) do
        local a,b = pickup(58,10),pickup(78,10)
        absorb(); finish(); assert(a.OptionsPickupIndex == 10 and b.OptionsPickupIndex == 10)
        fixtures = {}
    end
end)
test("ordinary angel/devil and Boss Rush off-grid indices are not excluded", function()
    local a,b = pickup(58,10),pickup(78,10)
    roomIndex = -1; absorb(); assert(a.OptionsPickupIndex == 10 and b.OptionsPickupIndex == 0); mod:restoreChoices()
    roomIndex = -5; absorb(); assert(b.OptionsPickupIndex == 0)
end)
test("empty room is harmless", function() absorb(); mod:restoreChoices() end)
print(count .. " Void callback contract checks passed; native reward tests remain separate")
