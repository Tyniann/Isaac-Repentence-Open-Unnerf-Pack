# Humbling Bundle

[All features](README.md) · [Configuration](configuration.md)

**Affected:** Humbling Bundle and selected pickups. **Default:** On. **Setting:** `humblingBundle`,
shown as **Humbling Bundle: On/Off** under **Open Unnerf Pack → Unnerfs**.
**Target build:** Repentance+ v1.9.7.17 (owner executable 1.9.7.17.J460).

## What changes

Make eligible single consumable selections become double packs whenever any player holds Humbling Bundle. The target-build feature-Off control left a selected penny single; enabled native chest contents showed conversions.

The adjustment maps these pickup selections directly, with **no additional random roll**:

| Selected pickup | Replacement |
| --- | --- |
| Full red heart | Double red-heart pack |
| Penny | Double coin pack |
| Normal key | Double key pack |
| Normal bomb | Double bomb pack |

Other subtypes, including half hearts, soul hearts, nickels and already-doubled packs, are left alone by this code. It changes eligible selections, rather than retroactively doubling every pickup already on the floor.

## When it applies

Choose On or Off for a **new run**. Menu changes save immediately but do not
change a run in progress. **Continue keeps that run's saved choice**, including
after relaunch. If a matching run snapshot is missing, saved choices are used;
see [configuration and fallback rules](configuration.md). Off leaves this
adjustment's native behavior untouched.

## Scope and evidence

The holder check scans all players, so the intended scope includes selections when another player owns the item. There is no explicit character or mode restriction. Multiple copies do not repeatedly multiply the replacement.

Native chest evidence includes a key, four pennies and a bomb converted with the feature On; a half-heart remained unchanged. Full-red-heart conversion is supported by source but was not established by that native sample. Other reward sources and co-op behavior remain unverified. Another mod that replaces the same pickup selection can affect the outcome.

Source: [feature implementation](../../Mods/Humbling%20Bundle%20Unnerf/main.lua) and
[pack configuration](../../config.lua). The [accepted compatibility matrix](../testing/issue-1-engine-results.md#acceptance-matrix),
[native batch results](../testing/native-batches.md) and
[independent configuration/gate results](../testing/configuration-results-1.9.7.17.md)
record the tested setups and remaining limits. Representative compatibility and
configuration acceptance are complete; untested combinations are not implied passes.
