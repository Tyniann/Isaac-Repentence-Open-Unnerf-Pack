-- Fixture protocol safety only. Native absorption is checked in the game.
local json = require("dkjson")
package.preload.json = function() return json end
CollectibleType = {COLLECTIBLE_VOID = 477}
EntityType = {ENTITY_PICKUP = 5}
PickupVariant = {PICKUP_COLLECTIBLE = 100}
ModCallbacks = {MC_POST_GAME_STARTED = 1, MC_PRE_USE_ITEM = 2, MC_POST_UPDATE = 3, MC_PRE_GAME_EXIT = 4}
CallbackPriority = {EARLY = -100, LATE = 100}
UseFlag = {USE_VOID = 64, USE_OWNED = 4}
RoomType = {ROOM_ANGEL = 15, ROOM_BOSSRUSH = 17, ROOM_TREASURE = 4, ROOM_BOSS = 5}
local handlers, commands, writes = {}, {}, 0
local records = {}
local data = {version = 1, settings = {voidChoiceAbsorption = false, mawOfTheVoid = false},
    run = {seed = 123, settings = {voidChoiceAbsorption = false}}}
local function read() return json.decode(json.encode(data)) end
openUnnerfPack = {Config = {IsEnabled = function() return true end}}
function openUnnerfPack:HasData() return true end
function openUnnerfPack:LoadData() return json.encode(data) end
function openUnnerfPack:SaveData(s) data = json.decode(s); writes = writes + 1 end
local mod = {}
function RegisterMod() return mod end
function mod:AddCallback(id, fn) self:AddPriorityCallback(id, 0, fn) end
function mod:AddPriorityCallback(id, priority, fn)
    handlers[id] = handlers[id] or {}
    handlers[id][priority] = fn
end
local current = {SafeGridIndex = 84, ptr = 1, Data = {Variant = 2}}
local level = {}
function level:GetCurrentRoomDesc() return current end
function level:GetRoomByIdx(_, dim) return dim == 0 and current or {Data = nil} end
function level:GetCurrentRoomIndex() return 84 end
function level:GetStage() return 1 end
function level:GetStageType() return 0 end
function GetPtrHash(o) return o.ptr end
local room = {}
function room:GetType() return 1 end
function room:GetAliveEnemiesCount() return 0 end
function room:IsClear() return true end
function room:IsAmbushActive() return false end
local p = {Damage = 3.5, MaxFireDelay = 10, MoveSpeed = 1, ShotSpeed = 1, Luck = 0, TearRange = 260}
function p:Exists() return true end
function p:IsDead() return false end
function p:SetMinDamageCooldown() end
function p:GetPlayerType() return 0 end
function p:GetCollectibleNum() return 0 end
function p:GetActiveCharge() return 4 end
function p:GetSoulHearts() return 0 end
function p:GetEffects() return {GetCollectibleEffectNum = function() return 0 end} end
function p:GetCollectibleRNG() return {GetSeed = function() return 1 end} end
local game = {Difficulty = 0}
function game:GetFrameCount() return 1 end
function game:GetSeeds() return {GetStartSeed = function() return 123 end} end
function game:GetLevel() return level end
function game:GetRoom() return room end
function game:GetNumPlayers() return 1 end
function Game() return game end
Isaac = {GetPlayer = function() return p end, FindByType = function() return {} end,
    DebugString = function(s) records[#records + 1] = json.decode(s:sub(#"OUP_VOID_BATCH " + 1)) end,
    ExecuteCommand = function(s) commands[#commands + 1] = s end,
    GetItemConfig = function() return {GetCollectible = function() return {MaxCharges = 4} end} end}

dofile("tools/validation/void-choice-batch.lua")
assert(writes == 0 and #commands == 0, "loading must not mutate or restart a run")
OUPVoidBatch.Run(true)
assert(#commands == 1 and commands[1] == "restart 0", "pilot has one explicit restart")
assert(writes == 0, "don't race the previous run's pre-exit save")
assert(not pcall(OUPVoidBatch.Run, true), "duplicate batch rejected")
handlers[1][CallbackPriority.EARLY](mod, false)
assert(data.settings.voidChoiceAbsorption == true and data.settings.mawOfTheVoid == false)
-- An unexpected Continue during the owned restart fails and restores the choice.
handlers[1][CallbackPriority.LATE](mod, true)
assert(data.settings.voidChoiceAbsorption == false and data.settings.mawOfTheVoid == false)
-- Simulate the production cache writing the test choice at exit; the owned late
-- cleanup must restore the original choice while preserving the run snapshot.
data.settings.voidChoiceAbsorption = true
data.run = {seed = 456, settings = {voidChoiceAbsorption = true}}
handlers[4][CallbackPriority.LATE](mod)
assert(data.settings.voidChoiceAbsorption == false)
assert(data.run.seed == 456 and data.run.settings.voidChoiceAbsorption == true)
OUPVoidBatch.Stop()
assert(data.settings.mawOfTheVoid == false)
local standardPackage = package
package = nil -- Isaac's sandbox has require(), but does not expose this table.
OUPVoidBatch.Run(false, "manual-choice-on")
assert(records[#records].kind == "resume_from_case")
assert(records[#records].fromCase == "manual-choice-on")
assert(commands[#commands] == "restart 0")
assert(data.settings.voidChoiceAbsorption == false, "resume waits for run-start input selection")
OUPVoidBatch.Stop()
package = standardPackage
-- The post-relaunch check must accept the observed engine seed without relying
-- on emit() to add it to a state table. Simulate only callback protocol here.
function mod:RemoveCallback(id, fn)
    for priority, registered in pairs(handlers[id] or {}) do
        if registered == fn then handlers[id][priority] = nil end
    end
end
local souls, shield, uses = 4, 0, 0
function p:GetPlayerType() return 15 end
function p:GetSoulHearts() return souls end
function p:GetEffects() return {GetCollectibleEffectNum = function() return shield end} end
function p:SetActiveCharge() end
function p:UseActiveItem(item, flags, slot)
    assert(item == 477 and flags == 4 and slot == 0)
    uses, souls, shield = uses + 1, souls + 2, shield + 1
    for _, id in ipairs({58, 78}) do handlers[2][0](mod, id, nil, self, 64) end
end
data.settings.voidChoiceAbsorption = false
data.run = {seed = 123, settings = {voidChoiceAbsorption = true}}
handlers[1][CallbackPriority.LATE](mod, true)
assert(not pcall(OUPVoidBatch.CheckContinue, 456), "reject another seed before using Void")
assert(uses == 0)
local beforeWrites, beforeCommands = writes, #commands
OUPVoidBatch.CheckContinue(123)
for _ = 1, 50 do
    local tick = handlers[3][0]
    if tick then tick(mod) end
end
local terminal = records[#records]
assert(terminal.kind == "continue_result" and terminal.pass == true)
assert(terminal.before.seed == 123 and terminal.observed.seed == 123)
assert(uses == 2 and souls == 8 and handlers[3][0] == nil)
assert(writes == beforeWrites and #commands == beforeCommands, "Continue does not restart or rewrite settings")
print("Void batch protocol safety passed; native engine pilot remains required")
