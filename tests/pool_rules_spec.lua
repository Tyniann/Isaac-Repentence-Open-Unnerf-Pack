-- Pool-rule/config callback contracts only. Native pool selection is tested in Isaac.
local callbacks, listeners, removed, enabled, owned = {}, {}, {}, true, false
ModCallbacks = {MC_POST_GET_COLLECTIBLE = 63, MC_POST_PEFFECT_UPDATE = 31,
    MC_POST_PICKUP_INIT = 34}
PickupVariant = {PICKUP_COLLECTIBLE = 100}
EntityType = {ENTITY_PICKUP = 5}
Isaac = {GetItemConfig = function() return {GetCollectible = function()
    return {Quality = 4, Tags = 7, Type = 1}
end} end, GetItemIdByName = function(name)
    assert(name == "OUP Magic Mushroom Pool Entry"); return 1001
end}
local pool = {RemoveCollectible = function(_, id) removed[#removed + 1] = id end}
local helperCopies = 0
local player = {HasCollectible = function(_, id, ignoreModifiers)
    assert(ignoreModifiers == true, "ignore temporary wisps/modifiers")
    return (owned and id == 12) or (id == 1001 and helperCopies > 0)
end}
function player:GetCollectibleNum(id) assert(id == 1001); return helperCopies end
function player:RemoveCollectible(id) assert(id == 1001); helperCopies = helperCopies - 1 end
function player:AddCollectible(id) assert(id == 12); owned = true end
Game = function() return {GetItemPool = function() return pool end,
    GetNumPlayers = function() return 1 end} end
Isaac.GetPlayer = function() return player end
RegisterMod = function()
    return {AddCallback = function(_, id, fn) callbacks[id] = fn end}
end
openUnnerfPack = {Config = {
    IsEnabled = function(key) assert(key == "magicMushroom"); return enabled end,
    AddRunStartListener = function(fn) listeners[#listeners + 1] = fn end,
}}
local rules = require("Mods/Pool Rules/main")
rules.Register("magicMushroom", 12, "OUP Magic Mushroom Pool Entry")
assert(#listeners == 1)
listeners[1](false)
assert(#removed == 1 and removed[1] == 12, "On excludes original, leaves helper to native picker")
assert(callbacks[63](nil, 1001, 1, true, 123) == 12)
assert(callbacks[63](nil, 23, 1, true, 123) == nil, "unrelated output untouched")
listeners[1](true)
assert(#removed == 2 and removed[2] == 12, "Continue never inserts or resets entries")
enabled = false
listeners[1](false)
assert(removed[#removed] == 1001, "Off excludes only private helper")
-- Existing run choices come from Config.IsEnabled, not the next-run menu value.
enabled = true
owned = true
callbacks[31](nil, player)
assert(removed[#removed] == 1001, "real pickup excludes the helper identity")
local count = #removed
callbacks[31](nil, player)
assert(#removed == count, "collection exclusion is idempotent")
local pickup = {SubType = 1001, Variant = 100}
function pickup:Morph(t, v, id, keepPrice, keepSeed, ignoreModifiers)
    assert(t == 5 and v == 100 and id == 12 and keepPrice and keepSeed and ignoreModifiers)
    self.SubType = id
end
callbacks[34](nil, pickup)
assert(pickup.SubType == 12, "defensive mapping for scripted helper pedestals")
owned, helperCopies = false, 1
callbacks[31](nil, player)
assert(owned and helperCopies == 0, "inventory rerolls cannot leave helper copies")
helperCopies = 1
callbacks[31](nil, player)
assert(owned and helperCopies == 0, "helper plus real item does not grant a duplicate")
print("pool rule contracts passed (Lua doubles; engine validation pending)")
