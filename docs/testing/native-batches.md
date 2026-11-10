# Native compatibility batches

This is active test tooling for issue #1, not production code. It is not loaded
by the pack or the immutable observer. The owner requested fewer console steps;
reuse the recorded Maw and configuration results rather than repeating them.

## Current implementation

`tools/validation/compatibility-batch.lua` exposes `OUPBatch.Run(options)`,
`Status()` and `Stop()`. Loading defines the interface but starts no tests.
The optional file must first be reviewed and staged at a recorded hash.
Version 1 at `a5c25f0a16f8bf31498c23816bd07a4a5a60820e` was staged as
`compatibility-batch-v1.lua` (26,188 bytes, SHA-256
`4057891a8ad9b864231445bc2980641100ba2fda78afbc6b2381f37e87424a68`).
The immutable observer and production deployment remained unchanged.

The first owner-run smoke, `B1-hard-on-smoke`, stopped at zero of two fire
trials with `No clear orbital contact point` (source line 234, resumed at 376).
The screenshot establishes a fixture setup failure, not orbital compatibility
or a fire result. A stable two-read log capture recovered four records:
seed `1273441713`, Hard, all gates On, Jacob/Esau, production `f1c8325`.
The controlled Pyromaniac crush request had flags `16777216`, amount 2,
returned false and changed red half-hearts from 4 to 6. This supports that
synthetic engine-input contract, not a native Mom attack. The final record
reported no cleanup errors; no contact or fire trial was completed.
Artifacts: Windows session `evidence/B1-smoke-20261109T170743873Z/`,
`log-full.bin` SHA-256
`e47107f7ade8c30a443edd796380bbd6fb9377418daa0f5ef1040b0bbd6b9ae8`,
`batch-raw.jsonl` SHA-256
`59a1b9325c6c5f8009d22f47f5e5667ed7d20791e36e862351a4dc0174ce32be`.
Version 2 moves the
target outward from the familiar while retaining player clearance and checks
the actual target footprint before native frames advance. Unavailable contact
setup is recorded as incomplete and does not block the other mechanics phases.
Its short-orbit placement contract passes locally. Version 2 at
`08259b8b0d5469a5b517d151b37836d4ebdb12c4` was subsequently staged as
`compatibility-batch-v2.lua` (27,235 bytes, SHA-256
`b796e7837dc2f942e3eaa88efcd48c7b8d7c3e2e5b5f579351db88ff7d3f1c52`).
The staging manifest independently verifies those source bytes; the log hash
below identifies a different artifact and is not expected to match that hash.

`B2-hard-on-smoke` completed 2/2 trials at frame 2694, same seed, actors,
difficulty and all-On settings as B1; no cleanup errors or bounded Lua errors.
The native Dagger source caused four 30-damage events (target HP 10000→9880)
and, with BFFS, three 60-damage events (10000→9820), while its exposed damage
field stayed 30. This is actual collision evidence, not a fixed DPS estimate.
One/two Cube of Meat created native variants 44/45 with distinct seeds, damage
14, size 13 and processed true. A real hostile room clear advanced the same
Relic's counter 2→3; one clear without a payout does not establish cadence.
Each fire variant received one observed extinguishing hit, became `NoFire`
while retaining HP 1, and produced no heart in this two-trial smoke. Those
nondrops are not a rate estimate. The controlled Pyromaniac result was again
4→6 half-hearts with a cancelled request.

The stable 22-record extract is Windows session
`evidence/B2-smoke-20261109T174845399Z/batch-raw.jsonl`, SHA-256
`79f0dc42430922c884136b3a15aadcc0109c59f6f5ccd62862a892b6362a8848`;
`log-full.bin` is 3,405,994 bytes, SHA-256
`2db5ad66669c19584d1030965154f29d745ccc59da3432d8ec7d601f85559f2b`.
This verifies the smallest batch execution, not full issue acceptance or a
pack-absent comparison. Longer native cadence and fire samples remain pending.

### Full-window safety failure and version 3

