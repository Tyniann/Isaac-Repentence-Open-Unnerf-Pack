# Configuration and Mod Config Menu

[All features](README.md) · [Project configuration overview](../../README.md#configuration)

The pack's eight gameplay adjustments default to **On** on Repentance+
**v1.9.7.17** (owner executable **1.9.7.17.J460**). Optional **Mod Config Menu
Pure v113** lets you choose each independently. Installing MCM adds the menu;
it does not supply the pack's persistence or add more gameplay features.

## Menu controls

Install [Mod Config Menu Pure](https://steamcommunity.com/sharedfiles/filedetails/?id=2681875787),
then open **Open Unnerf Pack 2 → Unnerfs** (MCM's default key: L or F10).
Each entry displays its name followed by `: On` or `: Off`.

| Menu name | Saved key | Feature |
| --- | --- | --- |
| Maw of the Void | `mawOfTheVoid` | [Damage and rings](maw-of-the-void.md) |
| Orbitals | `orbitals` | [Contact size/damage](orbitals.md) |
| Stomp immunity | `stompImmunity` | [Host Hat/Pyromaniac](stomp-immunity.md) |
| Humbling Bundle | `humblingBundle` | [Pickup conversions](humbling-bundle.md) |
| Dark Bum | `darkBum` | [Pickup rewards](dark-bum.md) |
| The Relic | `relic` | [Room-clear counter](the-relic.md) |
| Hard-mode blue fires | `blueFires` | [Blue and purple fires](blue-fires.md) |
| Magic Mushroom pools | `magicMushroom` | [Boss availability and Treasure weight](magic-mushroom.md) |

Nail and Satanic Bible have no menu controls. These keys are reference names for
saved data, not console commands. There is no supported live per-feature switch.
The Pack 2 menu name does not reset the pack's saved choices or change its
registration or version-1 saved-data format.

## New runs and Continue

Menu edits **save immediately** as choices for the next **new run**. They do not
alter the run in progress. The menu therefore can show a different choice from
that run's active setting. Continue uses the saved run snapshot when its seed
matches, including after exiting and relaunching the game.

This rule avoids trying to undo already-mutated orbital damage/size or Relic
counters mid-run. Maw damage is re-evaluated at run start after settings are
selected. Magic Mushroom pool rules retain native pool depletion and do not
append or reset entries on Continue. Changing a menu choice to Off does not
retroactively remove items, hearts, pickups or effects from the current run.

If Continue has no matching run snapshot (including a run predating this
configuration system), the pack uses the saved choices instead. Settings and
the latest run snapshot are separate in Isaac's mod data for each save slot;
they are reloaded at game start even after a slot switch without relaunching.

## Without MCM and fallback

MCM is optional: without it, the pack uses its saved choices, or all-On defaults
when none are available. Removing MCM does not reset the choices. The pack stores
them through its own Isaac `SaveData`, independently of MCM's settings files.

Missing or malformed JSON, or an unknown schema version, falls back to all eight
On. In version 1 data, missing or non-boolean fields default individually to On;
unknown keys are ignored. A matching run snapshot follows the same boolean
normalization. A fallback is not a promise to reconstruct lost historical run
choices. A saved choice or run snapshot that predates `magicMushroom` defaults
that missing field to On while preserving the other valid Boolean choices.

## Validation and limits

The [executed configuration results](../testing/configuration-results-1.9.7.17.md)
record defaults and the original seven controls, deferred application, Continue
retention,
relaunch persistence, save-slot isolation, malformed-data fallback, operation
without MCM and an independent gate case per setting. Configuration acceptance
is complete for those cases; it does not certify every underlying combat,
character, mode or multiplayer combination. Each feature page records its scope.

The eighth control has separate [Magic Mushroom evidence](../testing/magic-mushroom-1.9.7.17.md):
native On/Off behavior and a full-process Continue retaining active On while the
next-run choice was Off. Its weight, availability and conversion results have
their own limits, including a failed cross-build comparison and scripted cleanup
fixture; these are not additional passes in the historical seven-gate record.
See the [feature page](magic-mushroom.md) and [pool-rule technical reference](../agents/pool-rules.md).

Source: [configuration implementation](../../config.lua). For reproducible
checks see [configuration validation](../configuration-validation.md); for the
build's broader accepted evidence see the [compatibility assessment](../testing/issue-1-engine-results.md#acceptance-assessment-2026-11-10).
Other MCM forks/versions and game builds require separate validation.
