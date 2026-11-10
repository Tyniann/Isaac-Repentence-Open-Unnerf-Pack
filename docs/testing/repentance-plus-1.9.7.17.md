# Repentance+ 1.9.7.17 compatibility audit and test handoff

Issue: https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/1

## Current engine-validation progress

The pre-deployment audit below is historical. Subsequent coordinated real-game
testing uses integrated source `f1c83253af3636816c3b83c6ab28d2221ad345ea`,
MCM Pure v113, and a separately hashed observer. See the
[engine results ledger](issue-1-engine-results.md) for exact deployment/backup
provenance, seeds, settings, commands, owner observations and evidence hashes.

Confirmed within the recorded local conditions (each run's actual mode and
actor context is recorded in the linked ledgers):

- Fresh loading and relaunch/Continue without pack-originated Lua errors.
- Maw acquisition/removal, two-copy damage, held-item Continue/removal and
  Hard Jacob/Esau actor isolation; ring field 0.05 On / 0 Off and one controlled
  native black-heart output. A single reward is not a probability estimate.
- Sacrificial Dagger acquisition/lifecycle fields and native contact, including
  BFFS, plus native one/two-Cube-of-Meat fields. Pack-absent controls show the
  representative increases were not already restored by this build.
- Native Dark Bum and chest-content Bundle outputs with independent gate
  controls, and actual Mom/Host Hat immunity. See the shared
  [configuration results](configuration-results-1.9.7.17.md) for exact limits.
- [Native batches](native-batches.md) record pack-absent Hard/Normal fire
  histograms, enabled Hard stacking and synthetic engine Pyromaniac crush
  controls. Observed rates are finite samples, not theoretical guarantees.

Subsequent enabled Normal batches recorded a native Relic payout/reset and
200 fire trials per variant. Acceptance is complete for the representative
local setups recorded in the current matrix. The isolated feature-Off controls
for Maw, Dark Bum and Bundle establish their native behavior without claiming
that the entire pack was absent. Whole-pack-absent repeats and the other
unexecuted cases remain optional confidence checks, not passes or additional
requirements of issue #1. Historical pending cells below must be read alongside
the current ledger and its acceptance assessment.

## Evidence boundary (2026-11-08)

Target identification: owner's running-game screenshot says **1.9.7.17**;
executable ASCII scan found `1.9.7.17.J460`. Blank Windows version fields and
a changelog headed 1.7.9b do not override that evidence. The inspected Windows
installation has **no Open Unnerf Pack installed**. No mod-enabled engine test,
fresh/continued run, or multiplayer mode has passed validation here.

Local `lua5.3 tests/compatibility.lua` exercises registered callbacks with test
doubles. It proves Lua control flow regressions only, not engine behavior,
spawn timing, native damage, native rewards, or vanilla balance.

## Installed-build source evidence

The [read-only Windows evidence report](../research/repentance-plus-installed-evidence.md)
records installed API/script line citations, packed XML provenance and checksum
verification, and the limits of those sources. Key observations:

- `resources/scripts/enums.lua:20–26,54–57` specifies the damage/pickup callback
  contracts; `resources/scripts/main.lua:223` defaults GetPlayer to index 0.
- `repentance.a` → `resources-dlc3/items.xml:406` lists Maw cache `tearcolor`,
  whereas `afterbirth.a` → `resources/items.xml:403` lists `tearcolor damage`.
  This is consistent with removed damage behavior, but does not prove a +1
  amount or establish the current engine's effective archive precedence.
- `repentance.a` → `resources-dlc3/entities2.xml:203–239,293` gives distinct
  orbital collision damage/interval values (e.g. Dagger 15/4, Meat L1 7/4,
  Big Fan 2/7). The installed changelog says several orbitals' contact damage
  was fixed; it does not identify them. Uniform doubling still needs testing.
- `changelog.txt:992,1031` historically restores blue-fire Normal drops to 25%.
  It establishes neither the current Hard rate nor purple-fire rates.
- XML identifies Relic 3.23, Dark Bum 3.64, fires 33.2/33.3 and distinct Mom/Satan
  stomp entities. Native payout algorithms, callback readiness, per-frame stat
  rewrites and immunity are not specified by those records.

## API and implementation audit

The five `require` calls remain in the root loader. Soul-heart defaults remain
Relic/Dark Bum/blue fires on; Nail/Satanic Bible off. No new unnerf or menu.

- **Maw:** damage cache callback takes player then cache flag. Damage is rebuilt
  from the cache's base plus one per collectible. The old single item count was
  shared across all players; different inventories repeatedly invalidated caches.
  Track count in each player's entity data; the first effect update also rebuilds
  the cache after loading a run. No serialized state is needed. The existing dark
  ring sprite selector and 0.05 `BlackHpDropChance` assignment remain. That field
  and a setter both exist in the API; it was not proven broken. Sprite selection
  and vanilla damage/drop stacking still need gameplay verification.