`B3-hard-on-full` started at frame 3683 on the same recorded Hard run. The
owner reported that the contact target moved away and attacked. Three native
Dagger damage events of 30 were recorded, then the protected-health check
aborted at frame 3859, before either contact result or any fire trial completed
(0/400). Cleanup reported no errors; the owner explicitly stopped/unloaded the
helper and left the console paused. This is a fixture containment failure,
not a compatibility result. The record does not identify the injured actor's
new health or prove how the freeze condition ended. Do not silently treat the
pre-run health context as post-failure health.

Stable evidence: Windows session
`evidence/B3-stopped-20261109T180332057Z/`, log 3,410,195 bytes, SHA-256
`6973056b3d79e6911dd67685151c4139264ece6e326c02e8b65faee9c1521eef`;
seven-record `batch-raw.jsonl` SHA-256
`1fd6fbe8fb053334a1def831453ecac48b150251d5b73f60fa596d61ce520931`.

Version 3 corrects the fixture containment:

- The installed `resources/scripts/enums.lua:89` documents
  `MC_PRE_NPC_UPDATE = 69`: returning true suppresses internal AI. The active
  fixture does this **only** for the owned target's matching Index/InitSeed,
  pins its position/velocity, and records suppressed frames and observed drift.
  Other NPCs return nil. Observational callbacks still always return nil.
- Native no-knockback flags replace reliance on the freezing status. Familiar
  collision and damage remain native; neither target HP nor damage events are
  manufactured after initial setup. This required a fresh engine smoke.
- Actors receive renewed 90-frame native protection after the synthetic crush
  phase and throughout the remaining fixture. A 95-frame initial wait lets
  this fixture's protection from an earlier run expire before a new crush
  request. Protection expires normally after cleanup.
- The smoke now uses the same 180-frame contact windows as the full run. The
  previous 60-frame smoke did not expose the longer-window escape.
- Completion/error records include actual post-cleanup player health, positions
  and managed item counts, rather than repeating only the initial context.

Local Run/Stop contracts verify re-anchoring after simulated knockback,
suppression of owned-target AI, exclusion of foreign NPCs, deferred cleanup
after a controller error, and player protection. These are fixture-contract
tests, not proof of native engine containment.

Version 3 at `bec58129343216e09ff449398c1181cf3899317a` passed both Sol/high
review axes with zero actionable findings and was staged as
`compatibility-batch-v3.lua`, 29,938 bytes, SHA-256
`ad0db77bbaa0c99466a47ac641348e9aa8b1cd2fe660d823e9c7bc1f7aaae35c`.
The frozen observer hash remained unchanged. The staging manifest SHA-256 is
`4c3a8764337a716faf91f2bc970527783939e535145b5b615b5ae848b30fb7af`.

The owner reported `B4-hard-on-smoke` complete 2/2 in about 15 seconds and
stationary targets. Valid per-phase records confirm native target HP loss:
10000→9670 without BFFS (12 damage attempts of 30) and 10000→9400 with BFFS
(10 attempts of 60). Attempts are pre-damage observations; their sum is not
assumed to equal applied HP loss. Both controls recorded 157 AI-suppressed
frames, zero observed drift, and identical anchor/end positions. The targets
were not invulnerable. Initial health confirms the repair restored Esau to
2 red / 2 soul half-hearts; Jacob remained at 6 red / 0 soul. One native Relic
clear and two extinguishing fire hits were observed; neither fire dropped a
heart. Cadence and probability remain pending.

The large terminal JSON was truncated/interleaved and is **not** counted as a
valid complete record; post-cleanup state is not recoverable from that line.
Owner-reported completion remains separate evidence. Tolerant recovery retained
36 valid records plus the malformed payload, without replaying the engine test.
Windows session `evidence/B4-recovery-20261109T184131575Z/`: log 3,442,935 bytes,
SHA-256 `8fc7cfc2054c566653a463838c66418c58797bc81ab5e9288dbe7cbb7ace3ad6`;
valid JSONL SHA-256
`28a99be636f33a446df5631d3513ffdba06480b9cb19b4ee2f01c4f4439db0a2`;
malformed file (10,234 bytes) SHA-256
`0e0cc3442ffabbc26aed578b3d6172364ce2841c257c3dc7414438d4778fae6c`.
Recovery metadata writing hit a PowerShell argument error after these files
were preserved. The missing sidecar was subsequently repaired after checking
all three preserved file hashes, SHA-256
`cc50a4223838f4a94e1025c569871d270260537c9373955149a893672a2d3219`.
No game or live-log access was involved in that repair. Future terminal captures omit the
large, redundant mechanics arrays; individual mechanic events remain intact.

