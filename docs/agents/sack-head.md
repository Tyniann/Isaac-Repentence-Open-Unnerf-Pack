# Sack Head

[Technical documentation](README.md)

## Overview

Issue #20 implements both the historical Shop-pool restoration and a sack
reward chain. Scoped native Normal-On/Off checks, an actual Greed-mode pool-only check,
and restoration of the original profile passed in Repentance+ v1.9.7.17.J460 with
MCM v113. No Greed reward-chain or Greedier run was performed. A native
`[ASSERT] - EL: invalid sublist` was retained between the Off completion and
Greed preparation; its cause is unknown. Implementation and scoped validation
are complete; release publication is separate. Keep implementation claims
separate from the bounded
native results in the [issue #20 validation ledger](../testing/sack-head-issue20.md).

## Implementation and entry points

- **Loader:** [main.lua](../../main.lua) loads the Sack Head module.
- **Registration and chain:** [Sack Head module](../../Mods/Sack%20Head%20Unnerf/main.lua)
  registers `sackHead`, collectible 424 and helper `OUP Sack Head Pool Entry`
  with the [pool-rule module](../../Mods/Pool%20Rules/main.lua), and handles
  eligible sack-origin reward spawns.
- **Configuration:** [config.lua](../../config.lua) declares the default-On
  toggle and saved choice.
- **Content:** [helper definition](../../content/items.xml) and [pool entry](../../content/itempools.xml).
- **Local contracts:** [Sack Head specs](../../tests/sack_head_spec.lua),
  [pool-rule specs](../../tests/pool_rules_spec.lua),
  [asset checks](../../tests/pool_assets_spec.py) and
  [configuration checks](../../tests/config_spec.lua). These are not engine
  evidence.

## Pool behavior

The helper's historical normal Shop entry has weight 1, `DecreaseBy` 0.5 and
`RemoveOn` 0.1. Registration uses the shared helper-backed pool rules. Since
`ItemPool:RemoveCollectible` removes an identity globally, enabling the feature
excludes native collectible 424 from its other native placements; the helper
does not add entries to Treasure, Secret or Greed pools. Disabling it excludes
the helper and leaves the native identity and placements available. The target
restoration is the normal Shop row only.

## Reward-chain behavior

The module listens to `MC_PRE_ENTITY_SPAWN` and only considers spawns whose
spawner is an entity pickup, variant 69 (a sack). It considers these rewards:

| Spawn | Chance of becoming a sack |
| --- | ---: |
| Coin pickup | 10% |
| Bomb, key, card, rune or battery pickup | 20% |
| Non-attacking troll bomb variants 3, 4 or 18 | 20% |

Other origins retain native behavior. Hearts, pills, chests, trinkets,
collectibles and sacks are ineligible. The callback returns a sack spawn
(pickup type, variant 69, subtype 0) with the incoming seed preserved. In the
native sample, the engine resolved subtype 0 to normal subtype 1 for observed
sacks. This confirms the observed result, not the exact distribution of
subtype-0 random selection; black-sack distribution remains unverified.

The rule is global: if any player has collectible 424, a given eligible spawn
gets one draw, regardless of copy count or which player owns the item. It uses
a private RNG seeded from the spawn seed with shift index 35. Each invocation
computes the decision from that immutable seed; there is no persistent decision
cache and it does not intentionally advance native RNG. Feature Off, no owner,
seed zero, ineligible reward types and other source entities leave the spawn
untouched.

## Native validation fixture

The separate [probe](../../tools/validation/sack-head-probe.lua) is not loaded
by production. Its `OUPSackCheck.Start(8)` procedure runs a fresh isolated pool
availability/depletion check, samples four root sacks without Sack Head, grants
the helper when enabled (which converts to the real item), or real Sack Head
when disabled, then samples natural sack descendants with a bounded root budget
of eight. With the adjustment On, if no second-generation sack appears, the
run is inconclusive; `OUPSackCheck.More(n)` can extend the
sample up to 64 roots. `OUPSackCheck.Pools()` runs only the pool check in a fresh
Greed run. The fixture mutates the collectible pool, grants Sack Head, moves
and removes its test entities, and is destructive to the disposable run. It
cleans its fixture entities, but the run must be discarded after checks.

The completed Normal-On and Normal-Off runs verified availability in six
explicit pools. With the feature On, Sack Head appeared only in Shop; Secret,
Treasure, Greed Shop, Greed Secret and Greed Treasure returned fallback
Breakfast. With it Off, Shop, Secret and Greed Secret returned Sack Head, while
Greed Shop, Treasure and Greed Treasure returned fallback Breakfast. A separate
actual Greed-mode pool-only check matched the Normal-On matrix. No Greed sack
chain or Greedier run was performed. After clearing the room blacklist between
queries, the On depletion sequence was 424 for the first decreasing draw, 424 for the next
nondecreasing draw, 424 for the second decreasing draw, then 25 for the next
nondecreasing draw, matching the historical `DecreaseBy`/`RemoveOn` behavior.
This is a controlled availability/depletion check, not an item-weight-rate
estimate. The earlier failed depletion fixture and room-blacklist diagnostic
remain documented in the ledger.

Four native sacks without Sack Head yielded nine rewards and no conversions.
With Sack Head alone (the starting D6 was permitted), five root sacks yielded
six converted sacks; three were generation two. A native reward chain included
a root sack producing a coin that converted into a sack, whose native bomb and
key rewards also converted into sacks. Another root produced a coin that
converted into a sack, whose native key reward converted again. The private
helper grant converted to real collectible 424, with helper count zero. These
observations verify the mechanism and real ownership path, but do not estimate
the 10%/20% rates from this small sample. Local callback boundary tests verify
the thresholds. Native sample categories included coins, keys, bombs, cards and
batteries; troll bomb variants were not sampled. No general co-op, black-sack,
or full reward-source coverage is established.

The checked native case used a fresh owner-reported Isaac slot 1 run, no
Equality! or trinkets, seed `3939804839`, difficulty 0. The production runtime
file map was `f40c7043579205ba7d9e01a2989a94586640979b752e5e558d9d65e413c645af`;
the corrected observer was
`f955f16c00f1f73b57e9b432fc7bc7dc67bd4d0d98db77d9f3b224a1a8d3b631`.
The final recorded status was pass at frame 455. For the original failed
fixture, diagnostic history, and evidence limits, see the
[issue #20 validation ledger](../testing/sack-head-issue20.md).

## Data, limits and related documentation

The toggle uses existing per-save-slot settings and the run-choice snapshot; it
adds no new save schema. With the setting off, both the pool helper and chain
logic are disabled. The original test profile was restored with the pinned driver. Its receipt
reports `restored-original-setup-verified`, unchanged original mods and no
active probe; it certifies the game setup only. GitHub integration is tracked
through issue #20. For the player-facing summary see the
[feature page](../features/sack-head.md); for shared pool contracts see
[native pool rules](pool-rules.md). Issue details and results are recorded in
the [issue #20 validation ledger](../testing/sack-head-issue20.md).

---
*Last updated: 2026-11-14*
