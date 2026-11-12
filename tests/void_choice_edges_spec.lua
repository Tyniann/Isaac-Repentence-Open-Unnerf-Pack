-- Diagnostic protocol, not an emulation of native Void rewards or rendering.
local json = require("dkjson")
package.preload.json = function() return json end
CollectibleType = {COLLECTIBLE_VOID = 477}
EntityType, PickupVariant = {ENTITY_PICKUP = 5, ENTITY_TEAR = 2, ENTITY_BOMBDROP = 4, ENTITY_FAMILIAR = 3}, {PICKUP_COLLECTIBLE = 100}
ItemType, ItemConfig = {ITEM_PASSIVE = 1, ITEM_ACTIVE = 3, ITEM_FAMILIAR = 4}, {TAG_QUEST = 32768}
ModCallbacks = {MC_POST_GAME_STARTED = 1, MC_PRE_USE_ITEM = 2, MC_POST_UPDATE = 3, MC_PRE_GAME_EXIT = 4, MC_USE_ITEM = 5}
CallbackPriority, UseFlag = {EARLY = -100, LATE = 100}, {USE_VOID = 64, USE_OWNED = 4}
RoomType = {ROOM_BOSS = 5, ROOM_TREASURE = 4}
Seeds = {Seed2String = function(seed) return tostring(seed) end}
local handlers, commands, records, found = {}, {}, {}, {}
local gameSeed, stage, stageType, roomType, writes, uses = 1, 1, 0, 1, 0, 0
local corruptOn, range = false, 260
local stored, shield, nativeEffects = {}, 0, 0
local suppressPost, suppressEffect = false, false
local bombs, fixedActive = 0, false
local changedFixture, immediateBombs, fixedSeedCommands = false, false, 0
local data = {version = 1, settings = {voidChoiceAbsorption = true, mawOfTheVoid = false}}
openUnnerfPack = {Config = {IsEnabled = function() return data.settings.voidChoiceAbsorption end}}
function openUnnerfPack:HasData() return true end
function openUnnerfPack:LoadData() return json.encode(data) end
function openUnnerfPack:SaveData(s) data = json.decode(s); writes = writes + 1 end
local mod = {}
function RegisterMod() return mod end
function mod:AddPriorityCallback(id, priority, fn)
    handlers[id] = handlers[id] or {}; handlers[id][priority] = fn
end
function mod:AddCallback(id, fn) self:AddPriorityCallback(id, 0, fn) end
local current = {SafeGridIndex = 84, Data = {Type = 1, Variant = 10}, ptr = 1}
local level = {}
function level:GetCurrentRoomDesc() return current end
function level:GetRoomByIdx(_, dim) return dim == 0 and current or {Data = nil} end
function level:GetCurrentRoomIndex() return 84 end
function level:GetStage() return stage end
function level:GetStageType() return stageType end
function level:GetRooms() return {Size = 1, Get = function() return current end} end
function GetPtrHash(value) return value.ptr end
local room = {}
function room:GetType() return roomType end
function room:GetAliveEnemiesCount() return 0 end
function room:IsClear() return true end
function room:IsAmbushActive() return false end
function room:GetCenterPos() return 0 end
Vector = function() return 0 end
local rng = {GetSeed = function() return 160477 end, SetSeed = function(_, seed, shift)
    assert(seed == 160477 and shift == 35)
end}
local p = {Damage = 3.5, MaxFireDelay = 10, MoveSpeed = 1, ShotSpeed = 1, Luck = 0, TearRange = 260}
function p:Exists() return true end
function p:IsDead() return false end
function p:SetMinDamageCooldown() end
function p:GetPlayerType() return 0 end
function p:GetActiveItem() return 477 end
function p:GetCollectibleNum() return 0 end
function p:GetActiveCharge() return 4 end
function p:SetActiveCharge() end
function p:GetSoulHearts() return 0 end
function p:GetEffects() return {GetCollectibleEffectNum = function(_, id) return id == 58 and shield or 0 end} end
function p:GetCollectibleRNG() return rng end
function p:UseActiveItem(item, flags, slot)
    assert(item == 477 and flags == 4 and slot == 0)
    uses = uses + 1
    for id in pairs(stored) do
        handlers[2][0](mod, id, rng, self, 64)
        nativeEffects = nativeEffects + 1
        if id == 58 and not suppressEffect then shield = shield + 1 end
        if id == 65 and not suppressEffect then bombs = bombs + 6 end
        if not suppressPost then handlers[5][0](mod, id, rng, self, 64) end
    end
    for _, value in ipairs(found) do
        if value.SubType == 58 or value.SubType == 65 then stored[value.SubType] = true end
        if value.SubType == 65 and immediateBombs then bombs = bombs + 6 end
    end
    self.TearRange = range + (corruptOn and data.settings.voidChoiceAbsorption and 1 or 0)
    found = {} -- Fixed mock outcome; no claim about native consumption.
