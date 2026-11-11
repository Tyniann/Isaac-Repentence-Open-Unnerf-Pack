# Configuration validation — issue #3

## Primary API evidence

Supported implementation: **Mod Config Menu Pure v113**, source revision
`a4c15349c8ed8c38f31bf45bdf5d2896f4e9d23d`.

- [Source](https://github.com/Zamiell/isaac-mod-config-menu/blob/a4c15349c8ed8c38f31bf45bdf5d2896f4e9d23d/scripts/modconfig.lua)
  declares `VERSION = 113`, detects Repentance+, and defines `OptionType.BOOLEAN`,
  `AddSetting`, and `AddText`. Boolean records use `CurrentSetting`, `Display`,
  `OnChange`, and `Info`.
- [Developer guide](https://github.com/Zamiell/isaac-mod-config-menu/blob/a4c15349c8ed8c38f31bf45bdf5d2896f4e9d23d/docs/quick-start.md)
  documents these fields and makes the consuming mod responsible for persistence.
- [README](https://github.com/Zamiell/isaac-mod-config-menu/blob/a4c15349c8ed8c38f31bf45bdf5d2896f4e9d23d/README.md)
  instructs consumers to check the global rather than loading MCM themselves.

The pack checks the global at load and again at game start for late loading.
No bundled or deprecated MCM variant is loaded.

## Automated checks

Requirements: Lua 5.4 and dkjson (`lua5.4` and `lua-dkjson` on Debian/Ubuntu).
The game supplies its own `json`; dkjson is only a test dependency.

```sh
lua tests/config_spec.lua
lua tests/compatibility.lua
lua tests/void_choice_probe_spec.lua
curl -fsSL https://raw.githubusercontent.com/Zamiell/isaac-mod-config-menu/a4c15349c8ed8c38f31bf45bdf5d2896f4e9d23d/scripts/modconfig.lua -o /tmp/ounp-modconfig.lua
lua tests/config_spec.lua /tmp/ounp-modconfig.lua
find . -name '*.lua' -print0 | xargs -0 -n1 luac -p
```

The configuration contract harness currently passes 19 checks, including nine
independent controls, an older-save migration case and the Void callback gate.
The separate Void test covers disposable-probe state restoration. Optional
source mode executes the upstream registration helpers from OptionType through
AddText, rather than substituting those helpers. It does **not** execute MCM's
rendering/input loop or Isaac. The suite also switches save-slot backing data
without reloading Lua to check that one slot cannot overwrite another's choices
or Continue snapshot. Fixtures test each registered callback gate
independently; soul-heart helper spies verify dispatch isolation, not the
helpers' engine behavior. Existing gameplay bugs remain in scope for issue
#1/#2, not fixed or certified by these tests.

## Executed owner/engine verification

The [results ledger](testing/configuration-results-1.9.7.17.md) records the
2026-11-08/09 Windows session on Repentance+ **1.9.7.17.J460**, production commit
`f1c83253af3636816c3b83c6ab28d2221ad345ea`, and MCM Pure v113. The initial
inspection was vanilla; the later coordinated deployment and mod-enabled tests
are separate evidence. Package inputs, installed-file hashes, backups, settings,
seeds, exact event values and immutable log hashes are recorded there.

Historical issue #3 engine cases exercised: seven controls/defaults; deferred choice versus
active run; exit/relaunch/Continue and fresh-run application; absent MCM; missing
and truncated JSON fallback; distinct-seed save-slot isolation without Lua
reload; and each component disabled with the other six active. Engine comparisons
use Maw damage, Dagger fields, Relic initialization, native Dark Bum rewards,
native chest selection, real Hard-fire explosions and actual Mom-foot damage.
These bounded gate checks do not certify every underlying mechanic's combat,
cadence, probability, character, mode or multiplayer behavior. That broader
compatibility work remains in #1.

For a new session, coordinate deployment with the owner before changing an active
game. Record the production SHA and enabled mods, back up saves/mod configuration,
and use disposable runs. The shared installation remains in use by issue #1;
its current session owner controls further game actions and eventual restoration.

[Console syntax](https://github.com/wofsauge/IsaacDocs/blob/main/docs/tutorials/DebugConsole.md)
and [collectible IDs](https://github.com/wofsauge/IsaacDocs/blob/main/docs/enums/CollectibleType.md)
provide console-assisted item access; no item-access seeds are claimed here.

The following are reproduction and broader comparison recipes, not a claim that
every variant or rate comparison below was executed. Use the ledger's actual
conditions when reusing evidence.

## Issue #16 — Void choice absorption

The config harness checks the ninth saved setting's default, migration,
Continue snapshot and independent callback gate. `tests/void_choice_probe_spec.lua`
checks fixture cleanup for baseline and experimental-detach probe modes. Neither
executes Isaac's native callbacks or establishes Void's absorption behavior.
Use the separate
[Void validation record](testing/void-choice-1.9.7.17.md) for the production
run conditions and acceptance status. Its diagnostic owner observations are
not production feature passes.

1. With pack data absent/backed up, start Isaac. Open MCM with F10.
   Confirm exactly seven On toggles; Nail and Satanic Bible absent. Record logs.
2. Change one toggle Off. Confirm the current run retains its behavior. Exit,
   relaunch, Continue: confirm both the displayed Off choice and the old run's
   On behavior. Start a **new** run: confirm Off behavior. Repeat for each toggle,
   leaving the other six On. Compare against a pack-disabled vanilla run using
   the same item setup; record enabled and disabled outcomes separately.
3. Item setups (one per fresh-run comparison):
   - Maw: `giveitem c399`. Compare damage before/after taking it, and kill enemies
     with the charged ring. Off must add no pack damage or pack black-heart chance.
   - Orbitals: `giveitem c73` (Cube of Meat). Compare contact damage/hitbox across
     separate fresh runs. Off must not double damage/enlarge size. Do not infer
     restoration by toggling during the same run.
   - Stomp immunity: `giveitem c375` (Host Hat), then encounter a stomping enemy
     such as Mom. The executed gate comparison uses Host Hat, `stage 6`, then
     `lua Isaac.GetPlayer(0):UseCard(Card.CARD_EMPEROR)` after the floor loads.
     Verify the actual source; the recorded cases are Mom `45.10`, `Stomp`.
     Separate Pyromaniac `giveitem c223` healing or other stomp-source checks
     belong to broader compatibility coverage; they were not replayed for #3.
   - Humbling Bundle: `giveitem c203`. Clear rooms and inspect naturally selected
     pennies/keys/bombs/full hearts. Do not use forced pickup spawning as proof
     of the pickup-selection callback. Compare a sample against vanilla.
   - Dark Bum: `giveitem c278`, then `spawn 5.10.1` repeatedly for full red hearts
     to feed him (stay at full red health). Observe multiple payouts as Isaac;
     Off must leave payouts unmodified, On dispatches the soul-heart replacement.
   - Relic: `giveitem c98`. Clear successive combat rooms and record payout
     intervals; compare with vanilla. Existing counters are not restored live.
   - Blue fires: on Hard, `spawn 33.2.0`, bomb the fire; repeat across many fires.
     Compare soul-heart payouts with vanilla. This is probabilistic: a single
     missing/present drop proves nothing. Log any Lua error separately from rates.
4. Save at least one Off choice, exit, disable MCM, relaunch and start a new run.
   Confirm pack loads without errors, retains choices and the corresponding
   disabled mechanic; re-enable MCM and confirm its controls reflect the choices.
5. On backed-up disposable pack save data only, test invalid JSON, missing file,
   wrong schema version and individual malformed fields per README fallback.
   Relaunch and confirm defaults; retain logs. Restore the original data after.
6. Save different choices and continued runs in two disposable save slots.
   Switch between them without restarting the game; confirm each slot retains
   its menu choices and run snapshot, then starts new runs with its own choices.
   The harness covers both equal and different seeds, with MCM present/absent.

## Optional issue-specific diagnostics

`tools/validation/build_test_package.py` prepares the pinned runtime, MCM and
separate observer package. `deploy-test-build.ps1` records backups and verifies
installation bytes; use its recorded parameters and hashes from the ledger.
These are development tools, not production loaders or permission to alter a
running game.

The frozen `tools/compatibility-observer.lua` provides `OUPProbe.Start`,
`Snapshot` and `Stop`. Supply the actual deployed SHA, not a newly committed
documentation SHA. Its SHA label is operator provenance; installation hashes
attest bytes. Retrieve verbose JSON from the game log when console output scrolls
off-screen. Repeated `pickup_first_observed` rows in this observer are repeated
updates, so count distinct entities rather than rows.

Four optional files add read-only observers and are loaded explicitly with
`luarun mods/open_unnerf_validation_observer/<file>` after coordinated staging:

| File under `tools/validation/` | Active probe labels | Cleanup |
| --- | --- | --- |
| `dark-bum-pickup-trace.lua` | `DB-off`, `DB-on` | `OUPDBTrace.Stop()` |
| `humbling-bundle-selection-trace.lua` | `HB-off`, `HB-on` | `OUPHBTrace.Stop()` |
| `blue-fire-damage-trace.lua` | `BF-off`, `BF-on` | `OUPFireTrace.Stop()` |
| `stomp-damage-trace.lua` | `ST-off`, `ST-on` | `OUPStompTrace.Stop()` |

They return nil, do not grant items/change damage or RNG, and remove only their
own callback references. Registration alone is not an engine pass. Preserve
ordered event records: Morph can change a pickup seed, selection wrappers may
have index/seed zero, and cancelled damage may hide later-priority observers.
The stomp fixture groups damage events by player/game frame and waits for a
later player-update health observation. Mixed-source frames cannot isolate a
stomp. The blue-fire test counts animation `NoFire` separately: an extinguished
fire can retain 1 HP and `IsDead()==false`, so HP alone miscounts it as burning.

Record observations, actual settings and failures before adjusting a recipe.
For broader statistical/native behavior still pending, see #1 and its matrix.
The general reusable owner-assisted workflow is deferred in #8.
