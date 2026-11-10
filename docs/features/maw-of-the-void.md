# Maw of the Void

[All features](README.md) · [Configuration](configuration.md)

**Affected:** Maw of the Void. **Default:** On. **Setting:** `mawOfTheVoid`,
shown as **Maw of the Void: On/Off** under **Open Unnerf Pack 2 → Unnerfs**.
**Target build:** Repentance+ v1.9.7.17 (owner executable 1.9.7.17.J460).

## What changes

Restore a damage bonus and black-heart generation to Maw of the Void. On the target build, the isolated feature-Off control has neither the added damage nor the restored ring drop field.

With this adjustment enabled, each copy adds **+1 damage** during damage calculation. Acquiring or removing copies updates the bonus; it is tracked per player. Player-spawned lasers using the dark-ring sprite receive `BlackHpDropChance = 0.05`.

That value is the engine's drop-chance field on qualifying rings. It is **not an experimentally established 5% total drop rate** for every kill, room or use. The laser check uses its player spawner and sprite, rather than checking whether the player holds Maw, so another source of an identical player-spawned ring may also qualify.

## When it applies

Choose On or Off for a **new run**. Menu changes save immediately but do not
change a run in progress. **Continue keeps that run's saved choice**, including
after relaunch. If a matching run snapshot is missing, saved choices are used;
see [configuration and fallback rules](configuration.md). Off leaves this
adjustment's native behavior untouched.

## Scope and evidence

There is no explicit character or mode restriction in this module. The damage bonus follows the holder; the ring adjustment requires a player spawner. Representative Jacob/Esau isolation, two-copy handling, held-item Continue and removal were corroborated. General multiplayer and other ring sources are not certified.

Recorded acquisition/removal changed damage **3.5 → 4.5 → 3.5** for one copy. A native ring had field 0.05 On versus 0 Off, and one controlled native black-heart output was observed. One output does not establish a probability. Other mods that change damage or the same ring field may interact; avoid duplicate unnerf copies.

Source: [feature implementation](../../Mods/MawOfVoidUnnerf/main.lua) and
[pack configuration](../../config.lua). The [accepted compatibility matrix](../testing/issue-1-engine-results.md#acceptance-matrix),
[native batch results](../testing/native-batches.md) and
[independent configuration/gate results](../testing/configuration-results-1.9.7.17.md)
record the tested setups and remaining limits. Representative compatibility and
configuration acceptance are complete; untested combinations are not implied passes.
