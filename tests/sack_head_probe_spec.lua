-- Fixture protocol smoke only. The simulated payouts are deliberately tiny;
-- native pool weighting, sack selection/payout and chain behavior stay unproven.
local enabled = arg[1] ~= "off"
local events, records, entities, frame, realCopies = {}, {}, {}, 0, 0
local spawns = 0
ModCallbacks = {MC_PRE_ENTITY_SPAWN = 1, MC_POST_PICKUP_INIT = 2,
    MC_POST_BOMB_INIT = 3, MC_POST_UPDATE = 4, MC_PRE_GAME_EXIT = 5, MC_POST_GAME_STARTED = 6}
CallbackPriority = {EARLY = -100}
EntityType = {ENTITY_PICKUP = 5, ENTITY_BOMB = 4}
PickupVariant = {PICKUP_GRAB_BAG = 69, PICKUP_COIN = 20, PICKUP_KEY = 30,
    PICKUP_BOMB = 40, PICKUP_LIL_BATTERY = 90, PICKUP_TAROTCARD = 300}
BombVariant = {BOMB_TROLL = 3, BOMB_SUPERTROLL = 4, BOMB_GOLDENTROLL = 18}
PlayerType, TrinketType = {PLAYER_ISAAC = 0}, {TRINKET_EQUALITY = 1}
ItemPoolType = {POOL_SHOP = 1, POOL_SECRET = 2, POOL_GREED_SHOP = 3,
    POOL_GREED_SECRET = 4, POOL_TREASURE = 5, POOL_GREED_TREASURE = 6}
Vector = {Zero = {X = 0, Y = 0}}
package.preload.json = function() return {encode = function(value)
    records[#records + 1] = value; return value.kind
end} end
package.loaded["Mods/Pool Rules/main"] = {Register = function() end}
function RegisterMod()
    local function add(_, event, priority, fn)
        events[event] = events[event] or {}
        table.insert(events[event], {priority = priority, fn = fn})
        table.sort(events[event], function(a, b) return a.priority < b.priority end)
    end
    return {AddPriorityCallback = add, AddCallback = function(self, event, fn) add(self, event, 0, fn) end}
end
local function dispatch(event, ...)
    for _, callback in ipairs(events[event] or {}) do callback.fn(nil, ...) end
end
local player = {Position = Vector.Zero, GetPlayerType = function() return 0 end,
    GetCollectibleCount = function() return 1 + realCopies end,
    GetTrinket = function() return 0 end, HasTrinket = function() return false end,
    HasCollectible = function(_, id) return id == 105 or (id == 424 and realCopies > 0) end,
    GetCollectibleNum = function(_, id) return id == 424 and realCopies or 0 end,
    AddCollectible = function(_, id) assert(id == 424 or id == 1002); realCopies = realCopies + 1 end}
local weights = enabled and {[1] = 1} or {[1] = 0.5, [2] = 1, [4] = 1}
local blacklisted = false
local pool = {RemoveCollectible = function() end,
    ResetRoomBlacklist = function() blacklisted = false end,
    GetCollectible = function(_, kind, decrease)
        local weight = weights[kind] or 0
        if weight <= 0 or blacklisted then return 25 end
        if decrease then weights[kind] = weight - 0.5; blacklisted = true end
        return 424
    end}
local game = {Difficulty = 0, GetNumPlayers = function() return 1 end,
    GetFrameCount = function() return frame end, GetItemPool = function() return pool end,
    GetLevel = function() return {GetCurrentRoomIndex = function() return 84 end} end,
    GetSeeds = function() return {GetStartSeed = function() return 12345 end} end}
function Game() return game end
Isaac = {GetPlayer = function() return player end, GetItemIdByName = function() return 1002 end,
    DebugString = function() end, GetItemConfig = function() return {
        GetCollectible = function(_, id)
            if id == 424 or id == 1002 then return {Type = 1, Quality = 3, Tags = 17825792} end
        end,
        GetCollectibles = function() return {Size = 1003} end,
    } end}
openUnnerfPack = {Config = {IsEnabled = function() return enabled end}}
function RNG()
    local seed
    return {SetSeed = function(_, value) seed = value end,
        RandomInt = function() return (seed == 1443646157 or seed == 1443646158) and 0 or 99 end}
end
function game:Spawn(kind, variant, position, velocity, source, subtype, seed)
    spawns = spawns + 1
    for _, callback in ipairs(events[1] or {}) do
        local replacement = callback.fn(nil, kind, variant, subtype, position, velocity, source, seed)
        if replacement then kind, variant, subtype, seed = table.unpack(replacement) end
    end
    local entity = {Type = kind, Variant = variant, SubType = subtype == 0 and 1 or subtype,
        InitSeed = seed, FrameCount = 0, Position = position, Velocity = velocity}
    local exists = true
    function entity:Exists() return exists end
    function entity:Remove() exists = false end
    function entity:ToPickup() return self end
    entities[#entities + 1] = entity
    dispatch(kind == 5 and 2 or 3, entity)
    return entity
end
dofile("Mods/Sack Head Unnerf/main.lua")
dofile("tools/validation/sack-head-probe.lua")
assert(spawns == 0 and realCopies == 0, "loading a probe must be passive")
OUPSackCheck.Start(8)
for tick = 1, 500 do
    frame = tick
    local count = #entities
    for index = 1, count do
        local entity = entities[index]
        if entity:Exists() then
            entity.FrameCount = entity.FrameCount + 1
            if entity.Type == 5 and entity.Variant == 69 and entity.FrameCount == 3 then
                game:Spawn(5, 20, entity.Position, Vector.Zero, entity, 1, entity.InitSeed + 1)
                entity:Remove()
            end
        end
    end
    dispatch(4)
end
local terminal = records[#records]
assert(terminal.kind == "done" and terminal.status == "pass")
assert(terminal.roots == 4 and realCopies == 1)
assert(terminal.secondGeneration == (enabled and 1 or 0))
assert(terminal.converted == (enabled and 2 or 0))
local finalSpawns = spawns
dispatch(4); dispatch(4)
assert(spawns == finalSpawns and not OUPSackCheck.active, "terminal must stop spawning")
for _, entity in ipairs(entities) do assert(not entity:Exists(), "clean owned fixture entities") end
-- A genuinely new run resets native pools and must permit the next check
-- without reloading the Lua mod or registering its callbacks twice.
weights = enabled and {[1] = 1} or {[1] = 0.5, [2] = 1, [4] = 1}
realCopies, blacklisted = 0, false
dispatch(6)
OUPSackCheck.Pools()
assert(records[#records].kind == "done" and records[#records].status == "pass")
print("PASS Sack Head fixture protocol " .. (enabled and "On" or "Off") .. " (simulated engine; not native evidence)")
