-- Separate disposable-run observer. Production never loads this file.
-- Pool isolation is destructive; restore/discard this run after validation.
local mod = RegisterMod("OUP Sack Head Validation", 1)
local json = require("json")
local check = {active = false}
OUPSackCheck = check
local knownSeeds = {1443646156, 1793274606, 2332024273, 672320741}

local function emit(kind, fields)
    fields = fields or {}
    fields.kind, fields.label = kind, "ISSUE20_VALIDATE"
    fields.frame, fields.phase = Game():GetFrameCount(), check.phase
    local line = "OUP_SACK20 " .. json.encode(fields)
    Isaac.DebugString(line)
    print(line)
end

local function cleanup()
    for _, entity in ipairs(check.entities or {}) do
        if entity:Exists() then entity:Remove() end
    end
end

local function fail(message)
    check.active = false
    emit("fail", {reason = message})
    cleanup()
end

local function initialize()
    assert(not check.active and not check.started, "one check per fresh disposable run")
    assert(Game():GetNumPlayers() == 1, "use one Isaac")
    local player = Isaac.GetPlayer(0)
    assert(player:GetPlayerType() == PlayerType.PLAYER_ISAAC, "use normal Isaac")
    assert(player:GetCollectibleCount() == (player:HasCollectible(105) and 1 or 0),
        "use a fresh run with no items except the starting D6")
    assert(player:GetTrinket(0) == 0 and player:GetTrinket(1) == 0, "remove all trinkets")
    check.helper = Isaac.GetItemIdByName("OUP Sack Head Pool Entry")
    local items = Isaac.GetItemConfig()
    local original, helper = items:GetCollectible(424), items:GetCollectible(check.helper)
    assert(check.helper > 0 and original and helper, "test build/helper absent")
    assert(original.Type == 1 and original.Quality == 3 and original.Tags == 17825792,
        "unexpected native Sack Head metadata")
    assert(helper.Type == original.Type and helper.Quality == original.Quality
        and helper.Tags == original.Tags, "helper metadata does not mirror native")
    check.started, check.enabled = true, openUnnerfPack.Config.IsEnabled("sackHead")
    check.phase, check.clock, check.root, check.bagCount = "pools", 0, 0, 0
    check.entities, check.bags, check.spawns = {}, {}, {}
    check.converted, check.secondGeneration, check.outputs = 0, 0, 0
    check.room = Game():GetLevel():GetCurrentRoomIndex()
    emit("start", {seed = Game():GetSeeds():GetStartSeed(), difficulty = Game().Difficulty,
        enabled = check.enabled, helper = check.helper, type = helper.Type,
        quality = helper.Quality, tags = helper.Tags, equality = player:HasTrinket(TrinketType.TRINKET_EQUALITY)})
end

local function pools()
    local pool, items = Game():GetItemPool(), Isaac.GetItemConfig()
    local keep = check.enabled and check.helper or 424
    for id = 1, items:GetCollectibles().Size - 1 do
        if id ~= keep and items:GetCollectible(id) then pool:RemoveCollectible(id) end
    end
    local definitions = {
        {"shop", ItemPoolType.POOL_SHOP, true},
        {"secret", ItemPoolType.POOL_SECRET, not check.enabled},
        {"greedShop", ItemPoolType.POOL_GREED_SHOP, false},
        {"greedSecret", ItemPoolType.POOL_GREED_SECRET, not check.enabled},
        {"treasure", ItemPoolType.POOL_TREASURE, false},
        {"greedTreasure", ItemPoolType.POOL_GREED_TREASURE, false},
    }
    for _, row in ipairs(definitions) do
        pool:ResetRoomBlacklist()
        local selected = pool:GetCollectible(row[2], false, 12345)
        emit("pool", {pool = row[1], id = row[2], selected = selected, expectedAvailable = row[3]})
        assert((selected == 424) == row[3], "unexpected pool availability: " .. row[1])
    end
    -- Isolation is only an availability/depletion check, never a rate profile.
    -- A decreasing draw also blacklists the selected entry for this room.
    -- Clear that independent restriction before measuring residual weight.
    local function draw(decrease, step)
        pool:ResetRoomBlacklist()
        local selected = pool:GetCollectible(ItemPoolType.POOL_SHOP, decrease, 24680)
        emit("pool_draw", {step = step, selected = selected, decrease = decrease})
        return selected
    end
    local first = draw(true, "first_decrease")
    local second = draw(false, "after_first")
    assert(first == 424, "Shop positive anchor absent")
    assert((second == 424) == check.enabled, "unexpected depletion after first draw")
    if check.enabled then
        assert(draw(true, "second_decrease") == 424,
            "historical second half-weight draw missing")
    end
    local exhausted = draw(false, "after_last")
    emit("depletion", {first = first, afterFirst = second, exhausted = exhausted})
    assert(exhausted ~= 424, "Shop did not deplete at the expected native threshold")
end

local function protectedStart(fn)
    local ok, message = pcall(fn)
    if not ok then fail(tostring(message)); error(message) end
end

function check.Pools()
    protectedStart(function()
        initialize()
        pools()
        emit("done", {status = "pass", scope = "isolated native pools only", discardRun = true})
    end)
end

