# Dark Bum

[All features](README.md) · [Configuration](configuration.md)

**Affected:** Dark Bum rewards. **Default:** On. **Setting:** `darkBum`,
shown as **Dark Bum: On/Off** under **Open Unnerf Pack → Unnerfs**.
**Target build:** Repentance+ v1.9.7.17 (owner executable 1.9.7.17.J460).

## What changes

Favor soul hearts from Dark Bum by converting its non-soul-heart **pickup rewards** into soul hearts when they appear. The target-build Off control left native pill rewards unchanged; six enabled native payout chains for Isaac became soul hearts.

The code requires the pickup to be attributed to a Dark Bum familiar with an owner. Existing soul-heart pickups stay as they are. The conversion does not change how many red hearts Dark Bum consumes or schedule more payouts. Spider entities are not pickups and are outside this conversion; this is not a guarantee that every Dark Bum reward becomes a soul heart.

## When it applies

Choose On or Off for a **new run**. Menu changes save immediately but do not
change a run in progress. **Continue keeps that run's saved choice**, including
after relaunch. If a matching run snapshot is missing, saved choices are used;
see [configuration and fallback rules](configuration.md). Off leaves this
adjustment's native behavior untouched.

## Scope and evidence

The owner must **not** be The Lost, Keeper, Tainted Lost or Tainted Keeper. Those four character types are explicitly excluded, leaving their native outputs unchanged by this feature. There is no explicit mode restriction.

The recorded enabled evidence covers Isaac and six native pickup conversions. Excluded-character outcomes, every possible reward variant and payout frequency were not established by those tests. Other mods that alter reward attribution or morph these pickups may interact.

Source: [feature implementation](../../Mods/Soul%20Heart%20Generator%20Unnerf/darkbumunnerf.lua) and
[pack configuration](../../config.lua). The [accepted compatibility matrix](../testing/issue-1-engine-results.md#acceptance-matrix),
[native batch results](../testing/native-batches.md) and
[independent configuration/gate results](../testing/configuration-results-1.9.7.17.md)
record the tested setups and remaining limits. Representative compatibility and
configuration acceptance are complete; untested combinations are not implied passes.
