# Blank Card + Jera

[All features](README.md) · [Configuration](configuration.md)

## Overview

When enabled, using Blank Card while holding Jera applies Jera's native effect
without consuming the held rune. After the use, it sets Blank Card's cost for
its next activation to four. The current charge bar keeps its native value when
switching between consumables.

## Behavior

The adjustment runs from Blank Card's native use callback and invokes the
held Jera effect with the game's mimic flags. The first Jera use after another
consumable may therefore use the charge cost already carried by Blank Card;
using Jera sets the cost for the next activation. It does not set the cost when
Jera is selected or grant charge. Jera's ordinary four-room recharge remains
native.

The adjustment applies when Blank Card is the active item in the used slot and
Jera is held in the primary card slot. With Car Battery, the native repeated-use
callback repeats Jera's effect without spending another Blank Card charge.
Unrelated mimicked actives remain ignored. The feature does not change global
Jera behavior or Clear Rune, and leaves other cards and consumables to the game.

Native checks passed on Repentance+ v1.9.7.17.J460 without REPENTOGON, with
MCM v113. They cover ordinary pickups, battery refills, Car Battery, four-room
recharge, other consumables, Schoolbag in slots 0 and 1, co-op isolation, Off,
and Continue. The owner also confirmed the visible four-charge bar before the
co-op run. See the [issue #19 ledger](../testing/blank-card-jera-issue19.md)
for the captures, tested scope and remaining limits. These results do not
cover other game builds; active slots 2 and 3 have callback contract tests but
were not exercised in the native captures.

## Configuration

The **Blank Card + Jera** toggle defaults to **On**. Changes save immediately
and apply to new runs. Continue keeps that run's saved setting. With the feature
Off, the callback leaves native Blank Card behavior unchanged.

## Dependencies

This adjustment targets Repentance+ v1.9.7.17. It uses the base game's callbacks
and does not require REPENTOGON. Optional Mod Config Menu Pure provides the
toggle; without MCM, the saved default is On.

## Related features and technical reference

See the [technical reference](../agents/blank-card-jera.md) for callback,
configuration and validation details.

---
*Last updated: 2026-11-15*
