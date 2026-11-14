-- Spawn callback contracts. Native origin and successive generations require
-- the separate engine fixture; these Lua doubles are not engine evidence.
local callback, enabled, owners, draws = nil, true, {false}, 0
local rolls = {}
EntityType = {ENTITY_PICKUP = 5, ENTITY_BOMB = 4}
PickupVariant = {PICKUP_GRAB_BAG = 69, PICKUP_COIN = 20, PICKUP_KEY = 30,
    PICKUP_BOMB = 40, PICKUP_LIL_BATTERY = 90, PICKUP_TAROTCARD = 300}
BombVariant = {BOMB_TROLL = 3, BOMB_SUPERTROLL = 4, BOMB_GOLDENTROLL = 18}
ModCallbacks = {MC_PRE_ENTITY_SPAWN = 1}
local registrations = 0
package.loaded["Mods/Pool Rules/main"] = {Register = function(key, id, helper)
    assert(key == "sackHead" and id == 424 and helper == "OUP Sack Head Pool Entry")
    registrations = registrations + 1
end}
function RegisterMod()
    return {AddCallback = function(_, event, fn)
        assert(event == 1); assert(callback == nil); callback = fn
    end}
end
openUnnerfPack = {Config = {IsEnabled = function(key) assert(key == "sackHead"); return enabled end}}
function Game() return {GetNumPlayers = function() return #owners end} end
Isaac = {GetPlayer = function(index) return {HasCollectible = function(_, id)
    assert(id == 424); return owners[index + 1]
end} end}
function RNG()
    local seed
    return {SetSeed = function(_, value, shift)
        assert(value > 0 and shift == 35); seed = value
    end, RandomInt = function(_, maximum)
        assert(maximum == 100); draws = draws + 1; return assert(rolls[seed])
    end}
end
dofile("Mods/Sack Head Unnerf/main.lua")
assert(callback, "Sack Head must restore eligible sack-origin spawns")
assert(registrations == 1)
local sack = {Type = 5, Variant = 69, InitSeed = 1000}
local position, velocity = {}, {}
local function spawn(kind, variant, subtype, source, seed)
    return callback(nil, kind, variant, subtype, position, velocity, source, seed or 123)
end
local function converted(result, seed)
    assert(result and result[1] == 5 and result[2] == 69 and result[3] == 0 and result[4] == seed,
        "delegate native sack selection/payout while preserving the spawn seed")
end
owners, rolls[123] = {true}, 0
converted(spawn(5, 20, 0, sack), 123)
-- These expected counts come directly from issue #20, not the implementation.
for _, variant in ipairs({20, 30, 40, 90, 300}) do
    local successes = 0
    for roll = 0, 99 do
        rolls[123] = roll
        if spawn(5, variant, 0, sack) then successes = successes + 1 end
    end
    assert(successes == (variant == 20 and 10 or 20), "ordinary chance for variant " .. variant)
end
rolls[123] = 0
for _, variant in ipairs({3, 4, 18}) do converted(spawn(4, variant, 0, sack), 123) end
local before = draws
for _, source in ipairs({{Type = 1, Variant = 0}, {Type = 5, Variant = 50},
                         {Type = 3, Variant = 69}}) do
    assert(spawn(5, 20, 0, source) == nil, "unrelated source exclusion must remain native")
end
assert(spawn(5, 20, 0, nil) == nil)
for _, variant in ipairs({10, 50, 69, 70, 100, 350}) do
    assert(spawn(5, variant, 1, sack) == nil, "ineligible pickup variant")
end
assert(spawn(4, 0, 0, sack) == nil, "live attack bomb is not a troll reward")
assert(draws == before, "excluded sources/types consume no conversion RNG")
enabled = false
assert(spawn(5, 20, 0, sack) == nil and draws == before, "Off is native")
enabled, owners = true, {false}
assert(spawn(5, 20, 0, sack) == nil and draws == before, "without Sack Head is native")
owners = {false, true}
converted(spawn(5, 30, 0, sack), 123)
owners = {true, true}
rolls[123] = 15
before = draws
assert(spawn(5, 20, 0, sack) == nil and draws == before + 1,
    "multiple owners still give one 10% chance")
assert(spawn(5, 20, 0, sack) == nil, "revisiting an unchanged seed does not reroll it")
rolls[456], rolls[789] = 0, 0
converted(spawn(5, 30, 0, sack, 456), 456)
local childSack = {Type = 5, Variant = 69, InitSeed = 456}
converted(spawn(5, 90, 0, childSack, 789), 789)
assert(spawn(5, 30, 0, sack, 0) == nil, "invalid zero seed must not initialize native RNG")
print("Sack Head spawn contracts passed (Lua doubles; native chain validation pending)")