`B5-hard-on-full` did not reach fire sampling: the owner's screenshot shows
`error 0 400`, source line 403 `Native hostile room did not clear` (resumed at
442). This is an unresolved fixture room-clear setup, not evidence of a pack
failure. Recovered valid records show two native clears (rooms 98 and 111),
counter 2→3→4, with no payout. The compact terminal record confirms all five
temporary item counts returned to zero, original health/positions restored,
room 84 restored and no cleanup errors. This is not a completed cadence test.
The first
collection attempt failed during JavaScript command preparation before
PowerShell started, without a capture or file changes. A subsequent one-line
`exec_command` probe succeeded. Collection scripts must avoid PowerShell
backticks in JavaScript template literals and use `.ToArray()` rather than
wrapping generic collections in PowerShell array expressions for metadata.

### B6: completed Hard fire sample, production unchanged

`B6-hard-on-fires` completed 400/400 with `mechanics=false`, same seed
`1273441713`, difficulty 1, Jacob/Esau, all seven gates On, and production
`f1c8325`. Both actors retained their initial health/positions; room 84 was
restored, no managed items remained and cleanup reported no errors.

| Fireplace variant | Unique eligible trials | Zero hearts | One heart | Two hearts | Soul hearts total |
| --- | ---: | ---: | ---: | ---: | ---: |
| Blue (2) | 200 | 151 | 45 | 4 | 53 |
| Purple (3) | 200 | 149 | 49 | 2 | 53 |

Independent extraction matches the helper's groups: 400 unique fireplace
identities, no duplicate trial records and no non-explosion damage events.
Each eligible trial had exactly one observed explosion and an extinguished
fireplace. All recorded hearts were subtype 3. These are observed outcomes,
not proof of an exact theoretical rate or a completed vanilla comparison.

There is actual stacking of the extra roll and another fire reward in this
sample. For trial 24, fire seed `3591451838`, heart seed `3519502515` initialized
in `damage_callbacks` at frame 7206 with that fire as spawner; a different heart,
seed `1015785060`, initialized after the explosion at frame 7207 without a
spawner. Both updated with distinct entity indices and survived into the
trial result. This is two pickups, not duplicated observations of one pickup.
It does not by itself prove a compatibility defect: the existing helper
deliberately adds a separate 0.17 roll. Native controls and intended behavior
must be assessed before changing that balance behavior.

Stable artifact directory: Windows session
`evidence/B5-B6-20261109T225254861Z/`, full log 3,958,014 bytes, SHA-256
`70c003b5cdc297e38c5fe606c5225c6245c398184d19a84b7ee1b6d7cd38aca9`.
The installed v3 helper hash was checked before/after capture. B5 has 28 valid
records, one compact end and one preserved malformed line. B6 has 1,414 valid
records, no malformed lines and two compact snapshots (initially running, then
complete); those are not two independent runs. B6 valid JSONL SHA-256
`d079410d8920e345a63b0e701d0150f66b78e61abe02b08a98a1d1400f9c21ff`;
compact ends SHA-256
`862ac7296df8e892f1547cd8df56621f44df2f7ffa57081bd145139bc38795e8`.
B5 compact end SHA-256
`90d13607e6aadec7332a70dd7d86beca339161b48a59aa6e23dfe26500309d5c`.

### Version 4: native-control fixture

Local version 4 does not change the production pack or fire-trial algorithm.
The Relic fixture retries living NPC kills over up to eight 15-frame intervals,
then observes 90 frames after a real clear for native payout animation. It
considers at most 12 unvisited default-room candidates. Unresolved rooms are
recorded separately, never counted as clears, and do not block unrelated fire
sampling. This addresses a fixture assumption; B5's exact native cause is not
established. No room-clear flags or familiar counters are written by the fixture.