end
local function pickup(id, group, blind)
    local value = {Type = 5, InitSeed = gameSeed + id, SubType = id, OptionsPickupIndex = group,
        Price = 0, Touched = false, blind = blind}
    function value:Exists() return true end
    function value:ToPickup() return self end
    function value:ToNPC() return nil end
    function value:Morph() error("untouched edge fixtures must never Morph") end
    return value
end
local game = {Difficulty = 0}
function game:GetFrameCount() return 100 end
function game:GetSeeds() return {GetStartSeed = function() return gameSeed end} end
function game:GetLevel() return level end
function game:GetRoom() return room end
function game:GetNumPlayers() return 1 end
function game:ChangeRoom(index)
    assert(index == 84)
    roomType = current.Data.Type
    if stage == 6 then
        -- Photo pairing need not use a nonzero ordinary option index.
        found = {pickup(327, 0, false), pickup(328, 0, false)}
    elseif gameSeed == 1344027538 then
        found = {pickup(101, 916, false), pickup(201, 916, true)}
    elseif gameSeed == 1344027651 then
        found = {pickup(changedFixture and 66 or 65, 916, true), pickup(113, 916, false)}
    else found = {pickup(101, 916, false), pickup(102, 916, true)} end
end
function Game() return game end
Isaac = {GetPlayer = function() return p end, FindByType = function() return found end,
    GetRoomEntities = function()
        local entities = {table.unpack(found)}
        for _ = 1, bombs do entities[#entities + 1] = {Type = 4} end
        return entities
    end,
    Spawn = function() error("native edge fixtures must not spawn replacement subjects") end,
    DebugString = function(s) records[#records + 1] = json.decode(s:sub(#"OUP_VOID_BATCH " + 1)) end,
    ExecuteCommand = function(s) commands[#commands + 1] = s end,
    GetItemConfig = function() return {GetCollectible = function(_, id)
        return {MaxCharges = 4, Type = id == 113 and 4 or (id == 201 or id == 477 or id == 58 or id == 65) and 3 or 1,
            Tags = (id == 327 or id == 328) and 32768 or 0}
    end} end}
dofile("tools/validation/void-choice-batch.lua")
assert(writes == 0 and #commands == 0, "loading is inert")
assert(not pcall(OUPVoidBatch.RunEdges, true), "reject missing blind observer before mutation")
assert(writes == 0 and #commands == 0)
EID = {ModVersion = "test", IsAltChoice = function(_, value) return value.blind end}
local function drive()
    local start = #records
    for _ = 1, 4000 do
        while #commands > 0 do
            local command = table.remove(commands, 1)
            if command:match("^restart") or command:match("^seed") then
                gameSeed = tonumber(command:match("^seed (%d+)$")) or 99
                if fixedActive and command:match("^seed") then
                    assert(gameSeed == 1344027651, "hidden-active check must select the recorded seed without searching")
                    fixedSeedCommands = fixedSeedCommands + 1
                end
                found, p.TearRange, range, stored, shield = {}, 260, 260, {}, 0
                bombs = 0
                roomType, current.Data.Type = 1, 1
                handlers[1][CallbackPriority.EARLY](mod, false)
                handlers[1][CallbackPriority.LATE](mod, false)
            elseif command:match("^stage") then
                stage = command == "stage 6" and 6 or 1
                stageType = stage == 6 and 0 or 4
                current.Data.Type = stage == 6 and 5 or 4
            else error("unexpected fixture command: " .. command) end
        end
        handlers[3][0](mod)
        for i = start + 1, #records do
            if records[i].kind == "batch_result" then
                local cases = {}
                for j = start + 1, i - 1 do
                    if records[j].kind == "case_result" then cases[#cases + 1] = records[j] end
                end
                return records[i], cases
            end
        end
    end
    error("fixture protocol did not finish")
end
OUPVoidBatch.RunEdges(true)
local pilot = drive()
assert(pilot.pass and #pilot.results == 1 and uses == 1)
assert(pilot.results[1].fixture.pickups[1].item == 327)
assert(pilot.results[1].fixture.pickups[2].item == 328)
assert(data.settings.voidChoiceAbsorption and not data.settings.mawOfTheVoid)
OUPVoidBatch.RunEdges(false)
local suite = drive()
assert(suite.pass and #suite.results == 6 and uses == 7)
for _, record in ipairs(records) do
    if record.kind == "edge_comparison" then
        assert(record.cohortSeed == (record.cohort == "photos" and 212727584 or 1344027539),
            "comparison must identify its cohort seed separately from the final emission run")
    end
end
for _, result in ipairs(suite.results) do
    if result.name:match("^alt") then
        assert(result.fixture.seed == 1344027539, "controls reuse the selected seed")
        assert(result.fixture.pickups[1].item == 101 and result.fixture.pickups[2].item == 102)
        assert(not result.fixture.pickups[1].blind and result.fixture.pickups[2].blind)
        assert(result.fixture.pickups[1].group == 916 and result.fixture.pickups[2].group == 916)
    end
end
corruptOn = true
OUPVoidBatch.RunEdges(false)
local failure = drive()
assert(not failure.pass and failure.error:find("differs from native unlinked rewards"),
    "comparator must catch a changed On reward rather than merely disappearing pedestals")
assert(data.settings.voidChoiceAbsorption and not data.settings.mawOfTheVoid)
corruptOn = false
local effectsBefore = nativeEffects
fixedActive = true
OUPVoidBatch.RunEdges(true, "active")
local activePilot, activePilotCases = drive()
assert(activePilot.pass and #activePilot.results == 1)
assert(activePilot.caseResultsLogged and activePilot.results[1].seed == 1344027651)
assert(activePilotCases[1].fixture.pickups[1].item == 65 and activePilotCases[1].fixture.pickups[1].blind)
assert(activePilotCases[1].fixture.seed == 1344027651)
assert(#activePilotCases[1].effects == 2 and nativeEffects == effectsBefore + 2)
assert(fixedSeedCommands == 1, "fixed pilot must select only one seed")
OUPVoidBatch.RunEdges(false, "active")
local activeSuite, activeCases = drive()
assert(activeSuite.pass and #activeSuite.results == 3)
assert(#json.encode(activeSuite) < 8192,
    "hidden-active terminal must stay below native log-line truncation size")
assert(fixedSeedCommands == 4, "three controls must each select the same fixed seed once")
for _, result in ipairs(activeCases) do
    assert(#result.effects == 2)
    for _, effect in ipairs(result.effects) do assert(effect.preCount == 1 and effect.postCount == 1) end
end
changedFixture = true
local usesBefore = uses
OUPVoidBatch.RunEdges(true, "active")
local mismatch = drive()
assert(not mismatch.pass and mismatch.error:find("fixture changed; no seed search"))
assert(uses == usesBefore and fixedSeedCommands == 5,
    "a changed native fixture must stop before using Void or searching other seeds")
changedFixture, immediateBombs = false, true
OUPVoidBatch.RunEdges(true, "active")
local immediate = drive()
assert(not immediate.pass and immediate.error:find("spawned bombs immediately"))
immediateBombs = false
suppressPost = true
OUPVoidBatch.RunEdges(true, "active")
local missingExecution = drive()
assert(not missingExecution.pass and missingExecution.error:find("pre/post use count differs"),
    "pre-use intent alone is not evidence that the stored ability executed")
suppressPost, suppressEffect = false, true
OUPVoidBatch.RunEdges(true, "active")
local missingEffect = drive()
assert(not missingEffect.pass and missingEffect.error:find("no expected observable effect"),
    "callbacks alone must not substitute for an observable stored effect")
print("Void edge fixture protocol passed; native identity, rendering and rewards still require engine evidence")
