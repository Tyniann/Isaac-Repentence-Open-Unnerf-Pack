# Void native edge-case regressions

Issue: [#17](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/17).
Session started: 2026-11-12. Status: **pilot and all six native comparisons captured; session cleanup verified; PR review pending**.

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

Neither full Chapter 6 route transitions nor a naturally hidden active-item
timing case is claimed by these fixtures. Progression implications must be
stated using the actual ownership/consumption result without equating stat
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
missing protected files. The game is closed and session ownership is returned
to the owner; no diagnostic callbacks survive process exit.