Logs emit bounded phase/terminal summaries; individual damage, clear and payout
records retain the detailed data. `Status()` still retains full mechanics data.
Local public-interface regressions saw RED/GREEN for a child left by a native
kill and oversized duplicate logging, then verified that an unresolved room
stays incomplete while fire sampling/cleanup finish and foreign NPCs remain.
These are driver contracts, not native engine proof. Version 4 at
`6d17cee4987b02e9d606042a8e014cf391cb722b` subsequently passed both Sol/high
review axes with zero actionable findings and was staged as
`compatibility-batch-v4.lua` (31,697 bytes, SHA-256
`06209996728d307ad01db67230186d95f6238db14d994e745108c2c978710b72`).
The pack-absent engine runs below verify its bounded native execution.

### V1–V3: actual pack-absent controls

The owner saved and exited before the transition. A process guard confirmed
no `isaac%` process. All 13 production hashes still matched `f1c8325`; the
immutable observer hash remained unchanged. Verified backups captured 180
user-data files and five game-data files before creating only the pack's empty
`disable.it` marker. MCM Pure 113 and the observer remained enabled. Thus these
are pack-absent native-mechanic controls with diagnostics, rather than an
unmodded application. The fresh logs identify J460, omit execution of the
pack's `main.lua`, and report `packPresent=false`. A `LOADED MOD .../content/`
directory entry alone does not prove that a disabled mod's Lua executed.

Transition artifacts are in Windows session directory
`native-control-6d17cee-20261109T233610456Z/`; `after.json` SHA-256 is
`466eb997466abef0d015bbd0b082454690254e36bd620ed88353437df047ae5b`.
Its `before.json` records the verified backups and runtime hashes. Neither
transition changed a production file or overwrote the original session backups.

| Profile | Seed / mode / actors | Recorded completion | Mechanics |
| --- | --- | --- | --- |
| V1-hard-native-smoke | 3435775442 / Hard / Jacob and Esau | 2/2 fires | Native crush, Dagger with/without BFFS, two Cube states, seven actual Relic clears |
| V2-hard-native-fires | 3435775442 / Hard / same actors | 400/400 fires | Fire-only; 200 eligible trials per variant |
| V3-normal-native-full | 1324339445 / Normal / Isaac | 400/400 fires | Native mechanics plus six actual Relic clears and 200 eligible trials per variant |

Hard actor-zero luck was 1, with Esau luck -1; Normal Isaac luck was 0.
Independent extraction found 400 unique fire identities per full profile, zero
duplicate trial records, zero non-explosion damage events and exactly one
observed explosion per eligible trial. All observed heart pickups were soul
hearts (subtype 3). Different seeds and actor contexts prevent a paired-RNG or
general luck conclusion.

| Mode / deployment | Variant | Eligible trials | Zero hearts | One heart | Two hearts | Total hearts |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| Hard, pack absent (V2) | Blue (2) | 200 | 179 | 21 | 0 | 21 |
| Hard, pack absent (V2) | Purple (3) | 200 | 184 | 16 | 0 | 16 |
| Normal, pack absent (V3) | Blue (2) | 200 | 149 | 51 | 0 | 51 |
| Normal, pack absent (V3) | Purple (3) | 200 | 143 | 57 | 0 | 57 |

Compare these finite native outcomes with B6's Hard enabled counts above.
They support a remaining native Hard/Normal difference and an additional
enabled Hard reward path, including observed doubles. They do not establish
exact population probabilities. The documented implementation adds a separate
0.17 roll; no precise final probability or one-pickup cap is specified by the
repo. The samples alone therefore do not justify changing that preserved
balance default. Normal pack-on gating still needs its recorded comparison.

Native Dagger fields were damage 15 / size 10; actual collision attempts were
15 without BFFS and 30 with BFFS while the exposed damage field stayed 15.
Enabled B2/B4 recorded fields 30 / size 13 and actual attempts 30 / 60. Native
Cube of Meat variants 44 and 45 had damage 7 / size 8, versus enabled 14 / 13.
Both native Dagger windows retained their target anchors, zero observed drift
and 157 AI-suppressed frames. These representative increases were not already
restored by the native build; they are not fixed DPS estimates or certification
of every orbital variant.

With Pyromaniac, the same synthetic engine crush request returned true and
changed four red half-hearts to two in both native profiles. Enabled batches
returned false and changed four to six. This confirms the implemented
crush-cancellation/healing contract in the engine, separately from the actual
Mom/Host Hat comparison. It does not substitute for a native Mom/Pyromaniac
attack or establish all stomp sources in issue #2.

