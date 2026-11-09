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

### Version 4: pending control-fixture improvements

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
These are driver contracts, not native engine proof. Version 4 is not yet
reviewed, staged or engine verified at this checkpoint.

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

The smoke verifies the representative native execution recorded above;
longer cadence samples and pack-absent comparisons remain unverified. A
no-contact orbital window or insufficient hostile rooms is
recorded as incomplete coverage, not a pass. Familiar type/seed changes remain
raw observations rather than assumed continuity. Counts from stub tests do not
establish a native payout interval or damage multiplier.

Keep the remaining changes together in the issue-1 continuation PR. A small
number of recorded pack-present/pack-absent runs should cover the high-risk
mechanics; unexecuted edge cases remain unverified, not additional per-case
owner prompts.
