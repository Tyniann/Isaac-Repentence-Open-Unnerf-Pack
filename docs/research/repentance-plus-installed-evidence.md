# Local Isaac API and balance evidence — target 1.9.7.17

Inspected 2026-11-08 through a read-only Windows research delegate. No game launch, installation, settings/save changes or game-directory writes. Target identification is owner-confirmed; these are file observations, not gameplay validation.

## Sources and evidence limits

- `G = D:/The.Binding.of.Isaac.Repentance.v4.0.2`.
- `D = G/tools/LuaDocs`; `S = G/resources/scripts`.
- `E = G/mods/external item descriptions` is **third-party secondary evidence**, not vanilla implementation.
- `P = C:/Users/Mario/.t3/scratch/2026-11-08-act-as-the-research-sub-42ddcece/archive-research`.
- Read `P/findings.md` and parsed `P/results.json`. Prior executable evidence: SHA-256 `e5faf6f513c6de9cc9ff1c335ef9c541e2b33fc623aa3b8ffbd2e6a6c0027bb0`, embedded `1.9.7.17` at decimal offset 7447517 and `1.9.7.17.J460` at 7849939. Target version is supplied as confirmed; no runtime check was performed here. The changelog starts with v1.7.9b and is not proof of the installed executable's version.
- `S/main.lua:168–169` literally declares `REPENTANCE = true` and `REPENTANCE_PLUS = true`. This is additional installed-script evidence; runtime compatibility of every old HTML entry remains untested.
- Decoded **only items.xml and entities2.xml** at known resource prefixes in four installed archives: **8/8 exact decoded lengths and archive checksums passed**, then XML parsing succeeded. Original XML bytes are retained in scratch as `<pack>-<filename>`; index records, lengths, hashes and selected elements are in `local-data-results.json`. These are full copies of eight targeted records, not bulk extraction. `inspect_local.py` uses only decoder definitions from the earlier audited script, without running that script's top-level writer.
- Physical archive names are provenance, **not historical version labels**. In this installation `afterbirthp.a` already has localization keys and modern data matching many Repentance entries. Runtime archive merge/override precedence and native C++ mechanics were not established.

## Exact API findings

### Damage callback, forwarding and return behavior

`S/enums.lua:20–26` and `D/group__enums.html:6198` specify:

```lua
-- callback arguments after the mod/self argument:
(TookDamage, DamageAmount, DamageFlag, DamageSource, DamageCountdownFrames)
-- DamageSource: EntityRef
-- true or nil: sustain damage; false: ignore damage
-- Called before new damage is applied.
```

Player amounts are integer **half-hearts**; non-player amounts are hit points. The optional registration parameter filters the **damaged entity's EntityType**, not source type. `D/class_entity.html:127,1403–1446` exposes:

```lua
boolean Entity:TakeDamage(float Damage, integer Flags,
                          EntityRef Source, integer DamageCountdown)
```

Thus a forwarding call's exact argument order is `entity:TakeDamage(amount, flags, source, countdown)`, preserving the original `EntityRef source` and countdown. The callback's return contract has no documented numeric/table damage replacement. `return amount` is not a documented way to change damage.

`S/main.lua:66–79` actually dispatches callbacks as `v.Function(v.Mod, ...)` and immediately returns the **first non-nil result**. Therefore, in this installed Lua dispatcher even `true` ends further matching callbacks, whereas nil allows later callbacks. That distinction matters for compatibility.

**Not established by these files:** whether/when a nested TakeDamage call re-enters this callback, native cooldown effects on nested damage, or a tested forwarding implementation. If implementing replacement through TakeDamage, a re-entry guard and cancellation of the original event are implementation requirements to validate; no runtime validation exists here. Do not present a forwarding sketch as tested.

### Pickup init, selection and spawner provenance

