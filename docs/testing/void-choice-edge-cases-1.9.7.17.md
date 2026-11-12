# Void native edge-case regressions

Issue: [#17](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/17).
Session started: 2026-11-12. Status: **photo/passive and selected naturally hidden-active native comparisons captured; both session cleanups verified; Standards and Spec reviews complete with zero findings**.

## Purpose and source

This follows the [source research](../research/void-choice-edge-cases.md) and
the [issue #16 validation](void-choice-1.9.7.17.md). The previous alternate-path
check morphed generated subjects into known books; it did not establish the
untouched mystery item's identity or presentation. Before this follow-up, no
captured case measured the native Polaroid/Negative pair.

The starting release is v2.1.0, commit
`e2b71f9fc81a6880694e565e29bcd192a1aa8102`. Production remains unchanged unless
native comparison demonstrates a defect. The diagnostic entry point is
[void-choice-batch.lua](../../tools/validation/void-choice-batch.lua), described
in the [technical guide](../agents/void-choice-absorption.md#native-photo-and-mystery-item-regressions).
This work does not replace the published v2.1.0 tag or assets.

## Fixture contract

- A new disposable Normal Isaac run is selected through a native restart and
  native seed command. The actual run seed is asserted after the game-start
  callback; a changed seed label is not used to imitate regeneration.
- Mom's real reward is generated on the native Depths II boss floor. The
  diagnostic waits for exactly Polaroid (327) and Negative (328), retaining
  their identities, native option indices, touched state and prices. It does
  not assume a nonzero option index or a particular immunity policy.
- The alternate-path first-floor Treasure Room retains both original items.
  EID's installed vanilla `IsAltChoice` sprite observer must identify exactly
  one naturally hidden item. Both subjects must be untouched, free passive
  items with a real shared group. At most eight deterministic seed candidates
  are considered; rejected fixtures are retained in the log.
- This passive cohort permits a direct reward comparison without triggering
  arbitrary hidden active effects. It is not a hidden-active timing test;
  controlled book timing and Continue remain separate issue #16 evidence.
- Off, Off-unlinked and On reuse the chosen seed and original subjects. The
  control changes links only. Before each single native use, Void's RNG is
  explicitly seeded to 160477, shift 35. This is a controlled differential
  experiment, not a claim about natural RNG distribution.
- On must match the native unlinked control's reward state and surviving
  identities. Every original item remains unowned; surviving On pickups must
  recover their original option indices after deferred cleanup. Off behavior
  is measured rather than assumed, including the photos' native eligibility.

## Local checks

`lua tests/void_choice_edges_spec.lua` passes. It checks inert loading, rejects
a missing blindness observer before mutation, exercises seed handoff and a
rejected active-item candidate, prohibits subject Morph/replacement, preserves
original fixture snapshots, reuses the selected seed across controls, and
restores the original settings. An intentionally corrupted On reward causes
the comparison to fail. Its mock API outcome is fixed and does not prove
native rewards, rendering, Mom reward generation or item eligibility.

`lua tests/void_choice_batch_spec.lua` still passes, including the existing
Continue protocol check. Lua syntax checks pass for the modified runner.
The local harnesses do not establish native hidden-active timing; see the
captured engine results below.

After native capture, a logging-only correction adds `cohortSeed` to comparison
records. Their ordinary `seed` field describes the final emission run, which
is the alternate-path run even for the photo summary. A red/green protocol
assertion verifies the explicit cohort field. This does not change fixture
inputs, native uses, comparison thresholds or production behavior, so the
captured engine comparisons remain applicable. The executed source hash below
is retained rather than relabeled as the later logging revision.

## Native observations

### Initial stage

Fresh archive:
`D:\T3ValidationArchives\issue17-20261112T000516Z-3c3c31`.
The game-closed precheck passed. Slot-1 files, existing slot-1 automatic backups
and game mod data were copied before installation, with original existence
recorded. The diagnostic is the new `mods\oup_void_edge_probe` folder; the old
issue #16 probe is absent. All 501 protected files were unchanged during stage.

Runner source commit: `ebda9d43710d4cd1af8e387dbd31477d49cef05d`.
Installed `main.lua`: 34,866 bytes, SHA-256
`d60850132496381938e5b0c41e3045e7bb6d6e1c3463c0b716fe3a04b9152832`.
Diagnostic metadata SHA-256:
`f308268976f085d86bcad5e84f82537e069d45cbceb4f8750b45f767e0ff4255`.

Executable SHA-256 matches the target-build executable:
`e5faf6f513c6de9cc9ff1c335ef9c541e2b33fc623aa3b8ffbd2e6a6c0027bb0`.
The three production Lua hashes match issue #16's accepted source, including
Void module `69a2562786f15642030df823016bf0d317eaa7e3adfe88aa895017300575a44e`.
No production files were replaced.

The installed EID source was preserved and inspected. Its `IsAltChoice` uses
the vanilla question-mark texel comparison and rejects Curse of the Blind.
EID `main.lua` SHA-256:
`143af9c2f21757167650122965cddf07335e7fa988a526360558357422c47875`;
`features/eid_api.lua` SHA-256:
`91d794d427be6f6af9e0aee3f217d5da8d73a2e3141ec88127891c5c55af72a9`.
Installed enabled folders are EID, MCM Pure, Open Unnerf Pack 2, Visible Tinted
Rocks with yellow mark, and the new diagnostic. Runtime versions and observations
are corroborated below; file staging alone is not gameplay evidence.

### Native Mom photo pilot

The owner reports `OUP_VOID_BATCH_PASS`. The [12 captured
records](evidence/void17-photo-pilot.jsonl) corroborate the pilot on vanilla
Repentance+ v1.9.7.17.J460, local Normal Isaac, save slot 1. Both native
game-start callbacks report fresh runs; the seeded case asserts `212727584`.
EID reports 5.23 / commit `bc0551a`, MCM is present, and REPENTOGON is absent.

Mom's generated reward is in Depths II (stage 6), boss grid 27 / variant 1063.
The original free, untouched Polaroid (327) and Negative (328) both have native
group 3 and the quest tag. With Void choice absorption Off, the first native
use changes range 260 → 360 and luck 0 → 1. The immediate after-use snapshot
still lists Negative; by the settled result both pedestals are gone and both
owned counts remain zero. Thus this target-build pair is not immune to Void,
and quest classification does not protect its route-item ownership. The
later unlinked and On comparisons measure contribution count.
Full photo-gated route transitions were not exercised.

Stable two-read capture: 45,408 bytes, SHA-256
`78a0817932379f64fb77ffe859030f6ebc3162d22fcf9110fff8511ca66d9327`.
Archive:
`D:\T3ValidationArchives\issue17-20261112T000516Z-3c3c31\capture-photo-pilot-20261112T001533Z-27e0e9`.
All 12 payloads parse, with no malformed records or native warning/error matches.
The installed runner and all three production hashes still match the stage.

The first collector summary incorrectly said no pilot labels were present.
Readback of the already archived JSONL shows the correct `VOID17_PILOT` records
and passing terminal. An ancillary raw-log read then stopped on an incorrect
filename; the original byte captures and metadata remain intact. Neither
collection issue required a gameplay repeat.

### Six native comparisons

The owner reports `OUP_VOID_BATCH_PASS` for the full batch. The captured
[comparison records and terminal](evidence/void17-edges.jsonl) contain six
passing cases and both passing differential checks. Each cohort's three
fixtures match in start seed, item IDs, entity seeds, original groups, natural
blind state and starting stats. All original items remain unowned and no
pedestals survive the settled native use.

| Cohort | Original subjects | Native group | Seed / location |
| --- | --- | --- | --- |
| Mom photos | 327 and 328; both quest-tagged passive items | 3 | `212727584`; stage 6, boss grid 27 / variant 1063 |
| Natural mystery pair | Hidden 222 and visible 62; both non-quest passive items | 1 | `1344027538`; stage 1 / StageType 4, Treasure grid 72 / variant 10 |

The hidden item has real subtype 222 before any use or pickup, while EID's
vanilla question-mark observer reports `blind:true`; visible item 62 reports
`blind:false`. There are no subject Morph/spawn calls in this path. The first
seed already meets the natural passive-pair contract; **no seed was rejected**
in the engine batch. This directly verifies the earlier API inference for the
captured mystery item: its identity is selected before pickup.

Both cohorts start at range 260, luck 0 and speed 1. With the controlled Void
RNG input, the measured settled values are:

| Case mode | Range | Luck | Speed | Subject ownership |
| --- | --- | --- | --- | --- |
| Off, original native links | 360 | 1 | 1 | Neither owned |
| Off, links cleared as native unlinked control | 360 | 2 | 1.2000000476837 | Neither owned |
| On, original native links | 360 | 2 | 1.2000000476837 | Neither owned |

Damage (3.5), tear delay (10) and shot speed (1) remain unchanged. On matches
the native unlinked two-item outcome, including the final Void RNG state;
the Off outcome differs. This establishes the intended extra passive
contribution without a custom stat formula or acquiring the photos themselves.
A new photo-immunity exception is not needed: vanilla already consumes the
pair without granting route-item ownership. Full route entry is still untested,
and no claim is made that Void preserves photo-gated access.

Stable capture: 116,782 bytes, SHA-256
`c6abc194074d568cea89091d2a8a8cb56d97bb8f8f120a930ac20b6094d14fd7`.
Archive:
`D:\T3ValidationArchives\issue17-20261112T000516Z-3c3c31\capture-six-cases-20261112T002324Z-941247`.
Both reads match length, timestamp and hash. All 69 records parse; 57 belong
to `VOID17_EDGES`, including six case results and two comparison records.
No malformed records, rejected candidates or native warning/error matches occur.
All installed Lua hashes match the initial stage, including runner
`d60850132496381938e5b0c41e3045e7bb6d6e1c3463c0b716fe3a04b9152832`.

In the frozen comparison records, top-level seed `1344027538` is the final
emission context. Use each case's fixture seed for cohort provenance; the photo
cohort is `212727584`. Original records are preserved without retrofitting the
new `cohortSeed` field.

| Case | Status |
| --- | --- |
| Mom photo pair, feature Off pilot | Pass; native group 3, stats gained, both gone and unowned |
| Photo Off / native-unlinked / On comparison | Pass; On equals native unlinked rewards, neither photo owned |
| Untouched mystery identity and natural hidden presentation | Pass; original hidden ID 222 recorded before use |
| Mystery Off / native-unlinked / On comparison | Pass; On equals native unlinked rewards for the original passive pair |

Neither full Chapter 6 route transitions nor behavior across all naturally
hidden active items is claimed by these fixtures. Progression implications must
be stated using the actual ownership/consumption result without equating stat
conversion with obtaining a route item.

## Session ownership and cleanup

The owner explicitly handed this thread the closed shared Windows session for
this follow-up and authorized fresh disposable tests with backup/restoration.
Use save slot 1. Create a new issue #17 archive before deployment; do not reuse
issue #16's original state as this session's restore point. Preserve the current
slot-1 run/progress, settings/history, slot-1 automatic backups and mod data,
record original absence where applicable, and protect the production and other
mod sources. Record the actual stage/runner hashes, EID observer source/version,
game executable/build and current mod inventory before accepting engine results.

### Verified cleanup

The owner confirmed full game closure after capture. The
[cleanup receipt](evidence/void17-cleanup.json) records a second closed-game
capture: 130,072 bytes, SHA-256
`9f073c3778efa2522358427d7a29ef4bd7f535a9c70c2120c3181decc2982d64`.
Both final reads match, all 69 payloads parse, and the six-case PASS is present.
Archive:
`D:\T3ValidationArchives\issue17-20261112T000516Z-3c3c31\cleanup-20261112T003320Z-677d9e`.

Cleanup restored this session's original slot-1 run/progress, options, command
history and changed automatic backup, plus changed slot-1 EID/pack data.
Unchanged originals, including MCM data, were verified. All 65 scoped original
files match the fresh archive; no issue #16 restore point was reused. The
displaced test versions remain archived privately.

The two diagnostic files were moved into the archive and their hashes verified;
`mods\oup_void_edge_probe` is absent. All 436 files outside the restore scope
were unchanged during cleanup, including production, other mod sources/data,
executables and other save slots. Production remains at the staged hashes.
The different stage/cleanup counts reflect the separately restored scope, not
missing protected files. The game was closed and session ownership returned to
the owner; no diagnostic callbacks survived process exit. This verifies cleanup
for that session only.

## Fixed hidden-active native results

`OUPBatch.RunEdges(true, 'active')` is the one-case native-unlinked pilot;
`OUPBatch.RunEdges(false, 'active')` compares Off, native-unlinked, and On.
The active cohort uses one fixed, recorded natural fixture rather than searching
for alternate seeds: seed `1344027651`, stage 1 / StageType 4, Treasure Room
grid 111 / variant 11, native group 1. The hidden subject is original item 65,
`TypeACTIVE`, naturally blind, entity seed `4235812924`. The visible subject is
original item 113, `TypeFAMILIAR`, not blind, entity seed `2973825556`. Both
subjects remain native and untouched; there are no Morph or spawn calls. Any
fixture mismatch stops before Void use. The familiar companion is converted by
the engine natively and remains unowned.

All three captured cases use the same starting stats (range 260, luck 0, speed
1). The initial native absorption changes each to range 360, luck 1, speed 1;
the other recorded stats remain unchanged. Both original pedestals are consumed
and neither ID 65 nor 113 becomes owned. No active effect runs immediately.

| Case | Later PRE_USE / POST_USE `USE_VOID` calls | Settled bomb counts | Result |
| --- | --- | --- | --- |
| Off, original links | 0 / 0 on each use | 0 → 0 → 0 | No stored active effect |
| Off, native-unlinked | 1 / 1 on each use | 0 → 4 → 8 | Deferred effect repeats; stored count persists |
| On, original links | 1 / 1 on each use | 0 → 4 → 8 | Matches native-unlinked timing and effect |

The seed and room remain unchanged across later uses. This establishes deferred
execution for this naturally hidden active and visible familiar pair on the
captured build. It does not establish all hidden-active items or full
photo-gated route transitions.

### Staging and evidence provenance

The initial fresh archive is
`D:\T3ValidationArchives\issue17-active-20261112T010151Z-afad76`. The fixed
runner was staged at
`D:\T3ValidationArchives\issue17-active-20261112T010151Z-afad76\fixed-runner-stage-20261112T012340Z-59acf9`;
503 protected files were unchanged, diagnostic metadata was unchanged, and the
original restore point was retained. The executed runner source is commit
`a2b2c39cc671a37604a47fb41a86b41bd5386dc9`, 40,519 bytes, SHA-256
`f13a9449bf24d0c3487e3258c61bdd8f5d507c5e8d8b51ac03581fbeb5384ab2`.

The pilot stable capture is 44,647 bytes, SHA-256
`5eea5f10324e1e44adf2ae211dd55a72285d1e84691b5c356185740367d94790`, at
`D:\T3ValidationArchives\issue17-active-20261112T010151Z-afad76\capture-fixed-pilot-20261112T012646Z-801b77`.
Its 19 records include 18 `VOID17_ACTIVE_PILOT` records; there are no malformed
records, rejected candidates, or warning matches. Runtime was Repentance+
v1.9.7.17.J460, MCM Pure 113, EID present, and REPENTOGON absent.

The full matrix stable capture is 115,244 bytes, SHA-256
`8cde8765b6070da8a4125172c128b5d643ae599aee237d41db0caf19b680ed0c`, at
`D:\T3ValidationArchives\issue17-active-20261112T010151Z-afad76\capture-fixed-matrix-20261112T012933Z-399983`.
It has 69 valid records, including 50 `VOID17_ACTIVE` records, zero seed
rejections, and no warning matches. Three passing `case_result` records and a
passing `edge_comparison` at frame 167 are retained in
[void17-active.jsonl](evidence/void17-active.jsonl). The owner observed
`OUP_VOID_BATCH_PASS`. The raw combined terminal exceeded the native log's
10 KB line limit and ends mid-JSON; it is preserved as captured. Therefore the
raw matrix is **not** described as wholly well-formed or as having a valid
complete terminal. The four exported records preserve the complete passing
case results and comparison without fabricating or repairing that terminal.

After capture, a logging-only correction compacted the combined terminal into
case-name/pass/seed references plus a `caseResultsLogged` marker; the complete
per-case records and internal result object remain unchanged. A meaningful
regression first reproduced the oversized terminal failure and then passed
with the compact summary under 8 KB. This does not change or relabel the
executed source hash or native captures; fixture, native uses and acceptance
conditions are unchanged.

### Fresh active diagnostic stage

The initial staging used the fresh archive
`D:\T3ValidationArchives\issue17-active-20261112T010151Z-afad76`; the game was
confirmed closed twice. Save slot 1, original save data and mod data, and EID
were backed up with original presence recorded. All 502 protected files were
unchanged. The staged source is commit
`4f074ba66a4fa258879c3074ebcc8eafdfbaa37f`; the runner is 40,723 bytes with
SHA-256 `c9de7c5202c5f396f360db195b5f042345dbd9f7e77e50a01ec86b1e2d1c99b2`.
Diagnostic metadata remains SHA-256
`f308268976f085d86bcad5e84f82537e069d45cbceb4f8750b45f767e0ff4255`. The
native hidden-active pilot did not reach a Void use; staging alone is not
gameplay evidence.

### Abandoned seed-search attempt and fixed-fixture replacement

The initial runner (`4f074ba66a4fa258879c3074ebcc8eafdfbaa37f`, 40,723 bytes,
SHA-256 `c9de7c5202c5f396f360db195b5f042345dbd9f7e77e50a01ec86b1e2d1c99b2`)
searched 118 distinct rejected seeds and performed **zero Void uses** before
the owner stopped it. It is not a passing timing test. Its status output showed
only the case name, obscuring progress. The final closed stable log is 594,749
bytes, SHA-256
`a70e54c8d71e1e8898685dd3d1941cad394d251db9e32d44285d09bec4ec7966`, with 477
records (476 `VOID17_ACTIVE_PILOT` labels), no malformed records or warning
matches. Archive:
`D:\T3ValidationArchives\issue17-active-20261112T010151Z-afad76\capture-active-progress-20261112T011719Z-76beb2`.

Review of that progress log identified the usable untouched natural fixture at
seed `1344027651`: stage 1, StageType 4, Treasure Room grid 111 / variant 11,
native option group 1. Hidden item 65 is `TypeACTIVE`, entity seed 4235812924,
with natural blind presentation; visible item 113 is `TypeFAMILIAR`, entity
seed 2973825556. The earlier fixture rule incorrectly rejected the visible
familiar companion as the wrong passive class. The replacement pins this
recorded pair: it stops before any Void use if identity, entity seeds, room,
group or natural presentation differs. It has no active seed retries; the
existing eight-candidate search remains only for the unchanged passive path.

The corrected pilot still runs one native-unlinked case, while the full mode
runs Off, unlinked and On. After native absorption it checks no immediate bomb
spawn, then makes two later native Void uses. The first later use must have one
PRE_USE and POST_USE `USE_VOID` observation and a real increase in bomb count;
the stored count must persist through the next use. The room and run seed must
remain unchanged. Status now reports phase and seed, and the same 3,600-update
bound used by the regular batch applies. The owner stopped and closed the game
after the failed search attempt, then reopened it for the fixed-fixture pilot
and matrix. The fresh original backups remained in the parent archive through
validation and were restored only after the successful closed-game cleanup
below.

### Verified second-session cleanup

The first cleanup attempt stopped at the process precheck and made no writes.
The owner then confirmed the game was fully closed, and the cleanup retry
succeeded. The [full cleanup receipt](evidence/void17-active-cleanup.json)
records archive
`D:\T3ValidationArchives\issue17-active-20261112T010151Z-afad76\cleanup-20261112T014142Z-c0c68f`.
It includes a stable closed-game log of 128,350 bytes, SHA-256
`915610227cc607c3bf8b16c3117e60544746d97e741e9bebeaabf78dae5edc1f`; 69
records parse, and the one known malformed combined terminal is preserved.
All three active cases and the comparison pass in the retained evidence.

Cleanup restored the seven changed slot-1 files covering the native run and
progress, options, command history, today's backup, EID data and pack data.
All 65 original files were verified. The two diagnostic files are archived
with their hashes recorded, and the probe folder is absent. All 436 protected
files remained unchanged, including production and other save slots. No
first-session restore point was reused. The game is closed and the session has
been returned to the owner; this is the verified final cleanup for the active
follow-up.

### Review status

Standards and Spec reviews at commit
`86050fc316ce0ee2acf12893e750fde2fa14584f` each reported zero findings. The
previously missing naturally hidden-active case is covered by the captured
three-case evidence above.
