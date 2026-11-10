# Feature reference

Open Unnerf Pack targets **The Binding of Isaac: Repentance+ v1.9.7.17**
(owner executable **1.9.7.17.J460**). These pages describe the currently loaded
adjustments, rather than promising an exact recreation of every earlier Isaac
version. [Return to the project README](../../README.md).

## Supported adjustments

All seven gameplay adjustments default to **On**. Each has its own saved toggle
under **Open Unnerf Pack → Unnerfs** in optional Mod Config Menu Pure. Turn any
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

Dark Bum, The Relic and blue fires share a source folder, but are independent
features with separate toggles and pages. No item-pool weights are changed by
these seven adjustments.

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
The seven keys above each map to one supported feature page; neither disabled
helper has a registered setting.

Compatibility (#1) and optional configuration (#3) are resolved for their bounded
acceptance scope. The [current acceptance matrix and assessment](../testing/issue-1-engine-results.md#acceptance-matrix)
cover representative native behavior and anti-stacking controls. The
[configuration results](../testing/configuration-results-1.9.7.17.md) cover all
seven independent gates, persistence and fallback. [Native batches](../testing/native-batches.md)
retain pack-absent comparisons and observed fire double rewards. A feature-Off
control and a pack-absent control are identified separately in those records.

The pages distinguish source behavior from observed results. They do not claim
exact total drop probabilities, every character or reward source, all orbital
or stomp variants, Greed modes, general multiplayer, or compatibility with every
other mod. Avoid enabling duplicate Workshop/standalone copies of these unnerfs.

## Pending integration handoff

[Magic Mushroom issue #4](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/4)
is separate work and is **not included in this documented baseline**. When its
implementation is merged, verify its actual loader, configuration key/default,
Boss/Treasure definitions and target-build evidence before adding
`magic-mushroom.md` and a row above. Do not infer released behavior or a working
toggle from the issue's requested pool values. Update the configuration inventory
and this coverage statement at the same time.