- `S/enums.lua:54`: `MC_POST_PICKUP_INIT = 34, -- (EntityPickup Pickup)`.
- `S/enums.lua:55`: `MC_POST_PICKUP_UPDATE = 35, -- (EntityPickup Pickup)`.
- `S/enums.lua:57` and `D/group__enums.html:6250`: `MC_POST_PICKUP_SELECTION = 37, -- (EntityPickup Pickup, integer Variant, integer Subtype), return nil or an array table ... return { Variant, Subtype }`.
- Exact selection return is a **two-element positional table**, e.g. `{variant, subtype}`, or nil. A keyed `{Variant=..., SubType=...}` table, a lone subtype, and `{Type, Variant, SubType}` are not this documented contract.
- `S/enums.lua:44` separately documents MC_PRE_ENTITY_SPAWN arguments including `Entity Spawner` and optional return `{Type, Variant, Subtype, Seed}`. Do not confuse its four-element return with pickup selection.
- `D/class_entity.html:267,269,313` / detailed entries at 1899–1939 expose `SpawnerType: EntityType`, `SpawnerVariant: integer`, `SpawnerEntity: Entity`. Pickup inherits them (`class_entity_pickup.html:295,297,341`). Their detailed descriptions are empty.
- Relevant constants: `S/enums.lua:107` ENTITY_FAMILIAR=3; `:1119` RELIC=23; `:1153` DARK_BUM=64. These let code compare provenance **if populated**; they do not prove all Relic/Dark Bum rewards have that provenance.

**Critical unknown:** the installed primary docs do not specify which pickup properties are ready during POST_PICKUP_INIT, relative selection/init order, spawner lifetime/nullability, or whether the native reward spawner is always its familiar. They do not justify a guarantee that spawner fields are already reliable in init, or that waiting exactly one frame repairs them.

Secondary observation only: `E/main.lua:273–277` says `POST_PICKUP_INIT occurs right before the Flip item is decided`; `:314–340` uses init to stage later Flip tracking. This supports caution about assuming all pedestal decisions are finalized at init, but says nothing conclusive about familiar reward spawners.

### GetPlayer indexing

`S/main.lua:223`: `-- EntityPlayer Isaac.GetPlayer(int ID = 0)`; `D/namespace_isaac.html:748–763` exposes `GetPlayer(integer playerId)` but no prose about bounds. A concrete local usage is `E/features/eid_api.lua:1828–1830`:

```lua
for i = 0, game:GetNumPlayers() - 1 do
    local player = Isaac.GetPlayer(i)
```

Use **zero-based** player indices, `0 .. GetNumPlayers()-1`. The primary script establishes default 0; the installed third-party loop corroborates the range. No runtime call was made.

### Familiar RoomClearCount and orbital CollisionDamage lifecycle

- `D/class_entity_familiar.html:321,963–974`: `integer EntityFamiliar::RoomClearCount`; detailed prose is empty. It is exposed as an attribute, but no documented starting value, increment/reset order, payout threshold, persistence or special behavior for Relic exists there.
- `D/class_entity.html:303,1645–1656`: `float Entity::CollisionDamage`; inherited by familiar (`class_entity_familiar.html:374`). Detailed prose is empty.
- `S/enums.lua:8–9`: FAMILIAR_UPDATE takes a familiar every frame; FAMILIAR_INIT is called just after a custom familiar is initialized. The local wording does **not** specify ordering relative to native orbital assignments or establish that an init write remains unchanged afterward.
- No first-party Lua implementation for the requested item mechanics was found in the installed loose scripts (main/enums plus JSON, socket and debugger support). XML values below are defaults/data evidence. They do not prove current per-frame values, BFFS scaling, native rewrites or whether a repeated assignment would overwrite another mod's changes.

## Vanilla packed XML evidence

Line citations in this section refer to the byte-identical scratch copies. The corresponding installed sources are `G/resources/packed/<pack>` → `resources/{items,entities2}.xml`, except repentance.a → `resources-dlc3/{items,entities2}.xml`.

### Maw of the Void

- `afterbirth.a-items.xml:403`: `<passive ... cache="tearcolor damage" ... devilprice="2" ... id="399" name="Maw Of The Void" />`.
- `repentance.a-items.xml:406`: `<passive ... id="399" name="#MAW_OF_THE_VOID_NAME" cache="tearcolor" devilprice="2" />`. `afterbirthp.a-items.xml:406` has the same relevant attributes.
- `S/enums.lua:12–15` explains cache values say which stats require reevaluation. The change in cache token is actual vanilla data consistent with a removed damage-stat effect. **It does not encode or prove a +1 amount**, ring damage/ticks, or black-heart generation/chance. No black-heart reward logic occurs in these item records. Absence of such XML logic does not prove absence of the engine effect.

