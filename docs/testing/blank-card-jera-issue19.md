# Blank Card and Jera — issue #19 validation

[Technical documentation](../agents/README.md) ·
[Issue #19](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/19)

## Status

**Production implementation is present; native validation is partial and
acceptance is pending.** A bounded production On smoke has passed in a
disposable run, but no feature acceptance pass is claimed. The owner clarified
the intended timing: preserve Blank Card's
native post-use charge behavior; using Jera sets the cost of its next activation
to four. Do not set four on card selection or grant free charge. The original
“four charges per activation” criterion is superseded. The first Jera use after
Magician may consume the inherited two-charge cost; the subsequent Jera use
should cost four. Four ordinary room clears after Jera, battery and other native
consumable interactions, item swaps, a fresh disabled run and the charge display remain required
checks. The two-player isolation, current-On/next-run-Off and cold Continue
checks have since passed in the captures below.

### Reserve-loss defect and pending correction

The first native `battery-smoke` exposed a defect in the candidate implementation:
with Blank Card at 4 and blue reserve at 4, the Jera use callback reinserted
Blank Card before native discharge. The native `card_use` still showed 4+4,
but the subsequent item-use state was 4+0 and the sequence ended at 0+0. The
matrix captured its failed reserve assertion as JSON; an empty collector
`errors[]` is not a pass.

- Failed-candidate source: `4563fd522e3086817c21fc89f1677f63262fc53c`;
  module SHA-256 `c138df684c4ad5e6102522bcb089472bd2b1f10ff82722861bff99174057beff`.
- Capture: `capture-battery-smoke-20261115T161856Z`; seed `2358805276`, actor
  `2488244009`, fixture frames 352–416. Initial real battery
  `2352474404` established 4+4 before the use at frame 398.
- Stable log: 30,200 bytes, SHA-256
  `ba27264c39847bc86e237b885ab961c72502cbfa137c76a73041179900b96e71`;
  32 records, SHA-256
  `6e8b49201f97ae75ccb25f9c95df2f9480f76ca81f046e3117cb3740e678d4d6`, zero
  malformed records. Starting pickup count was zero, confirming prior deferred
  pickup cleanup had completed.

The current source queues the cost-four metadata update by player pointer,
run seed and slot, then applies it on `MC_POST_PLAYER_UPDATE` only when blue
reserve is zero. Later non-Jera use cancels the pending slot; changed active
items or actor seed are skipped; run start and exit reset pending state. It
does not reinsert a charged bar before native discharge. Callback and matrix
protocol specs pass locally, but this correction has not been tested in the
game. The next engine entry is the passive
[`blank-card-jera-test-main.lua`](../../tools/validation/blank-card-jera-test-main.lua),
which loads the batch and matrix definitions without starting a fixture. Its
`battery-smoke` mode must establish Magician's native two-charge bar plus
reserve, retain that reserve through Jera, and demonstrate four-charge capacity
through real battery refills and two following Jera uses. No engine pass is
claimed for the correction.

## Observer and contract check

- Observer: [`blank-card-jera-probe.lua`](../../tools/validation/blank-card-jera-probe.lua),
  SHA-256 `618b4dc011c56befffcf5329dd1b8d776785f78463598b3773f86d7a945c1c1a`.
- Harness: [`blank_card_jera_probe_spec.lua`](../../tests/blank_card_jera_probe_spec.lua).
- `lua tests/blank_card_jera_probe_spec.lua` passes locally. This establishes
  the observer contract only, not native Blank Card behavior.
- Collector: [`collect-blank-card-profile.py`](../../tools/validation/collect-blank-card-profile.py).
  It preserves the raw log, exact-prefix JSON records and malformed payloads,
  with source metadata and two-read hashes. A raced capture is diagnostic only.
  Its smallest local smoke passed raw-byte preservation, JSON extraction,
  malformed retention and error reporting. The first native capture passed
  stable-copy and parser checks below.
- It loads as a separate diagnostic mod and starts observing automatically.
  `OUPBlankCardProbe.Snapshot(label)` emits a labeled snapshot;
  `OUPBlankCardProbe.Stop()` removes its exact callbacks.
- Log records use the `OUP_BLANK_CARD` prefix. They include per-player
  collectible/card/pill/slot state and native use callback arguments. The
  `MC_USE_ITEM` observer is filtered to Blank Card (286) and returns nil, so
  native effect and discharge handling remain with the game.
- It does not grant items or cards, write charge, change configuration or
  persistence, or create a gameplay fixture. The harness tests only loading,
  snapshot/use logging, state-change deduplication and exact cleanup. It does
  not simulate native charge behavior or establish game evidence.
- There is no native maximum-charge API in this observer; it records charge,
  battery charge and `VarData` at use as observations, not as a complete native
  charge model.

## Bounded native feasibility batch

- Batch: [`blank-card-jera-batch.lua`](../../tools/validation/blank-card-jera-batch.lua),
  SHA-256 `febcb67b030d00bc8556c423b01509c7a8e36f766104371a30a9c95c5c30f794`.
- Contract harness: [`blank_card_jera_batch_spec.lua`](../../tests/blank_card_jera_batch_spec.lua).
  The local protocol checks use mocked input and battery collection; they are
  not evidence of native input, charge or recharge behavior.
- Staged at `mods\oup_blank_card_issue19_observer\blank-card-jera-batch.lua`;
  staged bytes match the source SHA above. Load it once with
  `luarun mods/oup_blank_card_issue19_observer/blank-card-jera-batch.lua`.
  Then use `OUPBlankCardBatch.Run()` for the smoke, `Status()` to inspect its
  result, and `Stop()` for owner-directed cleanup. Run the `transitions` mode
  only after the one-use smoke is accepted.
- The batch is restricted to one Isaac in a cleared disposable room, Blank Card
  in the primary slot, and no Car Battery. It applies Jera in the disposable
  run, requests the native item action through a scoped input callback, and
  refills with a real spawned battery pickup. It does not call `UseActiveItem`
  or write charge. The transition mode switches to Magician and back to Jera.
  It may leave the disposable run's card, items, runes and effects changed.
- The batch requires exactly one observed native use for each requested action.
  Native input polling may invoke the input callback repeatedly; this strict
  use-count expectation was checked in the engine for the captures below.

## Native feasibility captures

The single-use smoke passed in the one-player Normal Isaac run, seed
`3170816660`, player seed `2828316171`, frames 383–450. With Blank Card (286)
held, Jera (33) produced exactly one native use at frame 389; charge went from
4 to 0, flags were 4 and `VarData` was 0. A real battery pickup
(`2578582492`) restored charge to 4. No Jera `MC_USE_CARD` event was observed.
The main agent cross-checked the raw capture before accepting this bounded
fixture result.

- Capture: `capture-20261114T145101990Z` (session-relative); log 23,845 bytes,
  SHA-256 `c8a6fb6f7a8f2371cb42f0f212d7e155e818e0695a03ad586caa8b35ac038f67`.
- Parsed records: 17, SHA-256
  `dfad0f49cde4c2d7f9e037064627d5c616c7f1ff3b569bdfd75d4215146607d5`; stable
  two-read capture, zero malformed records or matching errors.

The transition batch on the same actor and seed continued through frame 883.
Magician (2) used at frame 756 and reduced charge 4→0; a real battery pickup
(`909118380`) restored 2. After switching back to Jera, its use at frame 822
also reduced charge 2→0; battery `1642800875` restored charge to 2. The batch
completed with three observed uses total, one Blank Card, and no Lua errors.
This records that the first Jera use after Magician retained the prior
two-charge cost. It does not establish a cost on card selection or implement or
validate the owner's clarified next-use timing.

- Capture: `capture-20261114T135331Z`; log 33,681 bytes, SHA-256
  `b8a6f1eda55b31560ccdbe9b005d550913b0dee5d3adfa388814b40a4e13e56e`.
- Parsed records: 46, SHA-256
  `8b3dbebb265a719e3e82f395288174e7f2e9f3b13163176d5ed5daa892ed8ed2`; stable
  capture, no malformed records or matching errors. Installed batch and probe
  hashes matched their sources. A failed first collector attempt was recovered
  by capture without replaying the game sequence.

The use callback's `VarData` was 0 in these observations and is not a native
current-maximum-charge getter. A separate capacity probe,
[`blank-card-jera-capacity.lua`](../../tools/validation/blank-card-jera-capacity.lua),
and its protocol harness
[`blank_card_jera_capacity_spec.lua`](../../tests/blank_card_jera_capacity_spec.lua)
are available as an API mechanism trial, not a final cost-timing proposal. It is
staged at `mods\oup_blank_card_issue19_observer\blank-card-jera-capacity.lua`
(5,818 bytes), SHA-256
`4bf95fe188043b1243027fa45a02e6b9e0caa819df548ca1c1d3dd545e575f68`; the
session's `capacity-staging.json` records the staging. Mocked accessor/grant
and invariant checks pass locally.

The J460 mechanism trial started with Blank Card/Jera and charge 2. The
`AddCollectible` path with next cost 4 left ownership count 1, total collectibles
1, Jera, zero collectible pedestals and all active-slot item/charge/battery
values unchanged. API inspection found no `SetActiveVarData`,
`GetActiveItemDesc`, `GetActiveMaxCharge` or `SecondaryActiveItem`; `NeedsCharge`
was present. A real battery (`4226919018`) filled the item to four, the native
smoke used it once and drained it to zero, and a second battery (`1066954075`)
filled it to four again. This tests the capacity mechanism in that disposable
setup; the production callback and the owner's intended next-use timing remain
unvalidated in the game.

- Capture: `capture-20261114T150500Z`; log 39,352 bytes, SHA-256
  `3946db88a56575778839e6690ff72cce4231c7a6c7d7c7345af516de324aa134`.
- Parsed records: 62, SHA-256
  `d2fbd2cda707d700b33979ea36a9995df331ac72616a7270650f48aedd49efe3`; stable,
  zero malformed records or matching errors. The latest collector verified the
  session download hash; the installed-file hash was not independently checked.

## Production On smoke and candidate staging

- On-smoke fixture:
  [`blank-card-jera-on-smoke.lua`](../../tools/validation/blank-card-jera-on-smoke.lua).
  Source SHA-256 `8e6fb7c87996b5cdf009e46aff5c732fb8f24a54b585a48317cb0941a807a130`.
  Its protocol harness is
  [`blank_card_jera_on_smoke_spec.lua`](../../tests/blank_card_jera_on_smoke_spec.lua);
  local controller stubs cover setup, witness handling, failure cleanup and
  foreign-pickup refusal, not Isaac gameplay.
- The fixture requires a fresh Normal Isaac run, one player, the feature On, a
  cleared starting room with no pickups, and D6 or an empty active slot. The
  separate `OUPBlankCardBatch` diagnostic must already be loaded. It grants
  disposable Blank Card/Jera, positions a penny, battery and closed chest away
  from Isaac, then delegates the native use and battery refill to the batch.
  It checks the native Jera use, each pickup doubling, unchanged Jera/Blank Card
  ownership and a four-charge refill; cleanup removes pickups only after the
  empty-room precondition.
- Source stager: [`stage-source-pack.py`](../../tools/validation/stage-source-pack.py),
  SHA-256 `3e90769bf976e4d873f1e588a87a58e8a9d0cc84684c58d6a49d51717af0ea2a`;
  protocol harness:
  [`stage_source_pack_spec.py`](../../tests/stage_source_pack_spec.py). The
  helper stages a manifest-pinned runtime tree from raw GitHub files into a new
  directory outside the game. It verifies its source commit, path allowlist, file
  sizes and hashes, metadata identity and XML. It does not install or launch
  Isaac. Its local smallest-case smoke passed exact-byte, safe-path,
  overwrite-refusal and hash-rejection checks. The 22-file runtime manifest
  [`blank-card-jera-runtime.json`](evidence/blank-card-jera-runtime.json) pins
  source commit `4563fd522e3086817c21fc89f1677f63262fc53c`, SHA-256
  `b7026ac330ca2ebc11c5b741d6b9ebb9ed7e27c33aca3d3a36c5708502afd481`. Local
  staging was verified against exact Git-object bytes. The pinned 22-file
  candidate was later installed by the guarded recipe below; all 22 installed
  file hashes matched before launch. No post-launch installed-file hash check
  was performed. The
  existing `deploy-test-build.ps1` has an older test folder and observer/MCM
  contract and is not a direct installer for this candidate. Any later
  deployment needs a separate guarded install with a fresh backup, closed game
  and installed-byte verification.
- Frozen one-session swap recipe:
  [`blank-card-jera-install.py`](evidence/blank-card-jera-install.py),
  SHA-256 `93d073fe8e621fc130d4be7303315c8f679150141a6bbc42499f6665a9a37470`.
  It pins the session backup and runtime manifest hashes, verifies the executable
  and protected mod files, checks that Isaac is closed, then moves the original
  pack aside and swaps in the candidate with hash checks and rollback handling.
  Its synthetic local smoke passed; the recipe does not edit profile or game
  data or launch Isaac. The actual guarded installation passed its prelaunch
  checks. The original pack remains archived at `session/original-pack`; the
  profile, game data and unrelated mods were unchanged by installation.

The production On smoke passed in a fresh Normal Isaac run on source runtime
`4563fd522e3086817c21fc89f1677f63262fc53c`: seed `2358805276`, player seed
`2488244009`, Normal difficulty `0`, `continued=false`, J460, REPENTOGON absent,
MCM v113, frames 85–153. At frame 91, the production use dispatched Jera once
with flags 384. Penny (variant 20), battery (90) and closed chest (50) each
increased from one to two; Jera (33) and one Blank Card remained. Charge moved
4→0 and a real battery (`2692350394`) restored it to 4. The run completed at
frame 153 with no matching errors.

- Capture: `capture-20261115T-test` (session-relative); log 24,659 bytes, SHA-256
  `acc87b3aec710ebdbcdddef735185c1cedf3f8f70e0893273a6b6cbdd57f2576`.
- Parsed records: 20, SHA-256
  `33f71e81cc48c845414b1483bc02bf0d15b1a22e14f18b165ed4124da05b2d8c`; stable,
  zero malformed records or matching errors.

The fixture removed its pickups and logged the remaining count in the same
frame: six pickups were still visible. Isaac defers native entity removal, so
this is inconclusive cleanup evidence, not a confirmed failure or a zero count.
The matrix preflight must verify that the room is empty before reusing it; do
not replay the smoke. The installed-file hash check after launch was not done.
The separate passive batch mod is at
`mods/oup_blank_card_issue19_batch/main.lua`, unchanged from the verified batch
SHA above; the passive observer main is unchanged. `acceptance-staging.json`
preserves the staging record. Cleanup and profile restoration remain pending.

### Candidate v2 production On smoke — basic behavior pass

The owner ran the installed v2 candidate in a fresh Normal Isaac run: source
`0e1c6e4215d629675cd8f32be468eaf7f4cba640`, module SHA-256
`81234e4d8e697b4fb6379369263c16676334b2a5f554e7f71a709c4152e8f3fa`. Startup
was J460/MCM v113 with REPENTOGON absent, seed `2855396759`, player seed
`483707137`, Isaac type `0`, Normal difficulty `0`, and `continued=false`.
At frame 8 the fixture had one Blank Card (286), Jera (33), base charge 4,
blue reserve 0, and one penny, battery and closed chest. A single native use at
frame 14 used flags 4 and slot 0; one Jera dispatch at frame 14 used flags 384.
Each pickup doubled from one to two, and the rune and single Blank Card remained.
Charge moved 4→0; real battery `1657471443` restored it to 4 by frame 59/75.
The batch completed at frame 75 and the On smoke at frame 76 with one use and
one Jera dispatch. This confirms basic On duplication, held rune, and native
4→0→4 battery recharge for this run only.

- Capture: `session/capture-v2-on-smoke-20261115T172307Z`; stable 25,203-byte
  log, log/second-read SHA-256
  `5f3dd444acabc1b1c3a35618dcd2fe247007e777b737a577a8a5f9b8ef69f347`.
- Parsed records: 21, SHA-256
  `ab3da2e2359d51663d325c8215a908d451763de4e1b82e88e20fb691adefe8b7`, zero
  malformed records and no collector errors. The owner cross-checked the raw
  collector output.

The fixture logged six pickups remaining in the same frame as its removal
request. Native removal is deferred, so cleanup is inconclusive until a later
empty-room preflight; do not count the six as a confirmed cleanup failure or
claim they were removed. The stored-battery and post-use cost-transition cases
were later covered by the v3 battery-smoke below. Car Battery, slot changes,
room-clear recharge, Continue, Off and co-op remain pending. No feature
acceptance pass is claimed.

### Candidate v2 stored-battery run — fixture error, observations retained

The next run used the same installed v2 source and matrix (`1d5b33b…`). At
matrix start, the room had zero pickups. A real Battery pickup
(`4011573285`) produced base charge 4 plus blue reserve 4. One requested Jera
activation at frame 306 produced two native item-use callbacks in that same
frame and two Jera dispatches: the first began at 4+4, and the second at 4+0.
The first native discharge therefore retained the spare four charges. The
matrix then reported `Unexpected native item-use count: first_overcharged_jera`
at frame 324, before recording any case as passed. The terminal is a handled
`matrix_error` record; collector `errors[]` being empty does not make the run a
pass. Cause of the repeated native use is unresolved; the fixture's input pulse
may have remained active across native queries, but this is only a hypothesis.

- Capture: `session/capture-v2-battery-20261115T172654Z`; stable 32,393-byte
  log, both-read SHA-256
  `55126274bf20113c88bf15613f68e657bfaa4a8c46e0123508d73e5a69fd920f`.
- Parsed records: 37, SHA-256
  `43f15298493cd6a826dca2670e78713cdb536407f50e52a69f8bd6a8560f612c`, zero
  malformed records and no collector `errors[]`. Owner's “complete” report
  describes the run ending; the raw capture records the matrix error. The
  temporary Battery was removed by fixture error cleanup, explaining its
  absence afterward; that does not indicate a passed battery case.

The capture used seed `2855396759` and actor `483707137`, matching the v2 On
smoke. It confirms the initial native reserve was retained by the first
discharge, but not the complete Battery sequence. Revision 3 later released the
synthetic pulse on the first native use; the successful v3 battery-smoke below
shows the repeated-use fixture error did not recur in that run. This supports
that fixture change but does not prove the previous root cause. Car Battery,
slots, room clears, Continue, Off and co-op remain pending.

### Matrix fixture revision 3 — local protocol check

The revised matrix releases its synthetic action pulse as soon as the first
native `MC_USE_ITEM` callback arrives. This prevents later same-frame input
queries from issuing another synthetic press while still allowing native Car
Battery repeated-use callbacks to be counted. Snapshots now include The Battery
and Car Battery inventory counts, the start record labels `fixtureRevision=3`,
and `Status()` prints the mode, state and error on one line. This responds to
the observed repeated native use; it does not prove the cause was the old pulse
handling.

The revised `battery-smoke` accepts an empty charge bar and recovers with a real
battery pickup. It first verifies native Magician's 4→0 behavior and a 2+2
reserve control that spends 2→0. It then tests Jera with that inherited
two-charge bar, verifies the next capacity is four after real refills, spends
8→4→0 across two Jera uses, removes The Battery and refills the remaining
four-charge bar. The protocol spec also checks the empty-start path, all three
input hooks released on the first native use, Car Battery callback counting,
fault detection and passive cleanup. `lua tests/blank_card_jera_matrix_spec.lua`
passes locally. The owner staged v3 as
`mods/oup_blank_card_issue19_observer/matrix-v3.lua` and loaded it once with
`luarun mods/oup_blank_card_issue19_observer/matrix-v3.lua` in the existing
stopped diagnostic session. The resident v2 game-start observer remains loaded;
a cold game start will be required to load the updated helper before Continue
validation. Native v3 results follow.

### Candidate v2 battery-smoke with matrix revision 3 — three cases passed

The staged matrix was 25,146 bytes, SHA-256
`21bce95185f01034b64c24c39935fabc12755d91f9bbbd3a87a3470dc31afc45`; staging
is recorded in `matrix-v3-staging.json`. This diagnostic-only Lua update was
loaded with `luarun`; there was no game restart or production-module reload.
The production source remained `0e1c6e4215d629675cd8f32be468eaf7f4cba640`
(module SHA-256
`81234e4d8e697b4fb6379369263c16676334b2a5f554e7f71a709c4152e8f3fa`).

The raw capture, cross-checked by the main agent, records all three matrix
cases passing at terminal frame 931: `native_magician_stored_charge_control`,
`stored_charge_across_cost_transition`, and `stored_battery_charge`. It used
seed `2855396759` and actor `483707137`, the same pair as the v2 On smoke. The
native Magician control demonstrated 2+2→2→0. With Jera, the inherited 2+2 bar
retained two charges; real battery refills established the next 4+4 bar. One
Jera use at frame 850 left base 4/blue 0 by frame 868, and the next use at
frame 870 left 0+0 by frame 888. After The Battery was removed at frame 888, a
real battery restored the base bar to four by frames 915/931. Terminal state
was one Blank Card, Jera held, full base charge 4, blue charge 0, and no The
Battery or Car Battery. The v3 fixture passed the intended reserve and
next-cost checks for this run. This does not validate Car Battery or the
remaining issue matrix.

- Capture: `session/capture-v3-battery-20261115T174224Z`; stable 62,531-byte log,
  both-read SHA-256
  `2c0a9de50d875f0c6961205a991386c5659c3265ea137b3d010ee97ef0b8800b`.
- Parsed records: 104, SHA-256
  `7209d41391536379a077d89c4c4dfa8d1b60f0ad21cec4aa0a0ef67ac2e2c55c`, zero
  malformed records and no collector errors. The earlier v2 matrix error at
  frame 324 remains preserved above as historical evidence, not as a v3 failure.

### Candidate v2 Car Battery mode — native replay observed, case failed

The next capture used source `0e1c6e4215d629675cd8f32be468eaf7f4cba640`
(module SHA-256
`81234e4d8e697b4fb6379369263c16676334b2a5f554e7f71a709c4152e8f3fa`) and
matrix revision 3, SHA-256
`21bce95185f01034b64c24c39935fabc12755d91f9bbbd3a87a3470dc31afc45`. It used
the same seed `2855396759` and actor `483707137`. With Car Battery owned and
The Battery absent, native Magician generated one primary use (slot 0, flags 4)
and one Car Battery replay (slot -1, flags 1569) at frame 1231. The two card
effects spent one four-charge bar, and a real battery pickup
(`4228872983`) restored charge to two. After switching to Jera (33) at charge
2, the primary use at frame 1297 (slot 0, flags 4) dispatched Jera once. The
native Car Battery replay was also observed at frame 1297 (slot -1, flags 1569,
`VarData=2`), but the installed module's negative-slot guard ignored it. The
matrix ended with `Unexpected Jera activation count: car_battery_inherited_jera`
at frame 1315 and `cases=[]`; this Car Battery case did not pass. The error
snapshot still showed Car Battery owned before fixture cleanup detached the
helper and removed its temporary passive. That cleanup explains later absence;
it does not establish success.

- Capture: `session/capture-v3-car-battery-20261115T182841Z`; stable 74,958-byte
  log, both-read SHA-256
  `f259ddf29c35a75d9959ddef99a59448c5c5ed807a0225664c4a8fd434397795`.
- Parsed records: 131, SHA-256
  `c549b0178ab561bff3126fcafdc2c17a3fe11908dacbc08c76f0c2bffa805dc6`, zero
  malformed records and no collector errors. The main agent cross-checked the
  raw capture.

The bb2d source associates the primary Blank Card use with one Car Battery
replay for the same player update. It accepts the no-slot callback only when
`USE_CARBATTERY` is set and the player seed, recorded owning slot, Blank Card
and held Jera still match; it then dispatches Jera once and consumes the
association. Only the primary callback schedules the next-four cost. Unpaired
no-slot calls and other mimics remain ignored. The association clears on player
update, run start and exit, and the reserve-safe cost update is unchanged.
Callback mocks cover charge 2/4, all four slots, one replay per primary use,
mismatches and cleanup. The native validation for this fix passed in the Car
Battery mode recorded below; other acceptance cases remain pending.

## Bounded lifecycle matrix

- Matrix: [`blank-card-jera-matrix.lua`](../../tools/validation/blank-card-jera-matrix.lua),
  SHA-256 `4c0e8cab8f3e426f1509df378107e203de4624c4d7a2c4080d38c8ad4e833db4`
  (27,012 bytes; fixture revision 5).
- Protocol spec: [`blank_card_jera_matrix_spec.lua`](../../tests/blank_card_jera_matrix_spec.lua).
  Local checks cover scoped input, stored-battery-charge success and deliberate
  fault detection, disabled native control, exact callback removal and survival
  of the passive Continue observer. They are mock protocol checks, not engine
  proof.
- Modes: `battery-smoke` establishes native Magician controls, tests Jera's
  inherited reserve and next-four cost, then checks two Jera uses with The
  Battery; `car-battery` first measures native Car Battery's repeated Magician
  effect, then compares Jera's
  repeat count with a single bar and tests inherited two-cost to next-four
  timing. It then checks The Battery plus Car Battery through 8→4→0 charge and
  native penny doubling. Each mode step is reported separately in the fixture
  status. `on` covers ordinary
  pickups, three battery-fed cycles from one initial battery, card transitions,
  other-rune passthrough, Schoolbag swaps, four mapped hostile-room clears, a
  bounded co-op command experiment, and changing MCM to next-run Off while the
  current run stays On. `finish-on` resumes only room clears, co-op and next-run
  Off after the five previously passed On cases. `off` is the native control;
  `co-op` reports pending until a second actor joins through owner-selected
  native UI/controller input; `prepare-continue` saves next-run Off; `continue` requires
  the passive observer to confirm a real continued run.
- The v5 matrix protocol spec passes locally, including 2×2-room exclusion,
  four ordinary 1×1 clears, short-map stage fallback, and a pending single-player
  co-op result with no automatic player command. Native v3 `battery-smoke` and
  `car-battery` passed their recorded cases. The native On matrix passed five
  cases before the room-clear exact-charge assertion stopped it. Native v4
  subsequently passed the four-room recharge case; its following automatic
  co-op command crashed the game. The separate safe v5 co-op and current-On/
  next-run-Off checks have now passed with owner-joined players. A real cold
  Continue has also passed; fresh disabled behavior, charge display and
  remaining acceptance checks stay pending.
  The earlier v2 repeated-use error
  is historical, not a v3 failure. These fixtures use
  native input, repeated use and real pickups; they do not write charge or
  room-clear flags. Room changes and NPC kills cannot be undone inside the
  disposable run. Schoolbag, D6 or a second actor may remain for profile
  restoration; co-op now requires owner-joined actors and never creates a
  player automatically. The battery-smoke and full matrix require their documented prepared, empty-room
  conditions.

## Candidate v2 staging record

- Manifest: [`blank-card-jera-runtime-v2.json`](evidence/blank-card-jera-runtime-v2.json),
  pinned to source commit `0e1c6e4215d629675cd8f32be468eaf7f4cba640`, 22 files,
  SHA-256 `db9bac3a7d797b621df6656660024ac3890ec75d21d5f8e2263fb21470803e7a`.
- Upgrade recipe:
  [`blank-card-jera-update-v2.py`](evidence/blank-card-jera-update-v2.py).
  Its synthetic swap smoke passed, including injected helper-write rollback.
  It archives the previous candidate and helper while preserving the original
  pre-test pack. The recipe's SHA-256 is
  `47ec2a86c1234f2412eaeebbc87069e2db95baaa07dc8b3f11fde7a9ff0cc354`.

### Candidate v2 installation and audit

Candidate v2 is installed in the game mods folder; no v2 gameplay tests have
run. Isaac was confirmed fully closed before the frozen updater ran. The update
journal is `session/candidate-update-v2.json`: it records source `0e1c6e4`, 22
runtime files, no game launch and no profile or game-data writes. The archived
candidate from source `4563fd5` is at
`session/candidate-used-4563fd522e30`; diagnostic helper generation 1 is
preserved at `session/diagnostic-generation-v1`. The original pre-test pack
remains unchanged and was verified against `before.json`.

A first post-install audit attempt used an incorrect verifier schema and
invented helper paths; this was an audit-tool error, not a product failure. A
corrected read-only audit then matched the exact 22-file runtime set, sizes and
hashes against source `0e1c6e4`, and verified the original archive, previous
candidate and helper files. Key installed hashes: production module
`81234e4d8e697b4fb6379369263c16676334b2a5f554e7f71a709c4152e8f3fa`, passive
loader `bfec07380b1d3f98e942b17207e78661e1b82c63dfa1a4dc9f4b15ab2fe5dca0`,
batch `febcb67b030d00bc8556c423b01509c7a8e36f766104371a30a9c95c5c30f794`,
matrix `1d5b33b01aba1fcd7d0484665e16b798696184a21e7f92c5071510dec106cd2f`,
and passive observer `618b4dc011c56befffcf5329dd1b8d776785f78463598b3773f86d7a945c1c1a`.
The On-smoke fixture is installed as
`blank-card-jera-on-smoke.lua` (SHA-256 begins `8e6`). The audit confirmed the
Isaac process was absent. Installation and byte audit do not establish gameplay
behavior; corrected-module smoke and all other v2 engine cases remain pending.

### Candidate v3 cold update — installed and audited

- Runtime manifest: [`blank-card-jera-runtime-v3.json`](evidence/blank-card-jera-runtime-v3.json),
  pinned to source `bb2d0587b1d018c82e3abc9f75928e3e29d8fb6f`, 22 runtime files,
  SHA-256 `4e4e49ed5bf0bef57c5dee9e8393d0b7b95d432bd62e182a306876f4d51a6c4d`.
  The only runtime difference from v2 is `Mods/Blank Card Jera Unnerf/main.lua`
  (3,421 bytes; SHA-256
  `6beb2862bad6a5feb083b7d9b4fbabc017ee936bf054c53b9a9ab166229b2025`). The
  maintained stager verified all 22 files against pinned Git-object bytes.
- Cold-update recipe: [`blank-card-jera-update-v3.py`](evidence/blank-card-jera-update-v3.py),
  SHA-256 `b30bd2a370e9172295428d4e66b22ed408803f444860c9a312872bf2222682ba`.
  It reuses the frozen installer inventory and swap, archives the v2 candidate
  as `candidate-used-0e1c6e4215d6` and the full current helper generation as
  `diagnostic-generation-v2`, then updates only the autoloaded helper's
  `matrix.lua` to the validated revision-3 bytes. Synthetic success and injected
  helper-write-failure rollback both passed while preserving failed generations,
  the original pack and protected mods. The recipe does not change profile or
  game data.

Isaac was confirmed closed before the frozen updater ran; it exited 0. Journal:
`session/candidate-update-v3.json`. The v2 candidate from source `0e1c6e4` is
archived at `session/candidate-used-0e1c6e4215d6`; the full previous helper
generation is at `session/diagnostic-generation-v2`. The original pre-test
pack remains unchanged, and the profile and game data were not modified. Only
the helper's autoloaded `matrix.lua` was updated to the revision-3 bytes; the
separately staged `matrix-v3.lua` has the same 25,146-byte size and SHA-256
`21bce95185f01034b64c24c39935fabc12755d91f9bbbd3a87a3470dc31afc45`.

The first read-only post-install audit failed because its script transcribed a
batch-file hash incorrectly (`c423c015` instead of `c423b015`). A corrected
scratch audit exited 0 and verified the exact 22-file runtime set and bytes,
the module hash above, both matrix copies, helper files, original pack and
previous candidate. The owner cross-checked the audit output; Isaac process
count was zero. This was an audit-input typo, not a product or installation
failure. At the time of that audit, no v3 gameplay retest had run. The later
slot-1 Continue, battery-smoke and Car Battery mode are recorded below.

### Candidate bb2d after Continue — native battery-smoke pass

After slot-1 Continue, the owner ran `battery-smoke` with production source
`bb2d0587b1d018c82e3abc9f75928e3e29d8fb6f`, module SHA-256
`6beb2862bad6a5feb083b7d9b4fbabc017ee936bf054c53b9a9ab166229b2025`. The
engine reported `continued=true`; seed `2855396759`, actor `483707137`. The
main agent cross-checked the raw capture and confirmed terminal frame 1982 with
all three cases passed: `native_magician_stored_charge_control`,
`stored_charge_across_cost_transition`, and `stored_battery_charge`.

At the transition checkpoint (frame 1899), the actor had Blank Card (collectible
286, count 1), Jera (card 33), The Battery (collectible 63, count 1), Car Battery
count 0, and charge 4+4. The captured sequence passed both native Jera uses,
then removed The Battery and used a real battery to restore the base bar to
four. At terminal frame 1982 the actor still had one Blank Card and Jera; charge
was base 4/blue 0, with The Battery and Car Battery both absent. This confirms
the The Battery reserve and post-use cost transition against source `bb2d` after
Continue. It does not cover Car Battery.

- Capture: `session/capture-bb2d-battery-20261115T185640Z`; stable 49,536-byte
  log, log/second-read SHA-256
  `ef496d86e3b4f2fa0c47509e13494d29b6cbb29a60d0f4a7dfbe13fe29e7faf9`.
- Parsed records: 72, SHA-256
  `e73d064d508b38f9f309ee7832ff2142438abfe5679f20976b5de2b4d3ae149d`, zero
  malformed records and no collector errors.

### Candidate bb2d Car Battery mode — native compatibility pass

The owner then ran the Car Battery mode with source `bb2d0587b1d018c82e3abc9f75928e3e29d8fb6f`
(module SHA-256
`6beb2862bad6a5feb083b7d9b4fbabc017ee936bf054c53b9a9ab166229b2025`). The
main agent cross-checked the raw trace through terminal frame 2532. It used
seed `2855396759` and actor `483707137`, with native use sequence spanning
frames 2206–2532.

The native Magician control at frame 2230 recorded two card effects while one
four-charge bar spent 4→0. After a real battery refill, Jera at inherited charge
2 repeated twice and spent that single two-charge bar. Another real refill set
the next cost to four; the `car_battery_cost_transition` case passed at frame
2339. At frame 2359, a single four-charge bar also produced the native Car
Battery repeat count of two Jera effects while spending one bar. The fixture
asserted four penny drops from that one activation, and
`car_battery_single_charge_expenditure` passed.

With both passives owned, Blank Card/Jera use at frame 2449 left base charge 4
and blue charge 0 by frame 2467; the second use at 2469 left 0+0 by frame 2487.
The fixture's native penny-count assertion for 16 passed before cleanup at 2489
(the count is assertion evidence, not a separately emitted inventory field).
It removed both passives and refilled the base bar with a real battery. The
terminal frame 2532 showed one Blank Card (collectible 286), Jera (card 33),
base charge 4/blue charge 0, The Battery (63) count 0, and Car Battery (356)
count 0. `car_battery_with_stored_charge` passed. This validates the Car
Battery compatibility regression in this mode; the other On matrix, ordinary
four-room recharge, Schoolbag, battery-loop, settings/Continue/Off, co-op and
display acceptance cases remain pending.

- Capture: `session/capture-bb2d-car-20261115T190017Z`; stable 85,980-byte log,
  log/second-read SHA-256
  `79388903b16679c9f2014ab772b5d70ea013c0310e20264d12d5512c11076ced`.
- Parsed records: 152, SHA-256
  `b5997fbcef440a50e8182befb92c9bd84a7139097652364f255ff36446982d52`, zero
  malformed records and no collector errors. The main agent cross-checked the
  compact trace and final raw records.

### Candidate bb2d On matrix — five cases passed; room-clear check stopped

The owner ran the v3 `on` matrix with source `bb2d0587b1d018c82e3abc9f75928e3e29d8fb6f`
and helper `21bce95185f01034b64c24c39935fabc12755d91f9bbbd3a87a3470dc31afc45`,
using seed `2855396759` and actor `483707137`. The main agent cross-checked the
raw output. Five cases passed before a room-clear assertion stopped the matrix:

- `ordinary_keys_bombs_hearts` (frame 2810): key, bomb and heart variants
  each doubled from one to two.
- `three_battery_fed_cycles` (frame 2931): one artificial battery seed fed
  three native duplication and collection cycles.
- `post_use_cost_timing` (frame 3065).
- `other_rune_passthrough` (frame 3131): Dagaz was card enum 35, and remained
  native. This capture's 35 value is the observed game enum; do not substitute
  any stale/fake harness value.
- `schoolbag_swaps` (frame 3223): Blank Card stayed at four; D6 moved from
  secondary charge 6 to 0 after the active-item swaps.

The room-clear sequence was not accepted. Room 110 at frame 3293 moved charge
0→1; room 109 at 3333 moved 1→2; room 108 at 3373 moved 2→4, then the matrix
reported `Room clear did not add exactly one charge` and stopped with five
passed cases. Room shape was not logged, so the owner's large-room explanation
remains plausible but unconfirmed. Revision 4 adds shape evidence and filters
for ordinary 1×1 rooms before the remaining clears. Candidate availability is not proof of hostile contents; actual
room populations depend on the map seed and the fixture may still find fewer
than four clearable rooms. Do not report the four-room criterion, co-op, MCM
settings, charge display, or a normal matrix finish as passed. The terminal disposable-run state
had one full-charge Blank Card (286), Jera (33), Schoolbag, D6 in slot 1 at
charge 4, and no The Battery (63) or Car Battery. Native room clears also
recharged the other active item.

- Capture: `session/capture-bb2d-on-20261115T195326Z`; stable 136,187-byte log,
  log/second-read SHA-256
  `31e9bbef05d033a1c1e9ec7065b0908132319da3f73af1395ca539a91528bd1c`.
- Parsed records: 263, SHA-256
  `4d221611f2b47bd989ce323f17c6cc7314c35bd2b5637eeab29d3cd3986c41d9`, zero
  malformed records and no collector errors. The matrix error is recorded in
  the payload, so an empty collector error list is not a pass for room clears.

An earlier collection attempt stopped at a hash guard after the captured SHA
was transcribed incorrectly (`4b46cbe`/`4b46bce`); no native fixture action
occurred in that attempt. The capture above is the corrected run. Revision 4's
`finish-on` mode is for the remaining room-clear tail, co-op and next-run Off
checks; the five passed cases are to be reused, not replayed.

### Matrix fixture revision 4 — local protocol pass, native tail pending

Revision 4 adds `finish-on`, which returns to the floor's starting room and runs
only the room-clear, co-op and next-run Off tail. It does not rerun the five On
cases accepted above. The starting room must be empty; pickups left in the
failed room are not removed. Room candidates must be unvisited ordinary combat
rooms (`Type=1`) with `Shape=ROOMSHAPE_1x1`, and the fixture checks the room's
runtime shape before use. It logs shape/stage with each clear and includes the
initial current room shape/stage in `matrix_started` so the earlier room-shape
hypothesis can be checked. That hypothesis remains unconfirmed.

If fewer than four 1×1 candidates exist on the current floor, the fixture uses
native stage changes to stage 2 and then stage 3 before discharging Blank Card,
reselecting candidates after each move. Four mapped candidates do not guarantee
four hostile rooms; population depends on the run seed and the bounded clear
assertion may still stop. These floor changes mutate the disposable run; the
fixture does not write charge or clear flags. Local protocol
checks skip a 2×2 room placed before four 1×1 rooms, verify four mock clears,
exercise the fallback when only three small rooms are initially available, and
verify that single-player co-op stays pending while the next-run Off path runs.
These are mocked checks, not game evidence.

The owner loaded revision 4 as `matrix-v4.lua` in the existing diagnostic
session. The raw capture showed the starting room was room 108, shape 9, stage
1; after native stage 2 fallback, four ordinary shape-1 rooms cleared with
charges 0→1→2→3→4. The `four_ordinary_room_clears` case passed at frame 3937.
At that same frame the fixture attempted `addplayer 0 1`; the game logged a
native exception and wrote a minidump. No co-op, next-run Off, or display result
was collected. The collector reported 283 records, zero malformed records and
no collector errors, but this does not override the exception in the raw log.
Capture `session/capture-bb2d-crash-20261115T202537Z`; stable log size 146,896
bytes, SHA-256 `b5ed3e546a413216cbbd2deb51f00b3608ebcc4394824252205c85c9558ecbc6`;
records SHA-256
`be460978ecdc11dd90fc3c8c0a1a00439b6e47dd785cd30986727a032b72c17b`.

Revision 5 removes automatic player creation. If the co-op fixture sees fewer
than two actors, it reports `requiresNativeJoin=true` and remains pending; it
never issues an engine `addplayer` command. The local protocol spec makes any
non-stage `ExecuteCommand` fail, checks full and empty charge stay unchanged,
and exercises the next-run Off path. Do not rerun revision 3 or 4. The frozen
helper-only updater
[`blank-card-jera-safe-coop-helper.py`](evidence/blank-card-jera-safe-coop-helper.py)
validates the old helper generation, archives it outside the game mod path,
and installs revision 5 while keeping production/profile/data untouched. Its
synthetic success and unknown-extra-file rejection passed locally. The guarded
update has now completed and passed a read-only audit: the active helper has
exactly four files (`main.lua`, `batch.lua`, `metadata.xml`, and revision-5
`matrix.lua`); the old six-file helper, including v3/v4 matrices, is archived
outside the game mod path at `session/diagnostic-unsafe-coop`. The archive is
preserved; do not run Lua files from it. Journal: `session/diagnostic-coop-guard.json`.
Production remains pinned to source `bb2d0587b1d018c82e3abc9f75928e3e29d8fb6f`
and module SHA-256 `6beb2862bad6a5feb083b7d9b4fbabc017ee936bf054c53b9a9ab166229b2025`;
profile and game data were untouched by this helper update, and the game is
closed. Further native checks wait for the owner's choice of hardware join
path.

The native exception dump was copied to the session for preservation:
`session/capture-bb2d-crash-20261115T202537Z/minidumps/1-isaac-ng.exe.27744.dmp`,
6,013,282 bytes, SHA-256
`476dc9c8dfe5d36ae61fd28b6c428b66da53af40aa532aa5a32039cdfc609834`. It is a
private validation artifact and is not included in the repository. A backup
integrity check matched all 189 user-profile files, 8 game-data files and 287
mod files against the before-run manifest SHA-256
`4af7acc70e3c153672d44c74f4ed1b58190b74fd3129483207d8f91c722b14a7`; the
manifest recorded 2, 3 and 36 expected directories respectively, but directory
equality was not checked. The original 21-file pack archive exists. No crash
reproduction was performed.


### Safe v5 co-op and next-run Off — native pass

After the guarded revision-5 helper installation, the owner started a fresh
Normal Isaac run on slot 1 with keyboard player 1, completed the On smoke, then
joined player 2 with one controller from the first room's native character
selection. The owner verified player 1's Blank Card had four charge bars before
running `co-op`; this uses one keyboard and one controller, not two controllers.
The capture starts with `continued=false`, difficulty 0, seed `2633492662`, and
revision-5 fixture. The On smoke completed first at frame 72. At co-op start
(frame 631), the room was shape 1 on stage 1 and two Isaac actors were present:
player 1 seed `413018421` (keyboard) and player 2 seed `2465916929` (controller).

The native co-op isolation case passed at frame 824. Player 2's Magician and
Jera use, charge refill and effect handling did not consume player 1's Jera or
Blank Card charge; both actors ended with one Blank Card (286), Jera (33), base
charge 4, blue charge 0, and neither Battery passive. The `next_run_off_keeps_current_on`
case also passed: current-run setting remained enabled and next-run setting was
disabled, without granting charge. The matrix completed with two cases passed.
The owner also observed player 1's four charge bars before the run. This is
native evidence for two-player isolation and the current-On/next-run-Off MCM
path; cold Continue was checked separately below, and a fresh disabled run is
still pending.

- Capture: `session/capture-bb2d-coop-20261115T215017Z`; stable log 43,116 bytes,
  SHA-256 `989530809954c15c618e9aca818d87aa7442760f5c4c84d722019012246f0ff7`.
- Parsed records: 58, SHA-256
  `6e8856562b3cf90c384fd705be220fd406fbacacf2f732a0752e9dc8d85c2e8f`, zero
  malformed records and no collector errors.


### Safe v5 cold Continue with next-run Off — native pass

After the owner saved through the menu, fully exited Isaac and relaunched slot
1, the observer recorded `continued=true`, the same run seed `2633492662`, and
two Isaac players. Player 1 remained controller 0, seed `413018421`; player 2
was controller 1, seed `327774610` after restart (its prior-process seed was
`2465916929`). Both began with Blank Card (286) at four charge and Jera (33).
The matrix started enabled at frame 1098 in room 84, shape 1, stage 1.

At frame 1101, native Blank Card/Jera use discharged the bar to zero. A real
battery spawned afterward (so it was not duplicated by Jera) and restored the
bar to four by frame 1162. The `continue_retains_on_and_four_charge_state`
case passed at frame 1162: the loaded run seed matched the saved run, current
settings remained On while `nextRun` was Off, one Jera remained held, one Blank
Card remained owned, charge was 4 with blue charge 0, and neither Battery
passive was held. The matrix completed with one case passed. This validates
Continue after saving next-run Off; the fresh-run Off control remains pending.

- Capture: `session/capture-bb2d-continue-20261115T224128Z`; stable log 57,435
  bytes, SHA-256
  `0daf6ecce8128e55d2e8c795e2ac7a6d1193a3f405f722775e284b27f41b4979`.
- Parsed records: 19, SHA-256
  `1c6957744e579a7c2ca2d36a513d21b07fff256067f18121eb4af8fc03f09e2e`, zero
  malformed records and no collector errors.

### Independent review checkpoint

Two independent read-only reviews covered base `ce1a9b6a38e274de1f8fbd9bbf69069ddbf0a067`
through head `07c68c1ec93ba8b51516c4f318bd096c8cfe7967`. Verified ancestry
(`git merge-base --is-ancestor bb2d0587b1d018c82e3abc9f75928e3e29d8fb6f
07c68c1ec93ba8b51516c4f318bd096c8cfe7967`, exit 0) confirms the bb2d fix was
included in that review range. Standards review found zero actionable
violations or smells. Spec review listed remaining native acceptance criteria
and the Car Battery retest as risks at that checkpoint; it found no confirmed
implementation bug or scope creep. The Car Battery retest has since passed as
recorded below. Merge remains pending until the other acceptance evidence is
complete.

## Session and setup

The owner explicitly handed this issue session to the validation thread for
backed-up disposable runs, restarts and co-op. Session:
`D:\T3ValidationSessions\issue19-20261114T132550Z-e0063e`.

- Game root: `D:\The.Binding.of.Isaac.Repentance.v4.0.2`.
- Profile, saves and log: `C:\Users\Mario\Documents\My Games\Binding of Isaac Repentance+`.
- Pre-test backups: `backup-user` (189 profile files), `backup-data` (8 game
  data files), and `backup-mods` (287 mod files). `before.json` is the snapshot
  manifest, SHA-256 `4af7acc70e3c153672d44c74f4ed1b58190b74fd3129483207d8f91c722b14a7`.
- Executable SHA-256:
  `e5faf6f513c6de9cc9ff1c335ef9c541e2b33fc623aa3b8ffbd2e6a6c0027bb0`.
  The fresh observer session log identifies Repentance+ `1.9.7.17.J460`.
- Observer staging path: `mods\oup_blank_card_issue19_observer\main.lua`,
  with separate metadata. Production files were unchanged at preflight; the
  guarded candidate installation is recorded above.
- The only existing configuration mutation is `DebugConsoleEnabled=1` in
  `options.ini`, recorded in the snapshot. Before SHA-256
  `a86c6288bf3175b26142836b8a0560dde5c4db8cee40bf65bf39108d43945e05`;
  after SHA-256
  `35e408664993b2ae21a52efd4e4372f5ac7f9c8938f64426fbbb8dcc65420cdd`.

For further captures, confirm the observer and MCM are loaded from the game log
and record seed, fresh/Continue state, actor count, difficulty, active item and
settings. The native smoke and transition observations above came from the
recorded run; do not infer behavior from a fixture or `UseActiveItem` calls.
Continue only with the issue's remaining acceptance cases and preserve each
run's conditions and log evidence.

## Native startup — pass

The owner started a new Normal Isaac run on slot 1 and opened the console.
The observer independently recorded `continued=false`, difficulty `0`, one
Isaac (`type=0`), seed `3170816660`, player seed `2828316171`, initial D6
(`105`) at six charges, and no held card or pill. `repentogon=false`.
The startup log reports J460 and MCM v113 loaded. At startup, no Blank Card use
had yet been tested.

Capture: session-relative `capture-20261114T133120828848Z`. Source length
19,026 bytes, identical before/after metadata and two-read SHA-256
`52ee774f6c73040a1df5c5ff83e4a898c0c0e5972c324566fc14fbfd543a5a43`.
Four parsed records, zero malformed records, no matching Lua errors.
`records.jsonl` SHA-256
`8886bc1c843b67d706234ce027c4d4e08ac5e51900cb32731a86e9ee7dc11af1`;
collector SHA-256
`a79301d74730bb63e9fb8a14a909e90d630fd814e4b46cbe62e73c48a08a4a3b`.
The first collection wrapper failed during command parsing; the corrected
wrapper captured the same session without replaying gameplay.

## Cleanup handoff

After the final owner run, close Isaac, preserve its logs and runtime data, and
archive the diagnostic observer. Restore profile, game data and `options.ini`
against `before.json`, preserving unrelated mods. Retain the original backups;
record post-cleanup hashes and confirm the game is closed. Until that cleanup is
verified, the issue session remains owned by the validation thread.
