# Blank Card + Jera

[Technical documentation](README.md) ·
[Player feature](../features/blank-card-jera.md) ·
[Issue #19 ledger](../testing/blank-card-jera-issue19.md)

## Implementation and entry points

- **Module:** `Mods/Blank Card Jera Unnerf/main.lua`, loaded by root `main.lua`.
- **Callback:** `MC_USE_ITEM`, filtered to Blank Card (286).
- **Configuration:** `blankCardJera`, default On, stored through the existing
  version-1 config and per-run snapshot.
- **Checks:** `tests/blank_card_jera_spec.lua` covers the callback contract;
  `tests/config_spec.lua` covers the independent saved toggle and callback gate.

## How it works

For the primary `MC_USE_ITEM` callback, the module requires Jera in the primary
card slot and Blank Card in the reported nonnegative active slot. It invokes
`UseCard(Card.RUNE_JERA, USE_MIMIC | USE_NOANNOUNCER)`, so the engine performs
Jera without consuming the held rune or announcing it. That primary use alone
owns the next-cost update: when the bar is not already four, the module queues
an update keyed by player pointer, run seed and slot. It applies from
`MC_POST_PLAYER_UPDATE` only after native discharge and only when blue reserve is
zero. This avoids the failed approach of reinserting Blank Card during
`MC_USE_ITEM`, which erased stored reserve before discharge. A later non-Jera
use cancels the queued slot update; an active swap or actor seed change is
skipped.

On J460, Car Battery's native repeated active-item callback has slot `-1` and
`USE_CARBATTERY` in its flags. The module accepts one such replay only when that
same player's primary Blank Card use was just recorded in the current update,
the run seed still matches, Blank Card remains in the recorded slot and Jera is
still held. It invokes Jera for that replay but does not schedule another cost
update. Unpaired no-slot callbacks, ordinary mimics and slot swaps remain
ignored. The association is consumed once and cleared on player update, run
start or exit. New-run and exit callbacks also reset the pending cost update.
The callbacks return nil; native charge, animation and Car Battery handling
remain with the game. Global Jera/Clear Rune behavior is unchanged, and player
state is not shared or saved.

The active-slot checks prevent an item mimic from replacing a different active
item. Other cards and consumables, the feature-Off path and charge outside the
matching use remain native. The new Car Battery replay handling has not yet
passed an engine check; see the issue ledger.

## Data and state

The new setting is a normal Boolean in the existing config schema. Existing
normalization makes it default On in older version-1 saves; no schema, mod
identity or save-directory change is needed. MCM edits apply to a new run, and
Continue retains the run snapshot. The callback uses only short-lived per-player runtime state for queued cost
updates and matching a Car Battery replay. It saves no additional state and
shares no mutable state between players.

## Native feasibility and limits

On J460 with REPENTOGON absent, a separate capacity probe used
`AddCollectible(Blank Card, currentCharge, false, usedSlot, 4)` with Blank Card
held and charge 2. The observed ownership count, total collectibles, card,
pedestals, all slot items/charges and battery charge stayed unchanged. A real
battery pickup then filled charge to four, and the verified native smoke used
Blank Card once and discharged to zero. This validates that capacity-update
mechanism in that disposable context; it is not an engine test of this module.

The preceding native transition capture observed Magician's four-charge use,
then Jera consuming the inherited two-charge cost after switching back. The
owner clarified that Jera sets the *next* cost to four, while preserving the
native post-use timing. The capacity probe is exploratory implementation
evidence, not an alternative timing policy.

A bounded production On smoke passed in a fresh one-player Normal run: native
Jera used Blank Card, doubled a penny, battery and closed chest, and a real
battery restored the four-charge bar. A later native battery-smoke passed the
Magician reserve control, Jera next-cost transition and stored-charge sequence;
the Car Battery mode also passed its repeat-count and stored-charge cases. The
broader On matrix passed five cases, then stopped at the room-clear charge
assertion. The v4 tail later passed four ordinary-room clears after advancing
to stage 2. It then attempted an automatic `addplayer 0 1` co-op probe and the
game raised a native exception and wrote a minidump. No co-op, next-run Off or
display result followed. Do not repeat the v3/v4 co-op command. Revision 5
removes automatic player creation; a co-op run without two actors reports
pending and requires the owner to join through native UI or a controller.
The revision-5 helper is now installed through a guarded helper-only update;
production, profile and game data were preserved. The native crash dump was
preserved privately in the session. No further native action is authorized
until the owner chooses the hardware join path.

## Tools and tests

- `lua tests/blank_card_jera_spec.lua`: mocked callback contract; it does not
  simulate native charge behavior.
- `lua tests/config_spec.lua`: configuration persistence and independent gate.
- `tools/validation/blank-card-jera-probe.lua`: passive observer.
- `tools/validation/blank-card-jera-batch.lua`: native input and real battery
  feasibility sequence for a disposable one-player Isaac run.
- `tools/validation/blank-card-jera-capacity.lua`: isolated capacity mechanism
  trial; use only after its recorded preconditions and verified batch.
- `tools/validation/blank-card-jera-on-smoke.lua`: bounded production On smoke
  using a separate empty-room fixture; evidence is in the ledger.
- `tools/validation/blank-card-jera-matrix.lua` and
  `tests/blank_card_jera_matrix_spec.lua`: bounded lifecycle/recharge matrix
  controller and its mock protocol check. The test covers input scoping,
  stored-battery-charge fault detection, the disabled control, cleanup and
  preserving the passive Continue observer; it is not game evidence.
- `tools/validation/blank-card-jera-test-main.lua`: passive diagnostic-mod
  entry that includes the batch and matrix definitions without starting either
  fixture. Matrix revision 3's `battery-smoke` accepts an empty or full bar,
  establishes native Magician four- and two-charge controls, checks Jera's
  inherited reserve and next-four cost, then tests two four-charge uses with
  The Battery. It uses real battery pickups and does not set charges directly.
  A native run must use the ledger's prepared conditions.
- [`../testing/evidence/blank-card-jera-install.py`](../testing/evidence/blank-card-jera-install.py):
  frozen, session-pinned one-time swap recipe. It verifies the saved backup,
  source manifest, executable, protected mods and closed-game condition, then
  moves the original pack aside and rolls back on failure. It does not launch
  the game. The real guarded installation and prelaunch hashes are recorded in
  the issue ledger; the post-launch installed-file hash check was not done.
- `tools/validation/stage-source-pack.py` and
  `tests/stage_source_pack_spec.py`: stage a hash-pinned runtime tree from raw
  GitHub files into a new directory outside the game. Supply a pinned manifest,
  its SHA-256 and an output path, for example:
  `python tools/validation/stage-source-pack.py --manifest <manifest.json> --manifest-sha256 <sha256> --output-dir <outside-game-directory>`.
  The helper verifies file paths, sizes, hashes, metadata identity and XML; it
  never installs or launches the package. The existing
  `tools/validation/deploy-test-build.ps1` targets an older test folder and
  observer/MCM contract, so it is not the installer for this candidate. Any
  later installation needs a separate guarded procedure with the game closed,
  a fresh backup and exact installed-byte checks.
- `tests/blank_card_jera_on_smoke_spec.lua`: controller-protocol stubs for
  setup, native-use witness, failures, cleanup and refusing foreign pickups;
  stubs do not establish game behavior.

The On smoke script must run only in a fresh Normal Isaac run with the feature
On, no existing pickups, and a cleared starting room. It supports Isaac's D6 or
an empty active slot, and requires the separate batch mod's
`OUPBlankCardBatch` global to be loaded. Invoke once with
`luarun mods/oup_blank_card_issue19_observer/blank-card-jera-on-smoke.lua` after
the verified package and diagnostic files are staged. The fixture grants
Blank Card and Jera in the disposable run, places a penny, battery and closed
chest away from the actor, and delegates the single use and battery refill to
the native batch. It checks that each pickup is doubled, Jera is dispatched once,
the rune and single Blank Card remain, and charge returns to four. It removes
pickups only under the empty-room precondition. The one-player Normal On smoke
passed the behavior checks. Same-frame pickup cleanup was inconclusive because
native removal is deferred; this is one engine smoke, not full feature acceptance.

The matrix fixture is also disposable-run tooling. Its `Run(mode)`, `Status()`
and `Stop()` interface supports `battery-smoke`, `car-battery`, `on`, `finish-on`,
`off`, `co-op`, `prepare-continue` and `continue`. The full On matrix covers native ordinary
pickup doubling, three battery-fed cycles from one initial battery, Jera/Magician
and other-rune transitions, Schoolbag swaps, four mapped hostile-room clears,
a bounded co-op check, and saving next-run Off while the
current run stays On. The Off mode checks native Jera behavior; Continue must
follow a real relaunch so the passive game-start observer can record the
continued flag. Co-op can report pending if no second actor appears. It never
writes charge or room-clear flags; it uses native input, pickups, consumables,
room changes and NPC deaths. Room/map changes cannot be undone inside that
disposable run, and Schoolbag/D6 or a created second actor may remain for profile
restoration. The matrix protocol mock has passed local checks. Revision 3 releases its
synthetic action pulse on the first observed native item-use callback, and
snapshots record battery-passive counts. Its `battery-smoke` validates native
Magician controls, Jera's inherited charge and next-four cost, and two Jera uses
with The Battery. The native battery-smoke and Car Battery modes passed as
recorded in the ledger. Revision 4 adds `finish-on` for the unrun tail so the
five accepted On cases do not need replaying. It returns to the floor's starting
room, then runs only room clears, co-op and next-run Off. The ordinary-room
selector filters for unvisited ordinary combat rooms with
`Data.Shape == RoomShape.ROOMSHAPE_1x1`; it checks `GetRoomShape()` at runtime
and logs the stage, shape and charge transition. Four candidate rooms do not
guarantee four hostile rooms because populations are seed-dependent; the fixture
stops if it cannot clear four within its bounds. The mode records the initially
current room's shape and stage before parking in the floor's starting room, to
investigate the prior charge-jump assertion without asserting a cause.

`finish-on` does not repeat or remove drops in the previously failed room. It
requires the starting room to be empty. If the current map has fewer than four
unvisited 1×1 combat rooms, the fixture may advance to stage 2, then stage 3,
before it discharges Blank Card. Those floor changes are native and affect the
disposable run; the fixture does not set charges or room-clear flags. Mock
protocol checks pass for a map with a 2×2 room ahead of four 1×1 rooms, and for
the documented stage fallback when only three small rooms are available. In
the mock, the 2×2 room is skipped, four 1×1 rooms clear, the single-player
co-op result stays pending, and next-run Off is recorded. The v4 native run
confirmed the initial room was shape 9 and stage 1, then cleared four ordinary
shape-1 rooms on stage 2, recharging Blank Card from zero to four. The automatic
co-op probe immediately afterward crashed the game. Revision 5 forbids
`ExecuteCommand` except for the documented stage fallback; with one player it
reports a pending native join and does not use an item or alter charge. Its
local spec also checks the full-charge and empty-bar paths and next-run Off
protocol. A frozen helper-only updater archives the unsafe diagnostic generation and
installs revision 5 while preserving the production mod and profile/data files.
The guarded update is complete; do not run archived v3/v4 helper paths. Any
future native co-op join must use owner-selected UI or controller input.

The `car-battery` mode requires a cleared disposable Isaac room, Blank Card at
four charge, and neither The Battery nor Car Battery already held. Invoke
`OUPBlankCardMatrix.Run("car-battery")` once, inspect with `Status()`, and
follow the batch's console-close prompts. It first uses native Magician to
measure Car Battery's repeat count, then checks Jera at the inherited two-cost
bar and the next four-cost bar. It compares a single Jera bar's penny doubling
to the native repeat count, then checks both passives with charge moving 8→4→0
and the corresponding native penny counts. This mode passed its native
compatibility checks; the ledger records its evidence. Other matrix criteria
remain pending.

The pinned v2 candidate manifest is
[`blank-card-jera-runtime-v2.json`](../testing/evidence/blank-card-jera-runtime-v2.json),
source commit `0e1c6e4215d629675cd8f32be468eaf7f4cba640`, 22 files, SHA-256
`db9bac3a7d797b621df6656660024ac3890ec75d21d5f8e2263fb21470803e7a`. Its
one-session upgrade recipe
[`blank-card-jera-update-v2.py`](../testing/evidence/blank-card-jera-update-v2.py)
reuses the frozen guarded swap inventory, archives the previous candidate and
diagnostic helper, preserves the pre-test original pack, and rolls back if
helper installation fails. A synthetic success and injected helper-write
rollback passed locally. The recipe does not start the game; profile and game
data remained unchanged in that local smoke.

See the [issue-specific ledger](../testing/blank-card-jera-issue19.md) for
session provenance, hashes, evidence and remaining acceptance work.

---
*Last updated: 2026-11-15*