function check.Start(budget)
    protectedStart(function()
        initialize()
        pools()
        check.budget = budget or 8
        assert(check.budget >= 4 and check.budget <= 64 and check.budget % 1 == 0, "budget 4..64")
        check.active, check.phase, check.limit = true, "without_sack_head", 4
        emit("phase_start", {roots = 4, held = false})
    end)
end

function check.More(additional)
    assert(check.started and not check.active and check.inconclusive, "no pending natural-chain sample")
    local extra = additional or 8
    assert(extra >= 1 and extra % 1 == 0 and check.root + extra <= 64, "total root budget <= 64")
    check.active, check.inconclusive, check.phase = true, false, "with_sack_head"
    check.limit = check.root + extra
    emit("more", {limit = check.limit})
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, CallbackPriority.EARLY,
    function(_, kind, variant, subtype, _, _, spawner, seed)
        if not check.active or not spawner or spawner.Type ~= 5 or spawner.Variant ~= 69 then return end
        local parent = check.bags[spawner.InitSeed]
        if not parent then return end
        check.spawns[seed] = {parent = spawner.InitSeed, generation = parent.generation + 1,
            kind = kind, variant = variant, subtype = subtype}
        emit("reward_pre", {seed = seed, parent = spawner.InitSeed, kindInput = kind,
            variant = variant, subtype = subtype, generation = parent.generation + 1})
    end)

local function initialized(_, entity)
    if not check.active then return end
    local origin = check.spawns[entity.InitSeed]
    if not origin and not check.spawningRoot then return end
    check.entities[#check.entities + 1] = entity
    if entity.Type == 5 and entity.Variant == 69 then
        local generation = origin and origin.generation or 0
        check.bags[entity.InitSeed] = {entity = entity, generation = generation}
        check.bagCount = check.bagCount + 1
        if origin then
            check.converted = check.converted + 1
            if generation >= 2 then check.secondGeneration = check.secondGeneration + 1 end
            if not check.enabled or check.phase == "without_sack_head" then
                fail("unexpected sack conversion in vanilla control"); return
            end
        end
        emit("sack_init", {seed = entity.InitSeed, parent = origin and origin.parent,
            generation = generation, subtype = entity.SubType})
        if entity.SubType ~= 1 and entity.SubType ~= 2 then fail("unresolved sack subtype"); return end
    elseif origin then
        check.outputs = check.outputs + 1
        emit("reward_init", {seed = entity.InitSeed, kindOutput = entity.Type,
            variant = entity.Variant, subtype = entity.SubType, parent = origin.parent})
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, initialized)
mod:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, initialized)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if not check.active then return end
    check.clock = check.clock + 1
    if check.clock > 3600 or check.bagCount > 160 then fail("bounded fixture budget exceeded"); return end
    if Game():GetLevel():GetCurrentRoomIndex() ~= check.room then fail("room changed during fixture"); return end
    local player, liveBags = Isaac.GetPlayer(0), 0
    for seed, bag in pairs(check.bags) do
        if bag.entity:Exists() then
            liveBags = liveBags + 1
            bag.entity.Position, bag.entity.Velocity = player.Position, Vector.Zero
            bag.entity:ToPickup().Wait = 0
        elseif not bag.opened then
            bag.opened = true
            emit("sack_opened", {seed = seed, generation = bag.generation})
        end
    end
    for _, entity in ipairs(check.entities) do
        if entity:Exists() and not (entity.Type == 5 and entity.Variant == 69)
            and entity.FrameCount >= 2 then entity:Remove() end
    end
    if check.phase == "grant" then
        if player:GetCollectibleNum(424, true) == 1 and not player:HasCollectible(check.helper, true) then
            emit("ownership", {real = player:GetCollectibleNum(424, true), helper = 0})
            check.phase, check.root, check.limit, check.bags, check.spawns = "with_sack_head", 0,
                check.enabled and check.budget or 4, {}, {}
            check.nextRoot = check.clock + 1
        elseif check.clock - check.grantedAt > 60 then fail("helper did not convert to one real Sack Head") end
        return
    end
    if check.root < check.limit and check.clock >= (check.nextRoot or 1) then
        check.root = check.root + 1
        check.spawningRoot = true
        local seed = knownSeeds[check.root] or (1610612736 + 7919 * check.root)
        Game():Spawn(5, 69, player.Position, Vector.Zero, nil, 1, seed)
        check.spawningRoot, check.nextRoot = false, check.clock + 45
        return
    end
    if check.phase == "with_sack_head" and check.secondGeneration > 0 and check.root >= 4 then
        check.limit = check.root -- Stop producing new roots; drain genuine descendants.
    end
    if check.root < check.limit or liveBags > 0 then return end
    cleanup()
    if check.phase == "without_sack_head" then
        emit("without_item_complete", {roots = check.root, converted = check.converted})
        check.phase, check.grantedAt = "grant", check.clock
        player:AddCollectible(check.enabled and check.helper or 424)
        return
    end
    check.active = false
    check.inconclusive = check.enabled and check.secondGeneration == 0
    emit("done", {status = check.inconclusive and "inconclusive" or "pass", roots = check.root,
        converted = check.converted, secondGeneration = check.secondGeneration,
        nativeOutputs = check.outputs, enabled = check.enabled, discardRun = true})
end)

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function()
    if check.active then check.active = false; emit("aborted", {reason = "game exit"}) end
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    if check.active then emit("aborted", {reason = "new run"}) end
    check.active, check.started, check.inconclusive = false, false, false
end)
