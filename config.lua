-- Settings belong to the pack, independently of whether MCM is installed.
local json = require("json")
local config = {}
local options = {
    {"mawOfTheVoid", "Maw of the Void"},
    {"orbitals", "Orbitals"},
    {"stompImmunity", "Stomp immunity"},
    {"humblingBundle", "Humbling Bundle"},
    {"darkBum", "Dark Bum"},
    {"relic", "The Relic"},
    {"blueFires", "Hard-mode blue fires"},
}

local function normalize(values)
    local result = {}
    for _, option in ipairs(options) do
        local key = option[1]
        result[key] = true
        if type(values) == "table" and type(values[key]) == "boolean" then
            result[key] = values[key]
        end
    end
    return result
end

local choices, run
local function load()
    local saved = {}
    if openUnnerfPack:HasData() then
        local ok, value = pcall(function() return json.decode(openUnnerfPack:LoadData()) end)
        if ok and type(value) == "table" and value.version == 1 then
            saved = value
        end
    end
    choices = normalize(saved.settings)
    run = type(saved.run) == "table" and saved.run or nil
end
load()
local active = normalize(run and run.settings or choices)

local function save()
    openUnnerfPack:SaveData(json.encode({version = 1, settings = choices, run = run}))
end

function config.IsEnabled(key)
    return active[key] == true
end

local menuRegistered = false
local function registerMenu()
    if menuRegistered or ModConfigMenu == nil then return end
    menuRegistered = true
    ModConfigMenu.AddText("Open Unnerf Pack 2", "Unnerfs", "Changes apply to a NEW RUN only.")
    ModConfigMenu.AddText("Open Unnerf Pack 2", "Unnerfs", "Continue keeps that run's settings.")
    for _, option in ipairs(options) do
        local key, label = option[1], option[2]
        ModConfigMenu.AddSetting("Open Unnerf Pack 2", "Unnerfs", {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            CurrentSetting = function() return choices[key] end,
            Display = function() return label .. ": " .. (choices[key] and "On" or "Off") end,
            OnChange = function(value)
                if type(value) ~= "boolean" then return end
                choices[key] = value
                save()
            end,
            Info = {"Saved immediately. Start a new run to apply.",
                "Continue retains the run's choices, including after relaunch."},
        })
    end
end

openUnnerfPack:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, continued)
    -- Isaac selects a separate mod data file for each save slot. Lua can stay
    -- loaded across slot switches, so never write the previous slot's cache.
    load()
    local seed = Game():GetSeeds():GetStartSeed()
    if continued and run and run.seed == seed then
        active = normalize(run.settings)
    else
        active = normalize(choices)
    end
    run = {seed = seed, settings = normalize(active)}
    save()
    registerMenu() -- Also handles MCM loading after this mod.
    -- Initial cache evaluation may precede POST_GAME_STARTED. Re-evaluate Maw's
    -- damage now that new/continued-run settings have been selected.
    for index = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(index)
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end
end)
openUnnerfPack:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, save)
registerMenu()

return config
