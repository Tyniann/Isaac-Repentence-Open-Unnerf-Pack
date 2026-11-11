-- Diagnostic entry point. Explicit Fingerprint removes only Magic Mushroom;
-- explicit Run exhausts disposable-run pools. This is not a gameplay mod.
assert(OUPPoolProbe == nil, "pool probe already loaded")
local json = require("json")
local mod = RegisterMod("OUP pool validation", 1)
local probe = {}
OUPPoolProbe = probe
local pools = {treasure = ItemPoolType.POOL_TREASURE, boss = ItemPoolType.POOL_BOSS,
    greedTreasure = ItemPoolType.POOL_GREED_TREASURE, greedBoss = ItemPoolType.POOL_GREED_BOSS,
    ultraSecret = ItemPoolType.POOL_ULTRA_SECRET}
local helperName = "OUP Magic Mushroom Pool Entry"
local continued, checked = nil, {}
local observedSeed
local label = "unstarted"
local capturing = false
local fingerprinting = false
local fallback = CollectibleType.COLLECTIBLE_DADS_NOTE

local function record(kind, fields)
    fields = fields or {}
    fields.kind, fields.label = kind, label
    fields.seed = Game():GetSeeds():GetStartSeed()
    fields.frame = Game():GetFrameCount()
    fields.continued = continued
    Isaac.DebugString("OUP_POOL " .. json.encode(fields))
end

local function context()
    local real = Isaac.GetItemConfig():GetCollectible(12)
    local id = Isaac.GetItemIdByName(helperName)
    local helper = id > 0 and Isaac.GetItemConfig():GetCollectible(id) or nil
    local saved = json.decode(openUnnerfPack:LoadData())
    return {helper = id, enabled = openUnnerfPack.Config.IsEnabled("magicMushroom"),
        choices = saved.settings, run = saved.run, difficulty = Game().Difficulty,
        realQuality = real.Quality, helperQuality = helper and helper.Quality,
        realTags = real.Tags, helperTags = helper and helper.Tags,
        realType = real.Type, helperType = helper and helper.Type,
        realHidden = real.Hidden, helperHidden = helper and helper.Hidden,
        mcm = ModConfigMenu and ModConfigMenu.Version}
end

function probe.State(nextLabel)
    if nextLabel then label = nextLabel end
    local state = context()
    record("state", state)
    print("MM_STATE", state.enabled, state.helper, state.realQuality,
        state.helperQuality, state.realTags, state.helperTags, continued)
    return state
end

local function gameStarted(_, isContinue)
    continued, checked = isContinue, {}
    observedSeed = Game():GetSeeds():GetStartSeed()
    record("game_started", {continued = isContinue})
end
local function nativePick(_, selected, pool, decrease, seed)
        if fingerprinting then return end
        local early = observedSeed ~= Game():GetSeeds():GetStartSeed()
        if capturing or early then
            record(early and "pick_before_game_started" or "native_pick",
                {selected = selected, pool = pool, decrease = decrease, pickSeed = seed})
        end
end
local function gameExit()
    record("game_exit")
    observedSeed, continued = nil, nil
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, gameStarted)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, gameExit)
mod:AddPriorityCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, CallbackPriority.EARLY, nativePick)

