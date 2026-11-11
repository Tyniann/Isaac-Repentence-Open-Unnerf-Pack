-- Contract tests for pack configuration and callback isolation, not engine tests.
local dkjson = require("dkjson")
package.preload.json = function()
    return {encode = dkjson.encode, decode = function(value)
        local decoded, _, err = dkjson.decode(value)
        if err then error(err) end
        return decoded
    end}
end
-- Optional pinned upstream source: exercise its real menu registration helpers.
local upstreamAPI
if arg[1] then
    local file = assert(io.open(arg[1]))
    local source = file:read("*a"); file:close()
    assert(source:find("local VERSION = 113", 1, true), "expected MCM Pure v113")
    local first = assert(source:find("ModConfigMenu.OptionType =", 1, true))
    local last = assert(source:find("function ModConfigMenu.AddTitle", first, true))
    upstreamAPI = source:sub(first, last - 1)
end
local ids = 0
local function enum()
    return setmetatable({}, {__index = function(t, k)
        ids = ids + 1; rawset(t, k, ids); return ids
    end})
end
for _, name in ipairs({"ModCallbacks", "CacheFlag", "FamiliarVariant", "PlayerType",
    "CollectibleType", "EntityType", "PickupVariant", "HeartSubType", "CoinSubType",
    "KeySubType", "BombSubType", "Difficulty", "DamageFlag"}) do _G[name] = enum() end
local storage, mods, menu, seed, player, excluded
local game = {Difficulty = Difficulty.DIFFICULTY_HARD}
local gameFrame = 0
function game:GetFrameCount() return gameFrame end
function game:GetItemPool() return {RemoveCollectible = function(_, id) excluded[id] = true end} end
function game:GetSeeds() return {GetStartSeed = function() return seed end} end
function game:GetNumPlayers() return 1 end
function game:GetPlayer() return player end
function Game() return game end
Isaac = {GetPlayer = function() return player end, GetItemIdByName = function() return 1001 end,
    GetItemConfig = function() return {GetCollectible = function() return {Quality = 4, Tags = 7, Type = 1} end} end}
function RegisterMod(name)
    local mod = {callbacks = {}}
    function mod:AddCallback(id, fn) self.callbacks[id] = fn end
    function mod:HasData() return storage ~= nil end
    function mod:LoadData() return storage end
    function mod:SaveData(value) storage = value end
    mods[name] = mod
    return mod