- **Orbitals:** existing nonzero X/Y orbit heuristic, blue-fly exclusion, minimum
  size 13 and one-time doubled collision damage retained. Test double verifies
  idempotence on one entity. Native per-frame stat resets, familiar recreation,
  continue/room transitions and variant-changing states remain engine checks;
  do not infer that every orbital's vanilla damage requires doubling.
- **Dark Bum:** pickup-init gets a pickup, and familiar spawner fields may be
  absent. Guard both spawner conversion and owner before exclusion checks/morph.
  Lost/Keeper and tainted variants remain excluded. Existing soul hearts are not
  morphed again. Spawned spiders are NPCs, outside this pickup callback; this
  patch does not claim to replace them or change native payout frequency.
- **Relic:** guard missing/non-familiar spawners. Existing update seeds a zero
  RoomClearCount to 2, and pickup init resets the producing Relic to 2. The API
  exposes RoomClearCount, but does not specify native payout threshold/reset
  ordering. Timing, multiple copies and continued counters need observation;
  no speculative counter rewrite was made.
- **Blue fires:** damage callback receives `(entity, amount, flags, source,
  countdown)`. Forward amount as well as flags to the helper; previously flags
  arrived in the helper's amount slot and the bitwise operation used nil. Group
  variants 2/3 under the fireplace type condition; unrelated variant-3 entities
  must not enter it. Hard-only gate and existing additional 0.17 drop roll stay.
  This is an independent extra roll, **not proof of a 25% final chance**. It can
  overlap a vanilla drop, and is not restricted to a lethal hit. Measure native
  and modded outcomes (including duplicates/repeated damage) before accepting
  the intended balance; native probability is not established by XML/API names.
- **Stomp:** damage callback uses `DAMAGE_CRUSH` and returns false for a player
  with Host Hat or Pyromaniac; Pyromaniac calls AddHearts(2), one red heart in
  half-heart units (the old comment says half a heart incorrectly). Localize
  the player reference. No proven cause/fix for the historical malfunction is
  claimed; https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/2
  remains required evidence before marking this row complete.
- **Humbling Bundle:** enumerate `Isaac.GetPlayer(0..GetNumPlayers()-1)`;
  the old 1..N loop skipped the first player and requested an invalid last index.
  Keep ownership local. Selection returns a `{variant, subtype}` pair only for
  a single full heart/penny/key/bomb. Existing doubles are left alone, preventing
  another conversion when vanilla already chose a double. Re-entry selection
  and pickups created before acquiring the item need gameplay checks.

API references (API descriptions, not game-runtime evidence):

