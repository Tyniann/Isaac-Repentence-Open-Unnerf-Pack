# Void choice absorption validation

[Technical documentation](../agents/README.md)

Issue: [#16](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/16).
Session date: 2026-11-11. Status: **implementation and scoped native validation
complete; diagnostics archived and slot-1 test state/settings restored**.

The corrected source passes 19 distinct matrix cases across the pilot, main
matrix and resumed special-room capture, plus process-restart Continue and a
physical charge check. The owner accepted Boss Rush as the native Angel-pair
substitute. A native Angel pair, special-room return paths, passive-stat
persistence, multiplayer and other modes remain unexecuted; the results below
do not claim those cases.

## Source and environment

- Starting source: `35a563f49ea733d2effa93960b7d639117c6e7ed` on `master`.
- Disposable diagnostic: [void-choice-probe.lua](../../tools/validation/void-choice-probe.lua),
  SHA-256 `2ec45c05cbf6ad1e900f2b3b5ee40f62bf8301f559cdd725b255777140bbfb43`.
  Production `main.lua` does not load it.
- Windows environment: Mafia-Server. The owner explicitly handed this thread
  ownership while the game was closed and authorized disposable runs and backups.
- Game root: `D:\The.Binding.of.Isaac.Repentance.v4.0.2`.
- Executable SHA-256:
  `e5faf6f513c6de9cc9ff1c335ef9c541e2b33fc623aa3b8ffbd2e6a6c0027bb0`.
  The current log header identifies `Repentance+ v1.9.7.17.J460`; executable
  Windows version metadata is blank/zero.
- Save/log directory: `C:\Users\Mario\Documents\My Games\Binding of Isaac Repentance+`.
- Preflight mod folders: Open Unnerf Pack 2, MCM Pure, External Item Descriptions,
  Visible Tinted Rocks with yellow mark. No disabled markers or obvious engine
  extension module were found. The native fixture records confirm REPENTOGON absent.
- MCM declares version 113. `EnableMods=1` in options.ini.

Final production source retained after cleanup:

| File | SHA-256 |
| --- | --- |
| Pack `main.lua` | `da3e94da108b3a06f2505e80bbcd28b20529462894f70cca6653e78c32ac89c4` |
| Pack `config.lua` | `e261369050f074324329d5191b98bc806477e299492852267d1f6031ecf0ec09` |
| `Mods/Void Choice Unnerf/main.lua` | `69a2562786f15642030df823016bf0d317eaa7e3adfe88aa895017300575a44e` |

The initial diagnostic deployment retained the installed pack/MCM sources.
Production updates are recorded below. The initial diagnostic was installed
as `mods\oup_void_issue16_probe\main.lua` (7,408 bytes, matching the source hash
above). Metadata SHA-256 is
`a4a697a96f138a6bf869e208c74b67656d5cd2fa5d2ba1b46a90f4c89c4c58db`.
Original saves and game data were backed up in
`D:\T3ValidationArchives\issue16-20261111-024721-780`; protected verification
passed for 65 files, including 47 pack/MCM files, options.ini and 17 executables.
The backup inventory remains in that archive. Runtime mod list, save slot, seed,
actor and settings must be attached to engine observations before accepting a case.

## Feasibility question

Can temporarily setting ordinary collectible choices' `OptionsPickupIndex` to
zero in `MC_PRE_USE_ITEM` allow **one native Void use** to absorb every eligible
choice, while preserving native rewards, stored effects, charge and room events?
This was the initial hypothesis. The active-pair experiment below establishes
its feasibility for that fixture; production acceptance has a separate matrix.

The [pickup API reference](https://wofsauge.github.io/IsaacDocs/rep/EntityPickup.html#optionspickupindex)
documents grouping by shared nonzero index. The [callback reference](https://wofsauge.github.io/IsaacDocs/rep/enums/ModCallbacks.html#mc_pre_use_item)
documents pre-use interception, but does not establish `MC_USE_ITEM` timing
relative to Void's native consumption. The installation's
`resources/scripts/enums.lua` supplies `GridRooms.ROOM_GENESIS_IDX = -12` and the
native callbacks/use flags. Death Certificate's dimension 2 is documented in
the [level reference](https://wofsauge.github.io/IsaacDocs/rep/Level.html#getroombyidx);
safe runtime classification remains to be verified. REPENTOGON's post-use
callback and pickup helper methods are outside this feature's dependency contract.

## First bounded engine check

Use a fresh disposable Normal Apollyon run, with Void in its primary slot,
without Car Battery, and an empty cleared room. Move below the room center.
The diagnostic's `Start` creates Book of Shadows and Book of Revelations at
known positions with the same option index. `baseline` leaves that grouping
untouched. The owner physically uses Void once and queries `Status` afterward.

Expected native observation: both pedestals disappear, neither book is owned,
and newly absorbed effects do not execute immediately. This alone does not
establish which effects were stored; a subsequent use is a separate check.

The owner selected **Matches the expected baseline** after the first use with
label `VOID16_NATIVE_ACTIVE`: both books disappeared, Void emptied, and no
immediate shield or blue hearts appeared. The captured log corroborates the
pedestal, owned-count, charge and soul-heart observations. A subsequent-use check
is still pending; no feature-On result is implied.

### Native capture: first absorption

Raw log: `D:\T3ValidationArchives\issue16-20261111-024721-780\capture-native-20261111T015416739Z\log.txt`,
21,771 bytes, SHA-256
`7eed136aa97e93ff16e514c83f06878e3ca3a4b2f9c8440fefd8b487ce4fe3bd`.
Both shared-read copies matched in length/hash and source mtime. Seven parsed
records are retained in [native active-pair evidence](evidence/void16-native-active.jsonl);
raw marker lines and capture metadata remain beside the archived log.

Seed `3934420524`, Normal, Apollyon (type 15), stage 1, room index 84 / variant 2,
room seed `2034898599`. MCM present, REPENTOGON absent at runtime. The fixture
starts with items 58 and 78 sharing group 916, both free and unowned. At frame
693, `pre_void` still sees both grouped choices; `use_void` sees the engine has
set item 58's group to zero while item 78 retains 916. The next update still
lists item 78; by the status snapshot at frame 742 no pedestals remain. Charge
is zero, both owned counts and soul hearts remain zero. The log loads the five
preflight mods including the diagnostic; the capture's error/warning search
reported no matches. Save-slot identity and fresh/Continue state were not
engine-instrumented in this probe; fresh run is owner-reported.

**Timing finding:** `MC_USE_ITEM` observes a partially processed state; it is
not a safe assumption that native choice cleanup has finished there. The
experiment must evaluate deferred cleanup and subsequent storage, rather than
restoring at that callback based on public documentation alone.

### Native capture: subsequent use

The owner recharged primary Void to four, used it once in the same run, and
selected **Temporary shield only; no blue-heart gain**. The stable second-use
log is preserved at
`D:\T3ValidationArchives\issue16-20261111-024721-780\capture-native-stored-20261111T015754505Z\log.txt`,
24,314 bytes, SHA-256
`908dff05b46bd02234b4379b2af213e6d40b250055c8de5319465111e24e96d8`.
The [active-pair evidence](evidence/void16-native-active.jsonl) now includes all
14 records from both uses. Frame 824 records exactly one pre-use and use callback
for Book of Shadows (58), flags 67, slot -1; none for Revelations (78). Void's
own use has flags 4 and slot 0. The next-update/status records have shield effect
count 1, zero soul hearts, charge zero and neither book owned. This establishes
the native choose-one behavior for the controlled linked active pair.

The full warning search retains the unrelated SteamCloud-disabled warning;
no Lua error appears. Native log line `RNG Start Seed: 6Z0S DYMV (3934420524)
[New, 1]` corroborates fresh-run provenance. Save-slot identity remains unrecorded.

### Temporary-unlinking experiment

The owner restarted into a fresh Normal Apollyon run and prepared
`VOID16_DETACH_ACTIVE` in `detach` mode. They confirmed both books disappeared,
charge emptied, and no immediate shield or soul hearts appeared. They then
confirmed both a shield and one blue heart on the later use. The stable raw
capture is `D:\T3ValidationArchives\issue16-20261111-024721-780\capture-detach-20261111T020830333Z\log.txt`,
24,181 bytes, SHA-256
`55fe38ccd338d89dab3f1ecf9fdf0bd4ffdf75f084b20f36a43677d7778b4141`.
[Eighteen parsed records](evidence/void16-detach-active.jsonl) show seed
`3241114379`, Apollyon, both books changing from group 916 to zero at frame 444,
no immediate effect, and no surviving pedestals at frame 445. At frame 593, each
stored book receives exactly one callback pair, flags 67 / slot -1. The status
at frame 625 has two soul half-hearts, shield count 1, no owned books and charge
zero. This establishes feasibility for that fixture; it is a diagnostic
experiment, not a production feature-On comparison.

## Production implementation and staged pilot

The [implementation guide](../agents/void-choice-absorption.md) describes the
production module, independent configuration and automated runner. The initial
callback harness passed ten contract checks; configuration passed nineteen.
At this candidate stage, engine acceptance remained pending until the deployed
pilot/matrix. The later off-grid regression adds an eleventh callback check;
corrected-source results appear below.

The candidate's three production files were staged with the game closed, with
previous source and current pack data retained at
`D:\T3ValidationArchives\issue16-20261111-024721-780\candidate-stage-20261111T022224Z`.
The stage worker verified the other 22 protected pack/MCM entries; it retained
an already-existing options.ini mismatch against the earlier archive without
changing that file.

| Runtime source | SHA-256 |
| --- | --- |
| Pack `main.lua` | `da3e94da108b3a06f2505e80bbcd28b20529462894f70cca6653e78c32ac89c4` |
| Pack `config.lua` | `e261369050f074324329d5191b98bc806477e299492852267d1f6031ecf0ec09` |
| `Mods/Void Choice Unnerf/main.lua` | `5118782f15549f28cf73952b1c1bf29a7dcd08a822129eb63381eabfd690fab4` |

The automated batch restarts disposable runs itself, rather than asking the
owner to repeat commands for each case. It begins with a single Isaac active
pair pilot; the broader matrix waits for that end-to-end verification. Normal
API uses and physical uses are identified separately. The source includes
machine cases for independent Off/On, both actors, unlinked/empty/manual/paid
controls, passive differential fixtures, real native choice rooms and special
selection entry/gates. Genesis/DC gate checks do not claim native return-path
validation. Unexecuted cases remain pending regardless of the runner's inventory.

Initial production-pilot batch `mods\oup_void_issue16_probe\main.lua`: 19,235 bytes, SHA-256
`edcae6b39561c80cd08e94ef6be3274d0497a7f13a3946ebe1dd78555dde1b51`.
Its previous bytes and manifest are retained at
`D:\T3ValidationArchives\issue16-20261111-024721-780\batch-finalize-20261111T022755Z-dae6f0`.
The finalization script confirmed the game closed, all three candidate production
hashes, and identical before/after inventories for 43 pack/MCM files. Only the
diagnostic runner was replaced in this finalization.

`lua tests/void_choice_batch_spec.lua` passes inert-loading, duplicate-run,
setting-selection ordering and interrupted-run cleanup checks. These tests do
not certify the runner's native use, restart or room-generation recipe.

### Production pilot owner report

The owner ran `OUPVoidBatch.Run(true)` and selected **OUP_VOID_BATCH_PASS**.
They identified **save slot 1** for this session. Stable captured log:
`D:\T3ValidationArchives\issue16-20261111-024721-780\capture-pilot-20261111T023359Z\log.raw`,
26,318 bytes, SHA-256
`94e060cae54ee1f6316cba5565db6b5b2877a8a61527ef0fec036af73cbcbcd5`.
[Seventeen parsed records](evidence/void16-production-pilot.jsonl) have no malformed
payloads. The automated restart enters Isaac's fresh run, seed `256273122`
(`ACYT LHVH`), with active/next Void setting On, MCM present and REPENTOGON absent.

The main agent checked the complete sequence directly: the **first** native API
use at frame 42 consumes both linked pedestals, leaves both books unowned, and
produces zero shield/soul hearts and no stored-active callback. Subsequent uses
at frames 63 and 84 each invoke 58 and 78 once with flags 67; soul half-hearts
progress 0 → 2 → 4 and native shield count 0 → 1 → 2. The final result is Pass.
Void metadata retains MaxCharges=4. API uses leave charge at four; physical
discharge evidence belongs to the earlier owner-driven probe, not this batch.

The collector's final prose incorrectly doubted the three-use sequence; its
own raw output contains all three `after_use` records, which the main agent
parsed and asserted. The collector also searched the user save folder for
installed Lua instead of the actual game root, so its source-hash search was
inconclusive. The prelaunch deployment manifest remains the source attestation;
repeat the correct-path inventory during the next capture. It retained the
SteamCloud-disabled warning. The larger matrix is now ready for execution.

### First production matrix: valid cases and fixture failure

Stable raw capture:
`D:\T3ValidationArchives\issue16-20261111-024721-780\capture-matrix1-UTC\log.txt`,
109,102 bytes, SHA-256
`342c7af410a0dbe6cb2d08a1fedcb1814375a20e0a88e8631d20b83944befe06`.
The capture retains 121 parsed batch records, no malformed payloads, the prior
pilot and the matrix's eleven passing cases. Its
[terminal matrix record](evidence/void16-matrix1-results.json) retains the failure
and all earlier results. The failure is **verifier/fixture**, not a product pass.

Valid completed cases: active On for Isaac and Apollyon; active Off; independent
unlinked actives; mixed active/passive; single passive; linked passives Off;
unlinked passives; linked passives On; unpaid priced pedestals; empty room.
Active effects execute once per later use without adding the absorbed items to
inventory. Run restarts reset the shield/state and select the requested persisted
feature choice. Unpaid 15-coin pedestals remain unabsorbed and linked.

The main agent compared the recorded native passive results independently:
with RNG set to 160477 immediately before use, a single passive and linked Off
pair both produce range 360 / luck 1 (other base stats unchanged). Two unlinked
passives and the linked On pair both produce range 360 / luck 2 / speed
1.2000000476837. All fixture items remain unowned. This is a controlled RNG
intervention with native formulas, not natural RNG-rate evidence. The mixed
fixture also grants the one-passive result while storing only its active.

The owner saw repeated active-item swapping in `manual-choice-on`. The old
fixture positioned Isaac on an active pedestal for 30 frames, leaving the newly
dropped active at his feet. At frame 73 its final inventory assertion failed.
The screenshot and log agree. The corrected control uses passive choices and
moves Isaac away after pickup; it does not alter production pickup behavior.
The runner can resume from this case without replaying earlier acceptance cases.
Passive comparisons for a resumed batch refer back to the capture above.

### Resumed manual fixture: native pickup queue timing

The passive control still failed at frame 73 because the runner checked owned
counts before native item-queue completion. Stable raw log:
`D:\T3ValidationArchives\issue16-20261111-024721-780\capture-matrix2-20261111T025708808Z\log.txt`,
20,569 bytes, SHA-256
`49b63652e44b758bda66111ae6c1dae8e4575cb10330e0f85ba958246b0b3856`.
[Five diagnostic records](evidence/void16-manual-premature.jsonl) identify seed
`2441754560`, Isaac, room 84, and passive items 1/2 sharing group 916. The raw
log's lines 460–462 show the ordering: failed inventory assertion, **item queue
flush**, then **Adding collectible 1 (The Sad Onion) to player 0 (Isaac)**.
The owner's screenshot and visible pickup agree. This is a second fixture
failure, not evidence that production allows both manual choices.

The maintained runner now waits for owned-count completion with a 180-frame
bound and ten stable frames, instead of a fixed 30-frame assumption. The
existing loaded runner remains at its v2 hash so the owner's game need not be
restarted again. A separate additive diagnostic,
`mods\oup_void_issue16_probe\manual-recovery.lua`, is staged for read-only
settled-result verification in that exact seed/room/actor. It removes its own
callback, then resumes at `angel-native` only if one passive is owned and neither
original choice remains available. No production source or loaded file was
replaced. Helper: 2,486 bytes, SHA-256
`ad76365b2149906507499fd9df2d8952ec53259702713de3be8f398e33546c3f`;
43 protected pack/MCM files were unchanged. Readback and remaining room cases
are pending.

### Settled manual result and owner-selected room substitution

The readback passed in the same captured manual-fixture run. At frames 578/583,
seed `2441754560`, Isaac owns one Sad Onion and zero Inner Eye, with neither
choice left available. The helper removed its callback before continuation.
Stable log capture:
`D:\T3ValidationArchives\issue16-20261111-024721-780\capture-room1-20261111T031222249Z\log-read1.bin`,
24,541 bytes, SHA-256
`b3d556ed08be27ae1e18c048a73c9958d6bcd0eb11aa0ab974828538a4bc0af2`.
The matching second shared-read snapshot and metadata remain beside it.
The [settled records](evidence/void16-manual-settled.jsonl) establish the manual
choose-one control after the native item-queue completion. Earlier premature
assertions remain recorded as fixture failures.

The next fixture used bare `goto s.angel` and entered Angel variant 0 with one
pedestal (item 142). It stopped before any Void use because the fixture required
multiple choices. This is a layout-selection failure, not a product failure.
The owner correctly pointed out that Angel Rooms need not offer multiple items,
then explicitly offered Boss Rush as a substitute and left the choice to this
thread. **Accepted scope adjustment:** use the real Boss Rush offering for the
native multi-pedestal room acceptance and fight-start trigger. Keep Angel-pair
runtime coverage explicitly unexecuted; generic linked-group evidence still
applies to the shared implementation, without claiming an Angel-specific pass.
Continue at `boss-rush-native` without restarting the process or replaying the
earlier validated fixtures.

### Boss Rush: exclusion bug and trigger-observation fault

The owner observed Boss Rush start and Isaac die after the fixture reported
`Boss Rush did not start`. Stable archived log:
`D:\T3ValidationArchives\issue16-20261111-024721-780\capture-boss1-20261111T032548393Z\log-read1.bin`,
30,881 bytes, SHA-256
`e5a8d5116b448bd2ba58465c11326703968bf5bc33e7fa2821e88756a292a142`.
It records native Room 17.0, debug index -3, four free pedestals in group 1,
the early frame-94 assertion and a later game-over event from entity 404.1.
The log alone does not label that enemy as a Boss Rush wave; the owner's
observation corroborates the fight start separately.

The trace also uncovered a **production exclusion bug**: the old dimension
classifier labelled this off-grid room dimension 2 because off-grid descriptors
alias across dimensions. The feature therefore left native choose-one behavior
active: after the first use, three alternatives still remained before cleanup.
The correction limits the Death Certificate pointer check to nonnegative
SafeGridIndex rooms; Genesis retains its explicit room-index exclusion.
A new callback regression failed with the old guard and passes with the fix.
The suite now has eleven callback contract checks.

The implementation also keeps one original option marker per eligible group,
detaching its alternatives only. This preserves native option-marked room events
and cleanup while allowing all eligible alternatives to reach native absorption.
This is a change from the initial all-zero experiment; the updated production
behavior requires new native validation, without erasing the earlier evidence.

The runner now observes `IsAmbushActive` or actual enemies with a bounded wait,
instead of assuming Boss Rush's first wave is present after 20 frames. It gives
the disposable actor damage cooldown during active fixtures and inspection time
after failure. Four-active room fixtures use Book of Secrets instead of random
Book of Sin pickup rewards. A final fresh Apollyon anchor prepares stored effects
for one process-restart/Continue check with active On and next-run Off.

The corrected candidate was installed with the owner-confirmed game closed.
Backups/manifest:
`D:\T3ValidationArchives\issue16-20261111-024721-780\native-fix-20261111T035128Z-ed179b`.
New production Void module SHA-256:
`69a2562786f15642030df823016bf0d317eaa7e3adfe88aa895017300575a44e`.
New diagnostic runner SHA-256:
`42b7c24b14ff6b77b443930addd51b83c7d818e5e5066d7464adae45e1d5f704`.
The other 42 pack/MCM files matched. Root loader/config remain at their earlier
candidate hashes. This candidate also visits the generated floor's real main-
dimension Treasure/Boss rooms for options cases, retains the owner-selected
Boss Rush substitution, and includes native observed-run-start/Continue logging.
The marker-preserving change requires new native reward comparisons; earlier
candidate passes remain historical evidence rather than final acceptance.

### Corrected-candidate pilot

Owner result: **OUP_VOID_BATCH_PASS**. Stable log:
`D:\T3ValidationArchives\issue16-20261111-024721-780\capture-final-pilot-UTC\log.raw`,
28,773 bytes, SHA-256
`d76c6a7dff0c3233af2d9ffd500619b35edd266d92790ec406cd7e7de14347da`.
Both corrected installed hashes above matched. The
[parsed trace](evidence/void16-final-pilot.jsonl) confirms fresh Isaac seed
`597734691`, two linked books consumed without immediate effects or ownership,
then exactly one activation per book on each subsequent use, soul half-hearts
0 → 2 → 4 and final Pass. The main agent checked these three native-use records
and four stored-active events directly. No matching native/mod warning was
reported. The remaining corrected-build matrix starts at Apollyon, retaining
this pilot as its separate Isaac case.

### Corrected-build matrix through Genesis entry

Stable raw log:
`D:\T3ValidationArchives\issue16-20261111-024721-780\capture-final-matrix-20261111T040436Z\log.txt`,
164,799 bytes, SHA-256
`6dde760f62544bc7a0b6edab6354f4dde2f305f2bcd7dcfa7debe9c75bffc758`.
It contains 195 parsed batch records with no malformed payloads. The
[terminal result with fifteen completed cases](evidence/void16-final-matrix-results.json)
preserves the later fixture error separately from each valid result.

The corrected production passes Apollyon On, Off, unlinked, mixed, four passive
controls, unpaid, empty and settled manual controls. The main agent again checked
both recorded passive comparisons: one-passive equals linked Off and two
unlinked passives equal linked On under the controlled RNG input. The manual
case settles with Sad Onion owned once and Inner Eye zero.

Boss Rush passes on seed `102326008`: native Room 17.0, off-grid debug index -3,
dimension correctly reported as -1. `boss_rush_started` appears at frame 94;
the result at frame 136 has two enemies, an active ambush, all four absorbed
books unowned, and native stored effects executing once per later use. No
scripted fight-start call was used. Damage cooldown protects this disposable
actor; no ordinary combat immunity is claimed.

More Options passes in a generated Treasure Room (seed `1585637354`, grid 45,
variant 42); There's Options passes on the generated boss reward (seed
`3746267242`, grid 56, variant 2051). Alternate-path Treasure passes with
StageType 4 (seed `1344027538`, grid 72, variant 10). These are real room/reward
groups, with fixture identities morphed while retaining their native links.

Genesis enters its native bedroom and adds the two controlled test choices,
then the fixture stops on a sandbox error: global `package` is unavailable.
That is a verifier failure before the exclusion assertion, not a product pass
or failure. The maintained runner now retrieves the actual registered
production callback through `Isaac.GetCallbacks`, invokes that callback once,
and checks the choice links remain unchanged. It exports no test-only production
interface and never reloads production modules.

An additive `special-recovery.lua` was staged for the current paused session.
It stops/unregisters only the old diagnostic callbacks, checks the four production
callbacks are untouched, loads the corrected diagnostic and resumes at Genesis.
Generated helper: 28,363 bytes, SHA-256
`38e3e5f507ad028238bb1bc464ac15f40769d7ff2f8326628308b930fcf6ad93`;
manifest: `D:\T3ValidationArchives\issue16-20261111-024721-780\special-recovery-stage-20261111T041617Z-608f35`.
All 43 protected pack/MCM files were unchanged during this additive stage.
Its remaining cases are Genesis, Death Certificate and the fresh Continue anchor.

### Special-room recovery and Continue preparation

The owner reports `OUP_VOID_BATCH_PASS` after the recovery command. A stable
two-read capture corroborates the three passing cases: 188,667 bytes, SHA-256
`a4173e227f77bfa40d4c8fb6a42ef9c930026bad6fc5026a6261125d65b03c71`.
Archive:
`D:\T3ValidationArchives\issue16-20261111-024721-780\capture-special-recovery-20261111T042306Z-ba8d5a`.
All 222 batch records parse, with no malformed payloads or warning matches.
The archive retains the earlier failed batch and all its passing results;
the [recovery terminal](evidence/void16-special-recovery-results.json) records
only the three resumed cases.

Genesis seed `1581425775` enters room index -12, type 18 / variant 1000.
Death Certificate seed `1852458596` enters on-grid room 80 in dimension 2.
Each case invokes exactly one registered production Void pre-use callback;
both controlled choices retain group 916 and remain unowned. These are native
entry plus production exclusion-gate passes. Native use and return transitions
inside those sequences were not exercised.

The final anchor is fresh Normal Apollyon, seed `212727584`, with both books
stored by native Void, two later uses already checked, four soul half-hearts,
and neither book owned. Root loader, config and the corrected production module
all match their deployed hashes, including module SHA-256
`69a2562786f15642030df823016bf0d317eaa7e3adfe88aa895017300575a44e`.

The owner selected next-run Void Off in MCM and fully closed the game for the
process-restart check. Local preflight caught a diagnostic-only readback defect:
`CheckContinue` checked a seed field previously added only by logging. State
snapshots now include their engine seed directly. The protocol harness reproduces
that failure and passes after the correction, including rejection of a different
seed, two observed mock invocations and no settings writes or restart commands.
This harness establishes protocol safety, not native persistence.

With the game closed, only the diagnostic `main.lua` was replaced by the fixed
26,671-byte runner, SHA-256
`a2b7778c07353d8f91da3da18f1026f71479d56c95d20a7af6c70c2ff401347b`.
Backup and manifest:
`D:\T3ValidationArchives\issue16-20261111-024721-780\continue-runner-stage-20261111T042726Z-f3fbea`.
All 53 protected pack/MCM/data/slot-1/settings files remained unchanged.
Normal and pinned-MCM configuration harnesses pass 19 checks each, the Void
callback harness passes 11, and compatibility, both diagnostic safety harnesses,
all Lua syntax checks and `git diff --check` pass.

### Native process-restart Continue

The owner selected MCM next-run Void Off, fully quit, relaunched the game and
continued slot 1. They report `OUP_VOID_CONTINUE_PASS`. The [nine parsed
records](evidence/void16-continue.jsonl) corroborate engine-observed
`continued:true`, the same Apollyon seed `212727584`, active Void On and next-run
choice Off. Both absorbed books remain unowned. Soul half-hearts progress
4 → 6 → 8 on two native API uses; each use receives exactly one stored callback
for Book of Shadows (58) and Book of Revelations (78), flags 67. Continued stats
match this active-only anchor; passive-stat persistence is not a native case here.

Stable capture: 20,504 bytes, SHA-256
`3700e565eaba8b289c11b3871fd594e4d6bcfc87002d922adbf5ec55c7bcf3dd`.
Archive:
`D:\T3ValidationArchives\issue16-20261111-024721-780\capture-continue-20261111T043822Z-52043d`.
Both shared reads match length, timestamp and hash; nine records parse, none are
malformed, and no warnings/errors match. Root/config/module and diagnostic
hashes all match the closed-game stage. Charge remains four during these API
uses, so this result establishes stored-state persistence and snapshot behavior,
not physical discharge.

### Earlier manual-runner staging (historical)

The earlier manual-fixture runner was installed while closed: 20,111 bytes, SHA-256
`137511b40c6f06bf18a400efb361cdabea134796078f41aad89449836a3096a2`.
Previous bytes and verification manifest:
`D:\T3ValidationArchives\issue16-20261111-024721-780\runner-fix-v2-20261111T024933Z-a376c1`.
All three production hashes (including the feature module at the correct pack
path) and all 43 protected pack/MCM files matched. The source correction only
changes the diagnostic's manual fixture and resume behavior. Protocol safety
checks cover resuming without changing settings before the next run-start hook.

The installed root loader/config/probe hashes match their candidate values.
The collector's feature-module hash attempt used the wrong path outside the
pack folder; repeat that one check during the coordinated diagnostic update.

### Owner test budget

The owner requested a reasonable manual test budget: machine batches may be
large, but repeated human command copying and game restarts must stay small.
After the smallest feasibility check, automate repetitive fixtures and log
assertions; reserve manual steps for essential observations, native room
transitions or restart/Continue checks that the maintained tools cannot perform.

Record `OUP_VOID` JSON from the real log, including `fixture_ready`, `pre_void`,
`use_void`, `next_update`, `restored` and `status`, plus intervening Lua/native
warnings. Match label and seed. The optional `detach` experiment changes only
the diagnostic's own fixture pedestals; use a separate fresh disposable run.
It restores surviving indices at the next update, room change, pre-exit or Stop.
That delayed restoration is a probe mechanism, not an approved production design.

`Stop` restores surviving indices, removes only fixture pedestals and unregisters
all probe callbacks. Stored native effects remain in the disposable run, which
must be discarded. Stop before preparing another fixture; restart the game when
changing deployed code. Follow the [shared engine workflow](../agents/game-validation.md)
for log capture, handoff and removal of the diagnostic folder after game exit.

## Final physical use and cleanup

After the Continue check, the owner physically used fully charged Void once
and confirmed that its charge emptied. The final closed-game log records
`VOID16_PHYSICAL_CHARGE=0`; the preceding Continue capture records four charge
and native `MaxCharges=4` on the same anchor. This confirms physical discharge
of the final production build. No room-clear recharge sequence was exercised.

The [cleanup receipt](evidence/void16-cleanup.json) records two identical final
log reads: 32,701 bytes, SHA-256
`55007ae028eaabe4faaa19d29fb97bd03ea2b32d50e24ae511e5805fc3068921`.
The physical marker and successful Continue result are both present. Archive:
`D:\T3ValidationArchives\issue16-20261111-024721-780\cleanup-20261111T044240Z-cf3459`.

With the game confirmed closed, cleanup:

- Restored original `gamestate1.dat`, `persistentgamedata1.dat`, `options.ini`,
  command history and the changed slot-1 automatic backup, with exact hash checks.
  The displaced test versions remain in the cleanup archive.
- Moved the newly created slot-1 pack/MCM data into the archive, restoring their
  original absence. EID data already matched its original bytes and was retained.
- Moved all four diagnostic files into the archive and verified their hashes.
  `mods\oup_void_issue16_probe` is absent; no diagnostic callbacks survive process exit.
  The one-use manual-recovery source remains archived with that historical
  fixture rather than shipped as a maintained tool; its hardcoded seed and
  Angel-case continuation do not belong to the final runner.
- Preserved all 491 protected files during cleanup, including the production
  candidate, other mod sources/data, executables and other save slots.
  Slot 2's progress file already differed from the initial archive before
  cleanup; it was retained as found rather than attributed to these tests or
  restored outside the slot-1 scope.

The production feature remains installed at the hashes above. Original backups,
test-state backups, failed fixtures and passing evidence remain archived.
The game is closed and session ownership is released to the owner.

## Checks and remaining acceptance

`luac -p tools/validation/void-choice-probe.lua` passes.
`lua tests/void_choice_probe_spec.lua` passes fixture safety checks: no mutations
on load, invalid/duplicate starts rejected, native grouping unchanged in baseline,
only Void detaches choices, surviving groups restored, removed pickups stay
removed, and Stop removes all registered callbacks. These are stub checks;
they do not establish engine ordering or absorption behavior.

| Engine case | Status |
| --- | --- |
| Native linked active-pair first absorption and subsequent stored effect | Pass for this fixture; logs and owner agree |
| Experimental index writes and native consumption/storage | Pass for the free linked active pair |
| Production feature-Off / feature-On comparisons | Pass for controlled active and passive groups |
| Passive-only, active-only, mixed groups; exactly-once contribution/no owned items | Pass for captured fixture identities / controlled RNG comparisons |
| Real Boss Rush, More Options, There's Options, alternate-path Treasure | Pass on the corrected production source; owner substituted Boss Rush for native Angel pair coverage |
| Native Angel Room pair | Unexecuted; owner accepted the Boss Rush substitution |
| Unlinked pedestals, empty room, manual choose-one pickup | Pass; manual result verified after native queue completion |
| Paid choices | Pass; linked priced pedestals remain unchanged |
| Death Certificate and Genesis | Pass for native entry and production exclusion gate; native return transitions untested |
| Four-room charge | Pass for native MaxCharges=4 and owner physical use of the final build, followed by logged charge zero; API uses are separate |
| Stored/new active timing and repeated use | Pass; no immediate newly stored effects, each later effect once per use |
| Process-restart Continue persistence | Pass on slot 1, same Apollyon seed, active On / next-run Off, two later uses |
| Apollyon and another character in local single-player | Pass for Apollyon/Isaac controlled active fixtures |
| Independent default-On option, MCM absent/present, migration/save slots/snapshots | 19 harness checks pass in each MCM mode; native MCM present, On/Off runs and process-restart Continue pass |

Multiplayer and other modes are untested. Feature documentation, README/counts,
configuration references and an Added changelog entry accompany implementation.

## Setup failures retained

The first remote inventory worker misunderstood its location and attempted an
unneeded machine link. A subsequent worker used its local Windows shell and
completed the inventory without changes. The first deployment worker abbreviated
the supplied payload and used .NET APIs unavailable in Windows PowerShell 5.1;
it stopped before backups or installation. Neither failure is gameplay evidence.
The corrected transfer uses complete gzip/base64, `GZipStream` and a
PowerShell-5.1-compatible SHA-256 check before deployment.
