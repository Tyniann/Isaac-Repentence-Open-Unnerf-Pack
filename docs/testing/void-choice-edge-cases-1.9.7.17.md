# Void native edge-case regressions

Issue: [#17](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/17).
Session started: 2026-11-12. Status: **local protocol verified; native pilot pending**.

## Purpose and source

This follows the [source research](../research/void-choice-edge-cases.md) and
the [issue #16 validation](void-choice-1.9.7.17.md). The previous alternate-path
check morphed generated subjects into known books; it did not establish the
untouched mystery item's identity or presentation. No captured case measured
the native Polaroid/Negative pair.

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

## Native observations

| Case | Status |
| --- | --- |
| Mom photo pair, feature Off pilot | Pending |
| Photo Off / native-unlinked / On comparison | Pending |
| Untouched mystery identity and natural hidden presentation | Pending |
| Mystery Off / native-unlinked / On comparison | Pending |

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

At completion, capture logs before restoring state. With the game closed,
move the owned diagnostic folder into the archive, restore the scoped originals,
verify protected files and other slots against the immediate pre-cleanup state,
retain private backups/evidence, and return session ownership to the owner.