The native Relic started at counter 0. V1 observed seven actual clears with
counter values 1 through 7 and one familiar-attributed soul-heart initialization
at the seventh clear (frame 1411, familiar seed 1515331550, pickup seed
1921482691). V3 observed six clears with counters 1 through 6 and no payout.
Neither profile had an unresolved room. The recorded payout ordinal is an
observation, not a universal interval or reset rule; initialization, animation
and room-entry ordering remain relevant. Enabled initialization at 2 is already
corroborated, but its longer native payout/reset comparison remains pending.

All three complete records report zero cleanup errors and return to room 84
with original actor health/positions and managed item counts restored. Fresh
logs contained no matching Lua-error/traceback or mod-state Continue-refusal
lines. No such claim is inferred from the mere presence of a content folder.

Evidence directories and SHA-256 hashes (relative to the same Windows session):

| Profile | Directory under `evidence/` | Full log bytes / SHA-256 | Valid JSONL SHA-256 |
| --- | --- | --- | --- |
| V1 | B5-B6-20261109T234757973Z | 42,892 / `6881800c1a1406ccec17677f66807e5f4b4d9eb56e51808b524b0b00ed8481e5` | `ea967f5105633945504061f9bb3162a9cc47e07a4cbb06eb1974389ca28cd412` |
| V2 | B5-B6-20261110T000055115Z | 458,527 / `a743a342bcd87f1ad867bd110c17d3d3e8fc1ce1d91d4f129d342f9f46416294` | `d40760b28833139a2605baaa1f25dbaa359fe4ad6640696532ac834d933921f7` |
| V3 | B5-B6-20261110T001139290Z | 961,609 / `e5a63e0fe8b3780e4babf942961e89999a457c92651f20d35b8a3a4e6217d2ac` | `cbb9ee7ac29bfcc274b716fc6f852733818eebc7898cea11a65e5d8ab35fa006` |

The V3 complete record and file hash were cross-checked against the actual
command output after a natural-language child summary mistranscribed them.
The saved raw JSON is valid; it contains the unchanged health/positions stated
above. No engine replay or artifact rewrite was needed.

After the owner again exited, the guard confirmed no game process and verified
both transition manifests, the owned empty marker, all 13 production files,
the immutable observer and the v4 helper. Only that marker was removed at
2026-11-10 00:25:08 UTC, re-enabling the pack. The restoration journal SHA-256
is `d6f3028d4f88d1f813d006e34f500453346d18d5ffe4c1de70247a48417ba0f1`.
No user data or game mod-data files were written; backups remain preserved.
The owner then executed the two enabled profiles below with the same unchanged
production and helper hashes.

### P1–P2: enabled Normal comparison and Relic reset

`P1-normal-enabled-full` completed 400/400 on fresh Normal Isaac, seed
3698371794, luck 0, with all seven active gates On. Native Dagger contact and
Cube fields again showed the enabled values recorded above. Pyromaniac's
synthetic crush request again returned false and changed red half-hearts 4→6.
The Relic advanced 2→3→4→5→6 through all four eligible rooms available on that
floor, without a payout. This exhausted the eligible room set; completing fire
trials was not treated as completing payout coverage.

| Normal profile | Variant | Eligible trials | Zero hearts | One heart | Two hearts | Total hearts |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| Pack absent (V3) | Blue (2) | 200 | 149 | 51 | 0 | 51 |
| Pack enabled (P1) | Blue (2) | 200 | 143 | 57 | 0 | 57 |
| Pack absent (V3) | Purple (3) | 200 | 143 | 57 | 0 | 57 |
| Pack enabled (P1) | Purple (3) | 200 | 145 | 55 | 0 | 55 |

P1 independently had 400 unique eligible fireplace identities, no duplicate
trial records, no non-explosion damage events and no malformed records. All
observed hearts were subtype 3. These finite samples are consistent with the
source's Hard-only extra-roll gate; they do not prove equal exact Normal
population probabilities or an impossible double outcome in every setup.

