# Hard-mode blue and purple fires

[All features](README.md) · [Configuration](configuration.md)

**Affected:** Blue and purple fireplaces. **Default:** On. **Setting:** `blueFires`,
shown as **Hard-mode blue fires: On/Off** under **Open Unnerf Pack → Unnerfs**.
**Target build:** Repentance+ v1.9.7.17 (owner executable 1.9.7.17.J460).

## What changes

Increase soul-heart opportunities from exploding blue and purple fires on **Hard**. For each eligible explosion-damage event on either fireplace variant, the mod makes an **additional 17% roll** and spawns one soul heart on success. Native fire rewards are retained.

This is a per-event extra roll, **not a 17% final chance per destroyed fire**. The handler does not require the event to be lethal and does not mark a fire as already processed. A native reward and the extra reward can both occur: double soul-heart drops were observed on the target build.

## When it applies

Choose On or Off for a **new run**. Menu changes save immediately but do not
change a run in progress. **Continue keeps that run's saved choice**, including
after relaunch. If a matching run snapshot is missing, saved choices are used;
see [configuration and fallback rules](configuration.md). Off leaves this
adjustment's native behavior untouched.

## Scope and evidence

The mode check is exactly the game's Hard difficulty. It does not run in Normal, Greed or Greedier. Both blue (variant 2) and purple (variant 3) fireplaces qualify; other colors and non-explosion damage do not. There is no character filter.

In recorded Hard samples of 200 trials per color, enabled blue and purple fires each yielded 53 total hearts, including four blue doubles and two purple doubles. Pack-absent Hard samples yielded 21 blue and 16 purple hearts, with no doubles. These finite observations do not establish an exact overall probability. Normal enabled/absent samples were also recorded; they do not prove exact population equality. Repeated or nonlethal damage, interaction with other fire mods and universal pickup caps remain unverified.

Source: [feature implementation](../../Mods/Soul%20Heart%20Generator%20Unnerf/bluefireunnerf.lua) and
[pack configuration](../../config.lua). The [accepted compatibility matrix](../testing/issue-1-engine-results.md#acceptance-matrix),
[native batch results](../testing/native-batches.md) and
[independent configuration/gate results](../testing/configuration-results-1.9.7.17.md)
record the tested setups and remaining limits. Representative compatibility and
configuration acceptance are complete; untested combinations are not implied passes.
