# Stomp immunity

[All features](README.md) · [Configuration](configuration.md)

**Affected:** Host Hat and Pyromaniac. **Default:** On. **Setting:** `stompImmunity`,
shown as **Stomp immunity: On/Off** under **Open Unnerf Pack 2 → Unnerfs**.
**Target build:** Repentance+ v1.9.7.17 (owner executable 1.9.7.17.J460).

## What changes

Restore protection from crush/stomp damage while holding **Host Hat or Pyromaniac**. The target-build Off control allowed Mom's boss-foot stomp to hurt a Host Hat holder; enabling this feature prevented that damage.

The adjustment cancels player damage flagged as crush. It also cancels otherwise unflagged contact from Mom's boss foot during its Stomp animation, which can accompany the impact on this build. With Pyromaniac, a crush event additionally restores **one full red heart** (two half-heart units), subject to the player's available red-heart health. The extra foot-contact events do not grant additional healing.

## When it applies

Choose On or Off for a **new run**. Menu changes save immediately but do not
change a run in progress. **Continue keeps that run's saved choice**, including
after relaunch. If a matching run snapshot is missing, saved choices are used;
see [configuration and fallback rules](configuration.md). Off leaves this
adjustment's native behavior untouched.

## Scope and evidence

No explicit character or mode filter is applied, but the player must hold one of the two items and the damage must match one of the conditions above. This does not grant general contact immunity. Pyromaniac healing uses red hearts; it does not grant soul hearts or red-heart containers.

An actual Mom/Host Hat comparison recorded health 6 → 4 Off and 6 → 6 On, in half-heart units. A separate synthetic engine crush comparison for Pyromaniac recorded 4 → 2 pack-absent versus 4 → 6 enabled. The latter is not a native Mom/Pyromaniac attack. Other stomp sources and character health interactions remain unverified.

Source: [feature implementation](../../Mods/Stomp%20Immunity%20Unnerf/main.lua) and
[pack configuration](../../config.lua). The [accepted compatibility matrix](../testing/issue-1-engine-results.md#acceptance-matrix),
[native batch results](../testing/native-batches.md) and
[independent configuration/gate results](../testing/configuration-results-1.9.7.17.md)
record the tested setups and remaining limits. Representative compatibility and
configuration acceptance are complete; untested combinations are not implied passes.