end
local function boot(data, withMenu)
    storage, mods, menu, seed, excluded = data, {}, {}, 12345, {}
    player = {Damage = 3.5, AddCacheFlags = function() end, EvaluateItems = function() end,
        HasCollectible = function() return false end}
    ModConfigMenu = withMenu and {
        OptionType = {BOOLEAN = 1}, AddText = function() end,
        AddSetting = function(category, tab, setting)
            assert(category == "Open Unnerf Pack 2" and tab == "Unnerfs")
            assert(setting.Type == 1)
            menu[#menu + 1] = setting
        end,
    } or nil
    if withMenu and upstreamAPI then
        ModConfigMenu = {}
        assert(load(upstreamAPI, "MCM Pure v113 registration API"))()
        local addSetting = ModConfigMenu.AddSetting
        ModConfigMenu.AddSetting = function(category, tab, setting)
            local result = addSetting(category, tab, setting)
            if setting.Type == ModConfigMenu.OptionType.BOOLEAN then menu[#menu + 1] = setting end
            return result
        end
    end
    for key in pairs(package.loaded) do
        if key == "config" or key:match("^Mods/") then package.loaded[key] = nil end
    end
    dofile("main.lua")
end
local keys = {"mawOfTheVoid", "orbitals", "stompImmunity", "humblingBundle", "darkBum", "relic", "blueFires", "magicMushroom"}
local function start(continued)
    if not continued then excluded = {} end -- Isaac creates fresh native pools.
    openUnnerfPack.callbacks[ModCallbacks.MC_POST_GAME_STARTED](openUnnerfPack, continued)
end
local function checkDefaults()
    for _, key in ipairs(keys) do assert(openUnnerfPack.Config.IsEnabled(key), key) end
end
local count = 0
local function test(name, fn)
    fn(); count = count + 1; print("ok " .. count .. " - " .. name)
end

test("renamed display preserves registered identity and saved Continue choices", function()
    local data = '{"version":1,"settings":{"orbitals":false},' ..
        '"run":{"seed":12345,"settings":{"orbitals":false,"relic":false}}}'
    boot(data, true)
    assert(mods["Open Unnerf Pack"] == openUnnerfPack)
    assert(mods["Open Unnerf Pack 2"] == nil)
    start(true)
    assert(not openUnnerfPack.Config.IsEnabled("orbitals"))
    assert(not openUnnerfPack.Config.IsEnabled("relic"))
    local saved = dkjson.decode(storage)
    assert(saved.version == 1)
    assert(saved.settings.orbitals == false)
    assert(saved.run.settings.orbitals == false and saved.run.settings.relic == false)
    if upstreamAPI then
        local category = ModConfigMenu.GetCategoryIDByName("Open Unnerf Pack 2")
        assert(category and ModConfigMenu.MenuData[category].Name == "Open Unnerf Pack 2")
        assert(ModConfigMenu.GetCategoryIDByName("Open Unnerf Pack") == nil)
        assert(#ModConfigMenu.MenuData == 1)
    end
end)

test("early pool generation reads choices for fresh runs and snapshots for Continue", function()
    local data = '{"version":1,"settings":{"magicMushroom":false},"run":{"seed":12345,"settings":{"magicMushroom":true}}}'
    boot(data, true)
    gameFrame = 0
    assert(not openUnnerfPack.Config.IsEnabledForPoolGeneration("magicMushroom"), "same seed fresh uses choices")
    assert(storage == data, "preview never writes save data")
    gameFrame = 321
    assert(openUnnerfPack.Config.IsEnabledForPoolGeneration("magicMushroom"), "Continue uses snapshot")
    storage = '{"version":1,"settings":{"magicMushroom":true},"run":{"seed":67890,"settings":{"magicMushroom":false}}}'
    seed = 67890
    assert(not openUnnerfPack.Config.IsEnabledForPoolGeneration("magicMushroom"), "reload selected slot")
    gameFrame = 0
end)

test("absent MCM, first install defaults, exit and reload", function()
    boot(nil, false); start(false); checkDefaults()
    openUnnerfPack.callbacks[ModCallbacks.MC_PRE_GAME_EXIT]()
    boot(storage, false); start(true); checkDefaults()
end)
test("malformed, wrong schema and invalid fields fall back safely", function()
    for _, data in ipairs({"broken{", "null", "false", "[]", '{"version":2,"settings":{"orbitals":false}}',
        '{"version":1,"settings":{"orbitals":"false","relic":0},"run":false}'}) do
        boot(data, true); start(false); checkDefaults()
    end
    boot('{"version":1,"settings":{"orbitals":false,"relic":"false"}}', true)
    start(false); assert(not openUnnerfPack.Config.IsEnabled("orbitals"))
    assert(openUnnerfPack.Config.IsEnabled("relic"))
end)
test("menu has exactly eight independent booleans; changes save immediately, defer to new run", function()
    boot(nil, true); start(false); assert(#menu == 8)
    for i, key in ipairs(keys) do
        assert(menu[i].CurrentSetting() == true)
        menu[i].OnChange(false)
        assert(menu[i].CurrentSetting() == false)
        assert(menu[i].Display():match("Off$"))
        assert(openUnnerfPack.Config.IsEnabled(key))
        local saved = dkjson.decode(storage)
        assert(saved.settings[key] == false and saved.run.settings[key] == true)
    end
    local saved = storage
    boot(saved, false); start(true); checkDefaults()
    start(false)
    for _, key in ipairs(keys) do assert(not openUnnerfPack.Config.IsEnabled(key)) end
end)
test("late MCM initialization registers once and reflects persisted choices", function()
    boot('{"version":1,"settings":{"relic":false}}', false)
    ModConfigMenu = {OptionType = {BOOLEAN = 1}, AddText = function() end,
        AddSetting = function(_, _, setting) menu[#menu + 1] = setting end}
    start(false); start(false)
    assert(#menu == 8 and menu[6].CurrentSetting() == false)
end)
test("continue with no matching snapshot uses saved choices", function()
    boot('{"version":1,"settings":{"relic":false},"run":{"seed":999,"settings":{"relic":true}}}', false)
    start(true); assert(not openUnnerfPack.Config.IsEnabled("relic"))
end)

test("save-slot switches reload choices and Continue snapshots without reloading Lua", function()
    for _, withMenu in ipairs({false, true}) do
        for _, nextSeed in ipairs({12345, 67890}) do
            boot(nil, withMenu); start(false)
            local slotA = storage
            -- Select slot B while the same Lua callbacks/menu closures remain alive.
            seed = nextSeed
            storage = dkjson.encode({version = 1, settings = {orbitals = false},
                run = {seed = nextSeed, settings = {orbitals = false, relic = false}}})
            start(true)
            assert(not openUnnerfPack.Config.IsEnabled("orbitals"), "slot B active")
            assert(not openUnnerfPack.Config.IsEnabled("relic"), "slot B snapshot")
            assert(dkjson.decode(storage).settings.orbitals == false, "slot B choices")
            if withMenu then assert(menu[2].CurrentSetting() == false, "slot B menu") end
            local slotB = storage
            storage, seed = slotA, 12345
            start(true)
            assert(openUnnerfPack.Config.IsEnabled("orbitals"), "slot A active")
            if withMenu then assert(menu[2].CurrentSetting() == true, "slot A menu") end
            storage, seed = slotB, nextSeed
            start(false)
            assert(not openUnnerfPack.Config.IsEnabled("orbitals"), "slot B new run")
            assert(openUnnerfPack.Config.IsEnabled("relic"), "slot B new choices")
            -- A previously unused slot must not inherit the preceding slot's Off.
            storage = nil
            start(false); checkDefaults()
        end
    end
end)

test("Maw damage cache is refreshed after selecting new-run settings", function()
    boot('{"version":1,"settings":{"mawOfTheVoid":false},"run":{"seed":12345,"settings":{"mawOfTheVoid":true}}}', true)
    player.HasCollectible = function() return true end
    player.GetCollectibleNum = function() return 1 end
    local evaluations = 0
    player.EvaluateItems = function(self)
        evaluations = evaluations + 1
        self.Damage = 3.5
        mods.mawofvoidunnerf:statChange(self, CacheFlag.CACHE_DAMAGE)
    end
    start(true); assert(player.Damage == 4.5)
    start(false); assert(player.Damage == 3.5)
    assert(evaluations == 2)
end)

local function exercise(key)
    if key == "mawOfTheVoid" then
        player.HasCollectible = function() return true end
        player.GetCollectibleNum = function() return 1 end
        mods.mawofvoidunnerf:statChange(player, CacheFlag.CACHE_DAMAGE)
        return player.Damage == 4.5
    elseif key == "orbitals" then
        local data = {}
        local familiar = {OrbitDistance = {X = 10, Y = 10}, Size = 5, CollisionDamage = 2,
            GetData = function() return data end}
        mods["Orbital Unnerf"]:familiarUpdate(familiar)
        return familiar.CollisionDamage == 4 and familiar.Size == 13
    elseif key == "stompImmunity" then
        local target = {Type = EntityType.ENTITY_PLAYER, ToPlayer = function() return player end}
        player.HasCollectible = function() return true end
        player.AddHearts = function() end
        return mods.pyromaniacunnerf:takeDamage(target, 1, DamageFlag.DAMAGE_CRUSH) == false
    elseif key == "humblingBundle" then
        player.HasCollectible = function() return true end
        return mods["Humbleing Bundle Unnerf Unnerf"]:pickUpSelection({}, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY) ~= nil
    elseif key == "magicMushroom" then
        return not excluded[1001] and excluded[12] == true
    else
        local called = false
        local soul = soulheartgeneratorUnnerf
        if key == "darkBum" then
            soul.darkbumunnerf.pickupInit = function() called = true end
            soul.relicunnerf.pickupInit = function() end
            soul:PickupInit({})
        elseif key == "relic" then
            soul.relicunnerf.initRelicClearCount = function() called = true end
            soul:familiarUpdate({})
        else
            soul.bluefireUnnerf.entityTakeDamage = function() called = true end
            soul:EntityTakeDamage({}, 1, 0)
        end
        return called
    end
end
for i, key in ipairs(keys) do
    test("independently disable " .. key .. "; other callbacks remain active", function()
        boot(nil, true); menu[i].OnChange(false); start(false)
        for _, other in ipairs(keys) do
            -- Reset each fixture because some enabled callbacks mutate it.
            player.Damage = 3.5
            assert(exercise(other) == (key ~= other), other)
        end
        if key == "mawOfTheVoid" then
            -- Disabled update/laser callbacks must not even inspect engine objects.
            mods.mawofvoidunnerf:blackheats(nil)
            mods.mawofvoidunnerf:update(nil)
        elseif key == "relic" then
            local relicCalled = false
            soulheartgeneratorUnnerf.relicunnerf.pickupInit = function() relicCalled = true end
            soulheartgeneratorUnnerf.darkbumunnerf.pickupInit = function() end
            soulheartgeneratorUnnerf:PickupInit({})
            assert(not relicCalled)
        end
        assert(not soulheartgeneratorUnnerf.enableNailUnnerf)
        assert(not soulheartgeneratorUnnerf.enableSatanicBibleUnnerf)
    end)
end
print(count .. " tests passed (Lua harness; no Isaac engine verification)")
