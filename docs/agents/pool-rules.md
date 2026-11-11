# Native pool rules

## Overview

Use this module for a configurable **pool-only** balance revert that native
Lua cannot implement by editing an existing pool row. It uses a private native
collectible identity and maps selections back to the real collectible. It does
not provide arbitrary pool insertion, reset, item-effect replacement or a
general-purpose item API.

This contract describes the Magic Mushroom implementation accepted for issue
[#4](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/4).
The owner permits helper-backed logical behavior; the physical vanilla ID 12
record is not rewritten. Keep player behavior in the feature reference and
link implementation/validation details here.

## Implementation and entry points

- [Loader](../../main.lua) loads configuration before feature modules.
- [Magic Mushroom registration](../../Mods/Magic%20Mushroom%20Unnerf/main.lua)
  calls the cached [pool-rule module](../../Mods/Pool%20Rules/main.lua).
- [Configuration](../../config.lua) owns saved choices and run snapshots.
- [Helper definition](../../content/items.xml) and
  [partial pool additions](../../content/itempools.xml) provide native content.
- [Rule contracts](../../tests/pool_rules_spec.lua),
  [asset checks](../../tests/pool_assets_spec.py) and
  [configuration checks](../../tests/config_spec.lua) cover local contracts.
  These are not engine evidence.

The registration interface is:

```lua
require("Mods/Pool Rules/main").Register(
    "magicMushroom", 12, "OUP Magic Mushroom Pool Entry")
```

Each registration has one unique configuration key, real collectible and helper
identity. Register the key in configuration too. Duplicate keys/targets/helpers
are rejected. A missing helper logs a diagnostic and returns false without
disabling other modules. Resolve the helper by name; its observed numeric ID
733 is deployment evidence, not a stable ID to hardcode.

## How it works

The helper must mirror **every** native pool containing the original, because
`ItemPool:RemoveCollectible` removes an identity globally. Do not add only the
two restored normal rows and inadvertently lose the Greed/Ultra Secret rows.

| Magic Mushroom helper pool | Weight | DecreaseBy | RemoveOn |
| --- | ---: | ---: | ---: |
| treasure | 1 | 1 | 0.1 |
| boss | 1 | 1 | 0.1 |
| greedTreasure | 0.5 | 0.5 | 0.05 |
| greedBoss | 0.2 | 0.2 | 0.02 |
| ultraSecret | 1 | 0.4 | 0.1 |

On excludes the original identity; Off excludes the helper. Type, quality and
tags must match the real item. At preparation, a mismatch excludes the helper
rather than removing the original; it cannot reconstruct an original entry
already excluded in saved pool state. A post-selection mismatch removes the helper and
retries the native last pool rather than exposing it. Hidden status is not used
to hide the helper from selection: the tested helper is a selectable passive
with quality 4 and `summonable mushroom offensive` tags, without direct stat or
health bonuses. Normal selections return the original collectible's effects.

Callbacks divide responsibilities:

- `MC_PRE_GET_COLLECTIBLE` prepares exclusions before the first native roll.
- A configuration run-start listener confirms the selected active snapshot
  before save/cache evaluation. Preparation only removes; it never appends or
  resets weights, including on Continue.
- `MC_POST_GET_COLLECTIBLE` translates helper selections to the real ID.
- `MC_POST_PICKUP_INIT` morphs a directly spawned helper pedestal to the real ID.
- `MC_POST_PEFFECT_UPDATE` converts each actually owned helper copy using true
  ownership counts, then synchronizes helper exclusion when any player owns the
  real item. A modifier alone must not create a permanent collectible.
- Player initialization and game exit invalidate preparation; the current
  start seed also guards the preparation cache.

Do not assume another pool is unspent after drawing once. The native test
observes all five identities available before a Treasure draw and all five
unavailable afterward. Independent fresh runs or measured before/after anchors
are needed for depletion comparisons.

## Data and state

No new save schema is introduced. Existing version-1 mod data stores selected
choices in `settings`, and the current run's start seed/settings in `run`.
`magicMushroom` is the eighth default-On Boolean, displayed as **Magic Mushroom
pools**. The other seven defaults and disabled Nail/Satanic Bible are preserved.
MCM is optional; pack-owned data remains authoritative.

Choices are saved immediately and apply to a new run. Continue reloads the
selected save slot and retains its matching run snapshot. Early pool-generation
preview reloads that slot without writing data or changing other features'
active cache: frame zero uses choices, while a matching seed past frame zero
uses the snapshot. Early starting-item timing remains untested in-engine; the
recorded cold-Continue and fresh-run cases do not imply every starting-item or
character path was exercised.

Native pool state owns weights and depletion. Lua keeps only transient rule,
preparation and ownership-tracking tables. Losing an owned item resets the
tracker, but does not reinsert entries; native rewind/save behavior must not be
replaced with ad hoc additions.

## Operation and validation

Follow [shared game validation](game-validation.md) before deployment or owner
console guidance. The [Magic Mushroom ledger](../testing/magic-mushroom-1.9.7.17.md)
records immutable build pins, captures, exact results and limitations.

Use intact-pool nondecreasing profiles for relative rates. An isolated pool can
hit native repick limits and is not a valid proportional-weight control. Use
isolation only for controlled availability/depletion and archive a positive
unspent anchor before a cold-reload test. The same-content target-excluded
comparison passes; the older cross-build comparison fails and does not support
a promise of identical seed mapping after installing custom content.

Actual grants must follow depletion/reload tests, since ownership removes the
helper globally. One- and two-copy conversion are observed in-engine. A forced
private item-wisp remains a modifier, but its fixture's cleanup fails: removing
the entity or issuing native item removal retained its virtual count. Preserve
that overall failed result separately from successful conversion; discard the
disposable run rather than guessing cleanup APIs. Natural Lemegeton selection,
early starting items and a co-op matrix are not claimed verified.

The [observer archive script](../../tools/validation/archive-magic-mushroom-observer.ps1)
is pinned to the tested shared installation and observer hashes. It requires
Isaac closed, snapshots the pack/MCM/game-data/user-data trees, moves only the
observer to a new same-volume archive and verifies those protected files are
unchanged. Inspect its fixed paths/hashes before future reuse; do not use it for
an unrelated observer or as a save-restore tool. It never launches the game,
deletes saves, restores old runs or modifies other mods. Retain original backups.

## Dependencies and related documentation

The recorded target is native Repentance+ 1.9.7.17.J460 with optional MCM Pure
113. No external pool-editing extension or extra player installation step is
required. The original item effects and unrelated pool rows remain native.

- [Configuration validation](../configuration-validation.md)
- [Native validation batches](../testing/native-batches.md)
- [Magic Mushroom evidence and assessment](../testing/magic-mushroom-1.9.7.17.md)

See the [technical index](README.md) for the module and validation references,
and the [Magic Mushroom feature page](../features/magic-mushroom.md) for player
behavior and configuration. Implementation contracts and diagnostic procedures
remain separate from the player-facing feature inventory.

---
*Last updated: 2026-11-10*
