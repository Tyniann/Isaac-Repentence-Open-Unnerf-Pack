# Feature reference

Open Unnerf Pack 2 targets **The Binding of Isaac: Repentance+ v1.9.7.17**
(owner executable **1.9.7.17.J460**). These pages describe the currently loaded
adjustments, rather than promising an exact recreation of every earlier Isaac
version. [Return to the project README](../../README.md).

## Supported adjustments

All ten gameplay adjustments default to **On**. Each has its own saved toggle
under **Open Unnerf Pack 2 → Unnerfs** in optional Mod Config Menu Pure. Turn any
off for native behavior in a new run; **Continue retains the run's choices**.
See [configuration](configuration.md) for menu names, persistence and fallback.

| Feature | Adjustment | Default | Saved key |
| --- | --- | --- | --- |
| [Maw of the Void](maw-of-the-void.md) | +1 damage per copy; restore qualifying dark-ring black-heart drop field | On | `mawOfTheVoid` |
| [Orbitals](orbitals.md) | At least size 13 and double collision damage for qualifying familiars, excluding blue flies | On | `orbitals` |
| [Stomp immunity](stomp-immunity.md) | Host Hat/Pyromaniac crush and Mom-foot protection; Pyromaniac crush healing | On | `stompImmunity` |
| [Humbling Bundle](humbling-bundle.md) | Convert eligible single red-heart/penny/key/bomb selections to double packs | On | `humblingBundle` |
| [Dark Bum](dark-bum.md) | Convert eligible familiar-attributed pickup rewards to soul hearts, with character exclusions | On | `darkBum` |
| [The Relic](the-relic.md) | Advance/reset its room-clear counter to 2 | On | `relic` |
| [Hard-mode blue and purple fires](blue-fires.md) | Extra 17% soul-heart roll per eligible explosion-damage event on Hard | On | `blueFires` |
| [Magic Mushroom pools](magic-mushroom.md) | Restore normal Boss availability and full normal Treasure weight | On | `magicMushroom` |
| [Void choice absorption](void.md) | Absorb eligible items from ordinary linked choice groups while retaining the four-room charge | On | `voidChoiceAbsorption` |
| [Sack Head](sack-head.md) | Restore its historical Shop-pool entry and add a chance for eligible rewards to become another sack | On | `sackHead` |

Dark Bum, The Relic and blue fires share a source folder, but are independent
features with separate toggles and pages. Magic Mushroom's independent pool
adjustment changes normal Boss/Treasure availability and weight without changing
its item effects; see its page for the helper-backed implementation and limits.

## Optional configuration support

[Configuration and Mod Config Menu](configuration.md) is a dedicated reference
for the optional **MCM Pure v113** integration. The pack works without MCM;
settings belong to the pack and use Isaac's per-save-slot mod data. Configuration
support does not itself change gameplay beyond selecting these adjustments.

## Unfinished and disabled

| Code present | Current status |
| --- | --- |
| [The Nail](the-nail.md) | Unfinished, disabled in code; no supported toggle or active adjustment |
| [Satanic Bible](satanic-bible.md) | Unfinished, disabled in code; no supported toggle or active adjustment |

Their helper files are loaded, but their enabling flags are false. They are not
supported working features. Wishlist requests are not included in this inventory.

## Evidence and coverage

This inventory was checked against [registered settings](../../config.lua), the
[root loader](../../main.lua), and all modules it loads, including the
[soul-heart feature loader](../../Mods/Soul%20Heart%20Generator%20Unnerf/main.lua).
The ten keys above each map to one feature page; neither disabled
helper has a registered setting.

Compatibility (#1) and optional configuration (#3) are resolved for their bounded
acceptance scope covering the original seven adjustments. The
[current acceptance matrix and assessment](../testing/issue-1-engine-results.md#acceptance-matrix)
cover representative native behavior and anti-stacking controls. The
[configuration results](../testing/configuration-results-1.9.7.17.md) cover all
seven original independent gates, persistence and fallback. [Native batches](../testing/native-batches.md)
retain pack-absent comparisons and observed fire double rewards. A feature-Off
control and a pack-absent control are identified separately in those records.

The [Magic Mushroom validation ledger](../testing/magic-mushroom-1.9.7.17.md)
separately records the eighth feature's native weight/availability, independent
On/Off behavior and full-process Continue evidence. It retains the failed
cross-build comparison and scripted cleanup fixture separately from valid
same-content comparisons and item conversions. See the [pool-rule technical
reference](../agents/pool-rules.md) for its implementation contract.

Void choice absorption has an [issue-specific validation record](../testing/void-choice-1.9.7.17.md).
It records native 1.9.7.17 absorption comparisons, room checks, process-restart
Continue, physical charge use and their unexecuted limits.

Sack Head's Normal-On/Off checks, natural reward chain, actual Greed-mode pool
check and original-profile restoration have passed. The Greed check covered
isolated pools only; no Greed reward-chain or Greedier run was performed. See
the [feature page](sack-head.md) and [technical validation
reference](../agents/sack-head.md) for evidence, limits and the linked issue
ledger.

The pages distinguish source behavior from observed results. They do not claim
exact total drop probabilities, every character or reward source, all orbital
or stomp variants, Greed modes, general multiplayer, or compatibility with every
other mod. Avoid enabling duplicate Workshop/standalone copies of these unnerfs.