function probe.Fingerprint(nextLabel)
    assert(next(checked) == nil, "fingerprint needs a fresh, unconsumed pool state")
    label = nextLabel or "fingerprint"
    checked.fingerprint = true
    local state = probe.State()
    local pool = Game():GetItemPool()
    local names, canonical = {}, {}
    for name, id in pairs(ItemPoolType) do
        if type(name) == "string" and type(id) == "number" and name:match("^POOL_") and id >= 0 then
            if not canonical[id] or name < canonical[id] then canonical[id] = name end
        end
    end
    for id, name in pairs(canonical) do names[#names + 1] = {name = name, id = id} end
    table.sort(names, function(a, b) return a.id < b.id end)
    fingerprinting = true
    local ok, failure = pcall(function()
        for _, phase in ipairs({"full", "without_magic"}) do
            if phase == "without_magic" then
                -- Remove only the two Magic Mushroom identities. Every other
                -- row remains available. This permits exact seeded comparison
                -- of unrelated pool selections before/after the implementation.
                pool:RemoveCollectible(12)
                if state.helper > 0 then pool:RemoveCollectible(state.helper) end
            end
            for _, entry in ipairs(names) do
                local outputs = {}
                for index = 1, 64 do
                    outputs[index] = pool:GetCollectible(entry.id, false, 290000 + index * 7919, fallback)
                end
                record("fingerprint", {phase = phase, pool = entry.name, poolID = entry.id, outputs = outputs})
            end
        end
    end)
    fingerprinting = false
    record("fingerprint_complete", {pass = ok, pools = #names, error = failure,
        seedString = Game():GetSeeds():GetStartSeedString()})
    assert(ok, failure)
    print("MM_FINGERPRINT_COMPLETE", #names, Game():GetSeeds():GetStartSeedString())
    -- Native queries do not decrease weights. Only Magic Mushroom was excluded
    -- between the profiles; use a fresh run before its availability/depletion test.
end

function probe.Run(poolName, nextLabel)
    assert(pools[poolName] ~= nil and next(checked) == nil, "one pool check per fresh run")
    assert(continued == false, "Run needs an observed fresh disposable run")
    assert(Game():GetNumPlayers() == 1, "one disposable Isaac required")
    assert(Isaac.GetPlayer(0):GetPlayerType() == PlayerType.PLAYER_ISAAC, "use Isaac")
    assert(not Isaac.GetPlayer(0):HasCollectible(12), "start without Magic Mushroom")
    assert(Isaac.GetPlayer(0):GetCollectibleNum(Isaac.GetItemIdByName(helperName)) == 0)
    label = nextLabel or poolName
    local state = context()
    assert(state.helper > 0 and state.helperType == state.realType, "helper missing/type mismatch")
    assert(state.realQuality == state.helperQuality and state.realTags == state.helperTags,
        "helper quality/tags differ; stop before changing pools")
    record("before_isolation", state)
    checked[poolName] = true -- A failed test also needs a fresh run, not a replay.
    -- Leave exactly one native identity in every pool. This deliberately removes
    -- other items from this disposable run; restart before ordinary gameplay.
    local keep = state.enabled and state.helper or 12
    local pool = Game():GetItemPool()
    for id = 1, Isaac.GetItemConfig():GetCollectibles().Size - 1 do
        if id ~= keep then pool:RemoveCollectible(id) end
    end
    record("isolated", {keep = keep, pool = poolName})
    capturing = true
    local expected = poolName == "ultraSecret" and 3 or 1
    if poolName == "boss" and not state.enabled then expected = 0 end
    local outputs = {}
    local after
    local ok, failure = pcall(function()
        for index = 1, expected do
            outputs[index] = pool:GetCollectible(pools[poolName], true, 12000 + index, fallback)
            assert(outputs[index] == 12, "native draw mismatch; preserve log and stop")
        end
        after = pool:GetCollectible(pools[poolName], false, 12099, fallback)
    end)
    capturing = false
    record("result", {pool = poolName, expected = expected, outputs = outputs, after = after,
        fallback = fallback, pass = ok and after == fallback, error = failure})
    assert(ok, failure)
    assert(after == fallback, "pool did not deplete; preserve log and stop")
    print("MM_POOL_PASS", poolName, #outputs, after)
end

function probe.Stop()
    capturing = false
    mod:RemoveCallback(ModCallbacks.MC_POST_GAME_STARTED, gameStarted)
    mod:RemoveCallback(ModCallbacks.MC_PRE_GAME_EXIT, gameExit)
    mod:RemoveCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, nativePick)
    record("stopped")
    OUPPoolProbe = nil
    -- Deliberately no pool/health/save restoration: Run needs a disposable run.
end

function probe.CheckSpent(poolName, nextLabel)
    assert(pools[poolName] ~= nil and continued == true, "needs an observed Continue")
    label = nextLabel or "continued"
    probe.State()
    capturing = true
    local result = Game():GetItemPool():GetCollectible(pools[poolName], false, 12099, fallback)
    capturing = false
    record("continue_result", {pool = poolName, result = result, fallback = fallback,
        pass = result == fallback})
    assert(result == fallback, "Continue restored a consumed entry; stop and preserve log")
    print("MM_CONTINUE_PASS", poolName, result)
end