- [Callback declarations and pickup-init limitations](https://wofsauge.github.io/IsaacDocs/rep/enums/ModCallbacks.html)
- [Game player count](https://wofsauge.github.io/IsaacDocs/rep/Game.html#getnumplayers)
- [Isaac.GetPlayer](https://wofsauge.github.io/IsaacDocs/rep/Isaac.html#getplayer)
- [Familiar fields](https://wofsauge.github.io/IsaacDocs/rep/EntityFamiliar.html)
- [Console command syntax](https://wofsauge.github.io/IsaacDocs/rep/tutorials/DebugConsole.html)
- [Laser fields/methods](https://wofsauge.github.io/IsaacDocs/rep/EntityLaser.html)

## Owner-run procedure

Coordinate deployment first; this document does not authorize an agent to alter
an active game, settings, saves or installed mods. Owner should use a disposable
local test run/save, disable other gameplay mods and the original Workshop pack,
and install this PR's recorded commit as described in README. Record title/build,
commit SHA, character, difficulty, other mods, fresh/continue status and Lua errors.

Use an already enabled debug console. If it is not enabled, coordinate the owner's
preferred console setup separately. The commands below use the standard `giveitem
c<ID>`, named `remove` and `spawn type.variant.subtype` syntax. No item-access seed
is claimed. Each row starts a separate fresh Isaac run unless stated otherwise.
Run the same interaction with the pack disabled, then with the pack enabled.
Do not toggle the pack during a continued run. Quit to menu and Continue with the
same configuration for continuation checks. Save logs/error text and observations.

| Feature | Exact setup / interaction | Intended pack outcome; vanilla comparison | Observed / outstanding |
| --- | --- | --- | --- |
| Load | Start Normal Isaac with pack enabled; enter a room, quit to menu, Continue; repeat Hard | Five modules load, no pack Lua errors or state drift | **Pending owner**, fresh and continue |
| Maw | `giveitem c399`; record damage, charge/release ring into enemies; give a second copy; `remove Maw of the Void` and record count/damage again | +1 damage per copy through cache; removal recalculates; ring can drop black hearts at configured 0.05 chance. Compare vanilla item damage and many ring kills for already restored effects | Contract cache tests pass; native damage, ring identity, drops and continue **pending** |
| Orbitals | Separately `giveitem c73` (Cube of Meat), `giveitem c10` (Halo of Flies), `giveitem c279` (Big Fan); touch the same enemy type with the orbital; add repeated c73 copies to change its state; leave/return and Continue | Existing rule size >=13 and doubled contact damage once per entity. Compare contact damage/ticks and hitbox to vanilla; do not apply twice if already restored | Contract idempotence passes; native damage resetting, state transitions, recreation and stacking **pending** |
| Dark Bum | `giveitem c278`; repeatedly `spawn 5.10.1`, allow Bum to consume hearts and pay out; repeat with Lost/Keeper and tainted variants | Nonexcluded owners' familiar pickup rewards become soul hearts; excluded owners keep native rewards. Record spiders separately and compare native payout frequency | Missing-spawner guard passes; reward identity, owner, payout cycle, continue **pending** |
| Relic | `giveitem c98`; clear actual hostile rooms, number each clear and payout; add another c98; quit/Continue between payouts | Counter-based earlier soul-heart payout, each familiar independently. Record exact native versus modded intervals, first payout and remainder after continue before accepting restoration | Contract counter writes pass; native threshold/reset timing and exact cadence **pending** |
| Blue/purple fires Hard | Hard Isaac: `spawn 33.2.0`, then `spawn 33.3.0`; `giveitem c19` (Boom); bomb each fire. Repeat many times, recording 0/1/2 heart drops and repeated/nonlethal hits | Extra 0.17 roll on explosion damage only; establish whether vanilla already restores the intended rate and whether duplicates distort it | Callback forwarding/type/mode tests pass; native baseline, final distribution and duplicate risk **pending** |
| Blue/purple fires Normal | Repeat same fire/bomb procedure in Normal | Pack contributes no additional roll; native behavior unchanged | Contract mode gate passes; engine comparison **pending** |
| Stomp | Separate runs: `giveitem c375` (Host Hat), `giveitem c223` (Pyromaniac), both, neither. For each `giveitem c550` (Broken Shovel); confirm it produces damaging stomps before testing protection. Wound Isaac beforehand for healing case | No stomp damage with either item; Pyromaniac heals one red heart per cancelled crush. Repeat against an ordinary enemy to confirm noncrush damage remains. Capture actual flags/logs if mismatch | **Pending owner and #2**; Broken Shovel fixture must first damage unprotected Isaac; confirm separately in actual Mom fight |
| Humbling Bundle | `giveitem c203`; spawn `5.10.1`, `5.20.1`, `5.30.1`, `5.40.1`; also obtain random room rewards, open chests and revisit uncollected pickups; repeat without item | Single full red hearts/pennies/keys/bombs select double packs; already doubled pickups remain doubles. Compare vanilla random selection, also verify explicit spawn path invokes selection | Contract player enumeration and no reconversion pass; native callback paths and continue **pending** |

For RNG rows, a single missing reward is not a failure and a single reward is not
proof of the target probability. Record sample counts and distributions. No mode
(including local co-op or online multiplayer) is engine-verified. Local contract
tests include distinct player inventories solely to catch enumeration/cache bugs.

## Acceptance / integration handoff

Keep #1 open until fresh/continued game loads and all vanilla/modded comparisons
are recorded. In particular blue-fire probability, native orbital stats, Relic
ordering and #2 stomp reproduction are unresolved. If vanilla has restored a
mechanic, revise that module before accepting the row; this audit does not assume
an old nerf still exists. No closure keyword belongs in this PR yet.

Compared the published [configuration PR #5](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/pull/5)
diff on 2026-11-08. It overlaps Maw, Humbling Bundle, soul-heart callback dispatch,
stomp and README. Before merging, compare its latest head and resolve overlapping
module changes: preserve these callback arguments, index range, player data cache
and spawner guards while incorporating its configuration independently. Nail and
Satanic Bible must remain disabled. #4 Magic Mushroom is outside this change.

PR #5 gates callbacks through `openUnnerfPack.Config.IsEnabled`; retain those gates
alongside this patch's fixes. Its damage-cache callback/run-start re-evaluation
must operate on the per-player count implementation. Update the regression
harness to supply configuration when testing the integrated loader, and rerun
both test suites. The current independent PRs have not been merged together.
