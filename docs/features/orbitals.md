# Orbitals

[All features](README.md) · [Configuration](configuration.md)

**Affected:** Orbiting familiars. **Default:** On. **Setting:** `orbitals`,
shown as **Orbitals: On/Off** under **Open Unnerf Pack → Unnerfs**.
**Target build:** Repentance+ v1.9.7.17 (owner executable 1.9.7.17.J460).

## What changes

Restore larger contact hitboxes and stronger contact hits for qualifying orbiting familiars. Compared with their native target-build fields, the mod sets hitbox size to **at least 13** and **doubles collision damage** once per familiar entity. It does not change the contact tick interval or promise doubled damage per second.

A familiar qualifies when both components of its orbit distance are nonzero. Blue flies are explicitly excluded. This is a broad orbit-distance test, not a named list of items; it can include familiars supplied by other mods.

## When it applies

Choose On or Off for a **new run**. Menu changes save immediately but do not
change a run in progress. **Continue keeps that run's saved choice**, including
after relaunch. If a matching run snapshot is missing, saved choices are used;
see [configuration and fallback rules](configuration.md). Off leaves this
adjustment's native behavior untouched.

## Scope and evidence

No explicit character or mode restriction is applied. Already larger hitboxes stay larger. A processed marker prevents repeated doubling of the same entity; newly created entities are evaluated separately.

Native comparisons corroborated Sacrificial Dagger contact damage attempts of 30 enabled versus 15 pack-absent, and 60 versus 30 with BFFS. Representative Cube of Meat variants had collision damage/size 14/13 enabled versus 7/8 absent. Doorway, BFFS and Continue fields were checked for representative Dagger cases. These are bounded observations, not a fixed DPS claim or coverage of every orbital, transformation or recreation lifecycle. Other mods using the same familiar data marker or changing its fields may interact.

Source: [feature implementation](../../Mods/Orbital%20Unnerf/main.lua) and
[pack configuration](../../config.lua). The [accepted compatibility matrix](../testing/issue-1-engine-results.md#acceptance-matrix),
[native batch results](../testing/native-batches.md) and
[independent configuration/gate results](../testing/configuration-results-1.9.7.17.md)
record the tested setups and remaining limits. Representative compatibility and
configuration acceptance are complete; untested combinations are not implied passes.