To reach a native Relic payout without repeating a large fire sample, the owner
used `stage 6` in the same disposable Normal run, allowed the floor transition,
then ran the unchanged helper with `mechanics=true`, `trialsPerVariant=1` and
label `P2-normal-relic`. This is a continuation of the same run seed, not a
fresh/Continue acceptance test or a reproducible item-access seed claim.
It completed 2/2 fire trials and eight actual hostile clears, with zero
unresolved rooms. Familiar seed 2781335662 remained the same across the clears:

| Actual clear ordinal | Before counter | After counter | Native payout observation |
| ---: | ---: | ---: | --- |
| 1 | 2 | 3 | None |
| 2 | 3 | 4 | None |
| 3 | 4 | 5 | None |
| 4 | 5 | 6 | None |
| 5 | 6 | 2 | Soul heart, pickup seed 3761609571, frame 4890; familiar counter already 2 in pickup observation |
| 6 | 2 | 3 | None |
| 7 | 3 | 4 | None |
| 8 | 4 | 5 | None |

The pickup observation precedes the fifth clear's after-window snapshot at
frame 4984. It supports native payout and the pack's reset-to-2 behavior;
subsequent native increments confirm that the same familiar kept counting.
The fixture never wrote its counter. Native Normal V3 had no payout in six
actual clears, and native Hard V1 first observed one at the seventh clear.
The representative earlier enabled payout is therefore corroborated; these
different runs do not establish a universal exact interval, multiple-Relic
behavior or a second completed payout cycle.

Both P1 and P2 complete records restore original player damage, health,
positions and zero managed item counts, return to room 84 and report no cleanup
errors. P2's log retains P1 and shows execution of the enabled pack's `main.lua`,
J460, the immutable observer and v4 helper. The bounded error-term scan finds
no Lua-error, traceback or mod-state Continue-refusal lines. Test room clears
and the owner's floor transition remain disposable-run changes, not rollback
of the map or restoration of the pre-validation saved run.

| Profile | Directory under Windows session `evidence/` | Full log bytes / SHA-256 | Valid JSONL SHA-256 |
| --- | --- | --- | --- |
| P1 | P1-20261110T004019261Z | 511,833 / `6a70b30d656f3973b9c3724f06f0096ba2acc457c74eb6e8dd63723994832d27` | `beb94102e4b9b1d56083c72117057ff19cf404cee0ca9a30f41c4fe054e54fe2` |
| P2 | P2-20261110T004504762Z | 542,052 / `bec0ac139888af1dea4ee7a223ab7aa8900c55dd7bee9a6e3a0a3b3cf46eb21f` | `dd4bed8fc30de7e8c93eac4cc59fc48a3458139cee7ef02ce24cc02697691894` |

Stable shared-read captures retain 1,457 valid P1 records and 49 valid P2
records, with no malformed records. The main agent parsed the actual command
output for the decisive complete, clear and payout records. No further gameplay
batch is planned; remaining per-feature limits belong in the acceptance matrix.

### Owner-selected cleanup and handoff

The owner confirmed exit to desktop and chose to keep the tested pack and MCM,
removing validation tools. The first archive-plus-recursive-delete command was
rejected before execution, with no more specific policy reason returned. It
made no changes. A safer, reversible same-volume directory move then succeeded
after process/provenance guards, a before manifest and protected-file snapshots.

At 2026-11-10 00:54:36 UTC, all 12 observer/optional-helper files were archived
outside the game at `D:\T3ValidationArchives\ounp-observer-20261110T005435597Z`.
The original `mods/open_unnerf_validation_observer` directory is absent. Archive
file hashes match the before inventory. All 13 production files still match
f1c8325; full before/after hashes of the pack, MCM, user-data and game-data trees
are unchanged. No saved run was restored or engine launched after cleanup.
The game remained closed, and original validation backups were retained.

Cleanup artifacts are Windows session
`cleanup-keep-pack-20261110T005435589Z/before.json` (SHA-256
`591b848c9824c0e2d7cf4425e6911d7e131ab3312398700e58258625c97c2f41`)
and `after.json` (SHA-256
`c5ea5ced5da502125df51c438a9d74ed19cd4de1de043a9915dd62b783b04286`).
For a future coordinated diagnostic session, verify the recorded archive
inventory while the game is closed and move it back only if the original
observer directory is absent. This is not needed for ordinary play.

