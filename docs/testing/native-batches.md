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
Its short-orbit placement contract passes locally; **version 2 is not yet staged
or engine verified** at this checkpoint.

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
- Sacrificial Dagger contact against a frozen high-HP target, before/after
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
with the coordinated original-save backups preserved. Relic navigation briefly
protects actors with native damage cooldowns, which expire normally.
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

These mechanics phases are implemented but not engine verified at this
checkpoint. A no-contact orbital window or insufficient hostile rooms is
recorded as incomplete coverage, not a pass. Familiar type/seed changes remain
raw observations rather than assumed continuity. Counts from stub tests do not
establish a native payout interval or damage multiplier.

Keep the remaining changes together in the issue-1 continuation PR. A small
number of recorded pack-present/pack-absent runs should cover the high-risk
mechanics; unexecuted edge cases remain unverified, not additional per-case
owner prompts.