### Orbitals: exact contact-damage and interval attributes

Each cell is literal `collisionDamage / collisionInterval`; `absent` means no interval attribute. All rows are familiar type 3. Values are identical between config.a and afterbirth.a for these rows, and between afterbirthp.a and repentance.a.

| Familiar / variant | config.a or afterbirth.a | repentance.a (also afterbirthp.a) | repentance.a XML line |
|---|---|---|---|
| Forever Alone / 30 | 2 / absent | 2 / 2 | 203 |
| Distant Admiration / 31 | 5 / absent | 5 / 2 | 206 |
| Guardian Angel / 32 | 7 / absent | 7 / 4 | 209 |
| Fly Orbital / 33 | 0 / absent | 0 / 7 | 212 |
| Sacrificial Dagger / 35 | 15 / absent | 15 / 4 | 215 |
| Cube of Meat L1,L2 / 44,45 | 7 / absent | 7 / 4 | 230,233 |
| Cube of Meat L3 / 46 | 3.5 / absent | 5 / 12 | 236 |
| Cube of Meat L4 / 47 | 5.5 / absent | 10 / 12 | 239 |
| Big Fan / 65 | 2 / absent | 2 / 7 | 293 |
| Ball of Bandages L1,L2 / 69,70 | 7 / absent | 7 / 4 | 305,308 |
| Ball of Bandages L3 / 71 | 3.5 / absent | 5 / 12 | 311 |
| Ball of Bandages L4 / 72 | 5.5 / absent | 10 / 12 | 314 |

All cited lines are in `repentance.a-entities2.xml`; earlier examples are `afterbirth.a-entities2.xml:158–194,248,260–269` and `config.a-entities2.xml:125–161,212,224–233`. L3/L4 are included to distinguish them from orbital L1/L2. **Do not treat an absent old interval as zero, assume an undocumented default, or derive measured DPS from this table.** The inspected API HTML has no CollisionInterval member documentation. `G/changelog.txt:698` says “Fixed several orbitals doing less contact damage than intended” without naming them or giving values.

### Relic, Dark Bum, fires, stomps and Bundle