Issue #1 stays open: whole-pack-absent Maw, Dark Bum and Bundle comparisons
remain outstanding, and the broader historical stomp criteria stay in #2.
Existing feature-Off comparisons and the narrower native stomp evidence are
retained with their actual scope. The owner requested sensible bounded testing;
unexecuted edge cases are listed as unknown rather than issuing more per-case
console prompts or treating them as passes.

Run requires a cleared disposable room and no Relic, Dark Bum, Maw or Humbling
Bundle on any actor. It records the actual difficulty, actor types, health,
damage/luck, feature gates, seed, positions and trial identities. Pack-absent
controls use the same fixture; an operator's deployment label is not proof of
installed bytes.

The sampler temporarily places actors away from a clear fire-test point.
It spawns one blue or purple fireplace, allows native updates, requests one
`Isaac.Explode(...,100)`, then observes actual damage callbacks, extinguishing
animation and heart pickups. An extinguished fireplace may retain positive HP;
HP alone is not a death predicate. No direct RNG calls or synthetic pickup/death
callbacks are used. It records heart init/update provenance and 0/1/2+ outcome
counts, including subtypes. Nearby ambient loot is not attributed solely by its
final position. The short first smoke uses one trial per variant; the bounded
full run allows at most 200 per variant.

Completion/Stop removes owned fixtures and exact callback references and restores
actor positions. Logging/API errors defer entity cleanup until native damage
handling has unwound. Existing pickups remain untouched. Native explosions can
alter nearby terrain, so this is not intended for an important live run.
Player health, room identity and actor count are checked; a mismatch aborts.

With `mechanics=true`, actor zero must have at least six red half-hearts and no
soul/black hearts. Unsupported health is rejected before fixture mutation; other
actors' health remains untouched. The same runner performs these bounded cases:

- A real engine crush-damage request with Pyromaniac, temporarily using four
  red half-hearts. It records before/after health and restores the original
  health/item state. This is explicitly **synthetic engine input**, not a
  native Mom attack; the existing Host Hat/Mom evidence remains separate.
- Sacrificial Dagger contact against an anchored, AI-suppressed high-HP target, before/after
  BFFS. Native damage attempts, target HP, familiar identity, collision fields
  and timing are recorded. One/two Cube of Meat states record native entity
  lifecycle without manufacturing a familiar transition.
- Relic initialization and up to eight real uncleared hostile map rooms
  (one in the smoke). Native NPC `Kill()` clears the rooms; no room-clear flags
  or familiar counters are written. It records counters and familiar-attributed
  pickups. Confirmed test payouts are removed before collection.

Temporary fixture items are removed on completion/Stop/error. The runner returns
to its original room and restores positions where available. Actual cleared map
rooms and explosion terrain are not rolled back: use the current disposable run,
with the coordinated original-save backups preserved. Native damage cooldowns
protect actors during all non-crush phases and expire normally.
Stop after completion or an earlier Stop only unloads the interface; it does not
replay rollback against subsequent player actions.

Only after a successful smallest engine smoke will a full batch be requested.
Illustrative protocol, **not a current owner instruction**:

```lua
luarun mods/open_unnerf_validation_observer/compatibility-batch.lua
lua OUPBatch.Run({trialsPerVariant=1,mechanics=true,smoke=true,label='smoke'})
lua OUPBatch.Run({trialsPerVariant=200,mechanics=true,label='recorded-profile'})
```

The owner closes the console to let native frames advance. Logs use
`OUP_ENGINE_BATCH`; shell collection and analysis belong to the agents.
Stubbed `tests/engine_batch_spec.lua` checks accounting and cleanup only,
including ambient-heart exclusion and deferred error cleanup. Its pass is not
fire probability, vanilla or compatibility evidence.

## Evidence limits

The recorded batches verify the representative native execution above,
including one enabled Relic payout/reset and the Normal pack-on fire sample. A
no-contact orbital window or insufficient hostile rooms is
recorded as incomplete coverage, not a pass. Familiar type/seed changes remain
raw observations rather than assumed continuity. Counts from stub tests do not
establish a native payout interval or damage multiplier.

Keep the remaining changes together in the issue-1 continuation PR. A small
number of recorded pack-present/pack-absent runs should cover the high-risk
mechanics; unexecuted edge cases remain unverified, not additional per-case
owner prompts.
