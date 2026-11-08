-- Run from the repository root: lua tests/stomp_immunity_test.lua
-- Exercises the registered damage callback, not a copy of its implementation.
-- Recorded Mom-foot sequence: Repentance+ 1.9.7.17.J460, seed YXZ9 KTZH,
-- frame 142, source 45.10.0, Stomp frames 27/28: DAMAGE_CRUSH then flags=0.
DamageFlag = {DAMAGE_CRUSH = 1 << 24, DAMAGE_FAKE = 1 << 21}
EntityType = {ENTITY_PLAYER = 1, ENTITY_MOM = 45}
CollectibleType = {COLLECTIBLE_PYROMANIAC = 223, COLLECTIBLE_HOST_HAT = 375}
ModCallbacks = {MC_ENTITY_TAKE_DMG = 11}
local enabled = true
openUnnerfPack = {Config = {IsEnabled = function(key)
    assert(key == "stompImmunity")
    return enabled
end}}

local callback
function RegisterMod()
    return {AddCallback = function(self, id, fn)
        assert(id == ModCallbacks.MC_ENTITY_TAKE_DMG)
        callback = function(...) return fn(self, ...) end
    end}
end
dofile("Mods/Stomp Immunity Unnerf/main.lua")
assert(callback, "Stomp immunity callback was not registered")

local function player(items, hearts)
    local data = {}
    return {
        Type = EntityType.ENTITY_PLAYER,
        hearts = hearts or 6,
        ToPlayer = function(self) return self end,
        HasCollectible = function(_, id) return items[id] == true end,
        AddHearts = function(self, amount) self.hearts = self.hearts + amount end,
        GetData = function() return data end,
    }
end

local function source(kind, variant, animation, seed)
    return {Entity = {
        Type = kind or EntityType.ENTITY_MOM,
        Variant = variant or 10,
        InitSeed = seed or 100,
        GetSprite = function()
            return {IsPlaying = function(_, name) return name == (animation or "Stomp") end}
        end,
    }}
end

local function equal(actual, expected)
    assert(actual == expected, "expected " .. tostring(expected) .. ", got " .. tostring(actual))
end

-- Apply each callback verdict as observed in the engine trace. This verifies
-- cancellation and healing at the mod interface; in-game replay is still needed.
local function hit(target, flags, damageSource)
    local result = callback(target, 2, flags, damageSource, 30)
    if result ~= false then target.hearts = target.hearts - 2 end
    return result
end

local failures = 0
local tests = 0
local function test(name, run)
    if arg[1] and not name:find(arg[1], 1, true) then return end
    tests = tests + 1
    enabled = true
    local ok, err = pcall(run)
    if not ok then failures = failures + 1 end
    print((ok and "PASS " or "FAIL ") .. name .. (ok and "" or ": " .. err))
end

test("Host Hat cancels both recorded Mom-foot events", function()
    local target = player({[375] = true})
    local foot = source()
    equal(hit(target, DamageFlag.DAMAGE_CRUSH, foot), false)
    equal(hit(target, 0, foot), false)
    equal(target.hearts, 6)
end)

test("Pyromaniac heals one full red heart for the recorded pair", function()
    local target = player({[223] = true}, 2)
    local foot = source()
    equal(hit(target, DamageFlag.DAMAGE_CRUSH, foot), false)
    equal(hit(target, 0, foot), false)
    equal(target.hearts, 4)
end)

test("unflagged foot contact is blocked without granting impact healing", function()
    local target = player({[223] = true}, 2)
    equal(hit(target, 0, source()), false)
    equal(target.hearts, 2)
end)

test("continued foot contact does not repeatedly heal Pyromaniac", function()
    local target = player({[223] = true}, 2)
    local foot = source()
    hit(target, DamageFlag.DAMAGE_CRUSH, foot)
    for _ = 1, 5 do
        equal(hit(target, 0, foot), false)
    end
    equal(target.hearts, 4)
end)

test("a later Mom stomp heals again", function()
    local target = player({[223] = true}, 2)
    local foot = source()
    hit(target, DamageFlag.DAMAGE_CRUSH, foot)
    hit(target, 0, foot)
    hit(target, DamageFlag.DAMAGE_CRUSH, foot)
    hit(target, 0, foot)
    equal(target.hearts, 6)
end)

test("an unprotected player still takes Mom stomp damage", function()
    local target = player({})
    equal(callback(target, 2, DamageFlag.DAMAGE_CRUSH, source(), 30), nil)
    equal(hit(target, 0, source()), nil)
    equal(target.hearts, 4)
end)

for _, item in ipairs({223, 375}) do
    test("disabled stomp immunity allows damage with item " .. item, function()
        enabled = false
        local target = player({[item] = true})
        equal(hit(target, DamageFlag.DAMAGE_CRUSH, source()), nil)
        equal(hit(target, 0, source()), nil)
        equal(target.hearts, 2)
    end)
    test("ordinary enemy contact still damages with item " .. item, function()
        local target = player({[item] = true})
        -- Even in the same frame as a protected stomp, another enemy can hurt.
        hit(target, DamageFlag.DAMAGE_CRUSH, source())
        local before = target.hearts
        equal(hit(target, 0, source(10, 0, "Walk")), nil)
        equal(target.hearts, before - 2)
    end)
    test("Mom's door attacks still damage with item " .. item, function()
        local target = player({[item] = true})
        equal(hit(target, 0, source(45, 0, "Stomp")), nil)
        equal(target.hearts, 4)
    end)
    test("a foot outside its Stomp animation still damages with item " .. item, function()
        local target = player({[item] = true})
        equal(hit(target, 0, source(45, 10, "Idle")), nil)
        equal(target.hearts, 4)
    end)
    test("special flagged damage is not mistaken for foot contact with item " .. item, function()
        local target = player({[item] = true})
        equal(hit(target, DamageFlag.DAMAGE_FAKE, source()), nil)
        equal(target.hearts, 4)
    end)
    test("crush protection still works without a source entity with item " .. item, function()
        local target = player({[item] = true}, 2)
        equal(hit(target, DamageFlag.DAMAGE_CRUSH, {}), false)
        equal(target.hearts, item == 223 and 4 or 2)
    end)
end

test("healing is independent for each player", function()
    local foot = source()
    local first = player({[223] = true}, 2)
    local second = player({[223] = true}, 2)
    hit(first, DamageFlag.DAMAGE_CRUSH, foot)
    hit(second, DamageFlag.DAMAGE_CRUSH, foot)
    hit(first, 0, foot)
    hit(second, 0, foot)
    equal(first.hearts, 4)
    equal(second.hearts, 4)
end)

test("both items together still heal only once for the pair", function()
    local target = player({[223] = true, [375] = true}, 2)
    local foot = source()
    hit(target, DamageFlag.DAMAGE_CRUSH, foot)
    hit(target, 0, foot)
    equal(target.hearts, 4)
end)

test("non-player damage is not cancelled", function()
    equal(callback({Type = 10}, 2, DamageFlag.DAMAGE_CRUSH, source(), 30), nil)
end)

assert(tests > 0, "No tests matched the supplied filter")
print(string.format("%d/%d passed", tests - failures, tests))
os.exit(failures == 0 and 0 or 1)