- **Relic:** `repentance.a-items.xml:99` is a familiar id 98, description key and devilprice=2; `repentance.a-entities2.xml:185` is familiar 3.23, `collisionDamage="0"`. No room payout interval or RoomClearCount rule is encoded.
- **Dark Bum:** `repentance.a-items.xml:283` is familiar id 278; `repentance.a-entities2.xml:290` is familiar 3.64, `collisionDamage="0"`. No consumed-heart threshold, reward distribution, or reward spawner behavior is encoded. `G/changelog.txt:1035–1036` separately records exclusion for The Lost and a one-container devil price; those are changelog statements, not a reward implementation.
- **Blue/purple fireplaces:** `repentance.a-entities2.xml:1218,1223` identifies entity **33.2 / 33.3**, both baseHP=5, collisionDamage=1, shutdoors=false. No difficulty-conditioned reward probabilities occur in those elements. `G/changelog.txt:992,1031` (v1.7.2) says exactly “Increased the drop rate of soul hearts from blue fires from 10% back to 25% in Normal Mode.” This is primary historical documentation for **blue, Normal=25%**, not proof of current 1.9.7.17 execution. It does **not** explicitly establish current Hard=10%, any purple-fire rate, or Greed/Greedier behavior. Those remain unverified locally.
- **Mom/Satan stomp:** `afterbirth.a-entities2.xml:1020,1399` has 45.10 Mom Stomp and 84.10 Satan Stomp, both collisionDamage=0; `repentance.a-entities2.xml:1386,1870` has collisionDamage=2 for both. Effect **1000.29** Mom Foot Stomp remains collisionDamage=0 (`afterbirth.a:2168`, `repentance.a:3084`). These are distinct entities; do not assume their damage handlers or immunity paths are interchangeable. `S/enums.lua:1080`: `DAMAGE_CRUSH = 1<<24`, comment “damage comes from a strong impact (Mom's foot, rock spikes, rock tears)”. This documents the flag's meaning but does not prove each concrete stomp actually emits it in this build, or encode Host Hat/Pyromaniac immunity. Their item XML has no immunity rules (`repentance.a-items.xml:225,382`).
- **Daddy Longlegs, if 'stomp' meant the familiar:** entity 3.16 has collisionDamage=20 in all four packs; repentance.a also has collisionInterval=14 (`repentance.a-entities2.xml:170`, `afterbirth.a:125`). No attack timing or DPS formula is supplied by these attributes.
- **Humbleing Bundle:** id 203 is a passive; `afterbirth.a-items.xml:205` says only `description="1+1 free 4Evar"`; `repentance.a-items.xml:205` uses localization keys. Neither encodes a probability, eligible pickups, doubling-selection order or an API callback interaction. Enum definitions identify double-pack subtypes—coin=4 (`S/enums.lua:764`), key=3 (`:773`), bomb=2 (`:796`)—without documenting Bundle's algorithm.

## Debug console syntax — documented locally, never executed

`D/debug_console_primer.html` documents:

- `:137`: `spawn Type.Variant.Subtype.Champion`; examples `spawn 20`, `spawn 10.1`, `spawn 10.2.0.4`.
- `:141`: `goto s.boss.1010`, `goto s.error.21`, `goto d.10`. `s` means special rooms, `d` normal rooms; actual layout depends on the current floor. A room number alone is not a universal fixed layout.
- `:165`: `giveitem c15` for collectible ID, `giveitem t15` for trinket ID; alias `g`; names also supported.
- `:171–174`: command is **`remove`**, with named-item examples `remove soy milk`, `remove cursed eye`, alias example `r bob's brain`, trinket `remove t53`, and `remove *`. There is no documented `removeitem` command here. A `remove c<ID>` example is not provided; named removal below follows the explicit examples.
- `:154–159`: `debug 3` invincibility, `debug 4` +40 damage, `debug 7` damage display, `debug 8` full active charge, `debug 9` very high luck, `debug 10` automatic enemy damage. These can contaminate balance tests; no flags were enabled here.

Documented grammar plus verified enums/XML gives the following **candidate manual setup inputs**, not runtime-tested recipes:

```text
giveitem c399              # Maw of the Void
giveitem c172              # Sacrificial Dagger
giveitem c73               # Cube of Meat; additional copies change level
giveitem c207              # Ball of Bandages; additional copies change level
giveitem c98               # The Relic
giveitem c278              # Dark Bum
giveitem c203              # Humbleing Bundle
giveitem c223              # Pyromaniac
giveitem c375              # Host Hat
remove Maw of the Void
remove Humbleing Bundle
spawn 33.2                 # blue fireplace
spawn 33.3                 # purple fireplace
spawn 5.10.1               # full red heart
spawn 5.10.3               # soul heart
spawn 5.10.6               # black heart
spawn 5.100.399            # Maw collectible pedestal
spawn 10.0.0               # gaper target
goto d.10                  # floor-dependent normal layout
goto s.boss.1010           # explicit example in local primer
```

**The `#` annotations are report comments, not documented console syntax: enter only text before `#`.** Pickup constants: `S/enums.lua:714,733,746,748,751`; collectible IDs: `:3167,3192,3266,3297,3301,3317,3372,3469,3493`. The item XML independently identifies the IDs above. No local console syntax for switching Normal/Hard difficulty was verified. Directly spawning an effect/familiar is not documented as equivalent to its normal item-driven/native attack lifecycle.

## What remains unverified without native implementation or runtime

Damage-forwarding re-entry and native side effects; readiness and reliability of pickup spawner fields in each callback; RoomClearCount initialization/increment/reset/payout order; native orbital CollisionDamage rewrites and modifier timing; current Maw +1/black-heart behavior and odds; exact Relic/Dark Bum/Bundle algorithms; current Hard and purple-fire soul-heart probabilities; actual per-attack stomp flags/immunity. These files provide no basis to turn those unknowns into confirmed build-specific mechanics.

