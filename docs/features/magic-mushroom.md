# Magic Mushroom pools

[All features](README.md) · [Configuration](configuration.md)

## Overview

Restore Magic Mushroom's availability in the normal Boss pool and its full
weight in the normal Treasure pool on **Repentance+ v1.9.7.17** (owner executable
**1.9.7.17.J460**). This changes where and how often the item can be selected;
it does not change Magic Mushroom's item effects.

## Behavior

On the target vanilla build, Magic Mushroom is absent from the normal Boss pool
and has reduced weight in the normal Treasure pool. With this adjustment On:

- Normal Boss rewards can select Magic Mushroom at weight 1.
- The existing normal Treasure availability is restored from weight 0.5 to 1.

These are selection weights relative to other eligible items, not a guaranteed
pickup or a fixed percentage chance per room. Availability still depends on
pool depletion and the game's other selection rules. The native weights and
depletion values in Greed Treasure, Greed Boss and Ultra Secret are preserved;
this adjustment does not restore Magic Mushroom to every pool or change other
items' intended weights.

The implementation uses the pack's pool-rule helper to make these logical
changes. It is not a literal in-place rewrite of Magic Mushroom's original XML
entry. See the [pool-rule technical reference](../agents/pool-rules.md) for the
mapping contract and limits.

## Configuration

**Default:** On. **Saved key:** `magicMushroom`. The optional MCM entry is
**Magic Mushroom pools: On/Off** under **Open Unnerf Pack 2 → Unnerfs**.

Changes save immediately for the next **new run**. **Continue retains the run's
saved setting**, including after relaunch, even if the menu now shows a different
choice. Pool entries are not appended or reset on Continue. Off uses the native
Magic Mushroom pool behavior. If no matching run snapshot is available, saved
choices are used; see [configuration and fallback rules](configuration.md).

## Dependencies and limits

This feature requires the pack and its included content files on the supported
game build. MCM Pure v113 is optional; no additional pool API mod is required.
There is no explicit character restriction. Only normal Boss and Treasure
availability/weight is intentionally changed; Greed modes do not receive the
normal-mode restoration.

Recorded native tests corroborate the Treasure weight relationship, controlled
Boss availability/depletion, same-content unaffected-pool comparisons, real-item
conversion and persistence across a full process restart with Continue. Those
results do not establish an exact total drop probability. Natural Lemegeton,
early starting-item grants and co-op interactions are not engine-verified.
Scripted grant/removal cleanup did not fully pass; the ledger preserves that
failure separately from successful conversion checks. Other lifecycle and
mod-interaction combinations, individual Greed/Ultra Secret exhaustion and
complete item-reroll coverage are not certified. An earlier comparison across installations
with different content failed and remains unexplained; installing this content
does not promise identical seeded outcomes. The successful unaffected-pool
comparison used the same content with this feature On and Off.

Other mods that change Magic Mushroom's type, quality or tags can trigger a
fallback to native selection. That fallback cannot restore original entries
already removed from a saved run. See the technical reference before changing
such mods during a run.

## Related features and technical reference

- [Configuration](configuration.md): saved choices and new-run/Continue rules.
- [Pool-rule implementation and contract](../agents/pool-rules.md).
- [Magic Mushroom native validation](../testing/magic-mushroom-1.9.7.17.md): exact
  setups, passed comparisons, retained failures and remaining limits.

---
*Last updated: 2026-11-11*
