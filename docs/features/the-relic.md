# The Relic

[All features](README.md) · [Configuration](configuration.md)

**Affected:** The Relic room-clear counter. **Default:** On. **Setting:** `relic`,
shown as **The Relic: On/Off** under **Open Unnerf Pack 2 → Unnerfs**.
**Target build:** Repentance+ v1.9.7.17 (owner executable 1.9.7.17.J460).

## What changes

Give The Relic a head start toward its native soul-heart payout. A Relic familiar whose room-clear counter is zero is advanced to **2**; when a pickup attributed to that Relic appears, its counter is reset to **2** again.

The native payout logic still runs. The mod does not specify a universal “one soul heart every N rooms” interval, add a heart on every room clear, or increase each heart's size. The target-build Off initialization stays at zero; enabled initialization becomes two.

## When it applies

Choose On or Off for a **new run**. Menu changes save immediately but do not
change a run in progress. **Continue keeps that run's saved choice**, including
after relaunch. If a matching run snapshot is missing, saved choices are used;
see [configuration and fallback rules](configuration.md). Off leaves this
adjustment's native behavior untouched.

## Scope and evidence

There is no explicit character or mode restriction. Each qualifying Relic familiar has its own counter, but multiple-Relic behavior has not been validated. The pickup reset uses familiar attribution, so other mods changing that attribution can affect it.

One pack-absent Hard run paid out at clear 7; a separate absent Normal run had no payout in six clears. An enabled Normal run paid out at clear 5, then showed counter reset 6 → 2 and three further increments. These different setups demonstrate representative payout/reset behavior, not an exact universal cadence. A second payout cycle, multiple Relics and held-item Continue behavior remain unverified; Continue preserves the feature choice but is not a certification of every counter lifecycle.

Source: [feature implementation](../../Mods/Soul%20Heart%20Generator%20Unnerf/relicunnerf.lua) and
[pack configuration](../../config.lua). The [accepted compatibility matrix](../testing/issue-1-engine-results.md#acceptance-matrix),
[native batch results](../testing/native-batches.md) and
[independent configuration/gate results](../testing/configuration-results-1.9.7.17.md)
record the tested setups and remaining limits. Representative compatibility and
configuration acceptance are complete; untested combinations are not implied passes.
