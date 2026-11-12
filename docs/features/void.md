# Void choice absorption

[All features](README.md)

## Overview

Void's default behavior absorbs one item from an ordinary linked choice group.
With this adjustment enabled, one Void use absorbs every eligible item in each
ordinary linked group in the room. This restores the multi-choice interaction
for Apollyon and for other characters holding Void. It is separate from Maw of
the Void.

## Behavior

This is an intentional selective restoration on Repentance+ **v1.9.7.17**. It
restores absorption of multiple linked choices and retains Repentance+'s current
four-room charge. Afterbirth+ Void had a six-room charge, so this combination is
stronger than the historical item and is not an exact Afterbirth+ rollback.

The adjustment uses the choice groups assigned to the pickups, including
eligible More Options, There's Options, and alternate-path Treasure Room groups.
Unlinked pickups remain independent. Paid items keep their native payment
restriction. Death Certificate and Genesis selection sequences are excluded so
their special transitions remain native. Ordinary manual pickup still uses
the normal choose-one interaction. The change does not replay Void's complete
use for each pedestal.

Polaroid and Negative can already be consumed by vanilla Void. With this
adjustment On, both contribute stats; neither becomes an owned route item.
Voiding them still gives up their normal photo-gated access. No special
photo-immunity rule is added.

The alternate-path question-mark pedestal contains an already-selected item.
Its hidden presentation does not prevent that item from contributing. An
untouched native hidden-passive pair and Mom's original photo pair both pass
Off/On comparisons against native unlinked controls in the
[edge-case validation](../testing/void-choice-edge-cases-1.9.7.17.md).

Native checks on the supported build pass for controlled active, passive and
mixed groups, Boss Rush, both Options items, alternate-path Treasure choices,
manual pickup and process-restart Continue. The [validation record](../testing/void-choice-1.9.7.17.md)
records the fixtures, comparisons and limits.

## Configuration

The **Void choice absorption** setting is an independent toggle, default **On**.
It appears under **Open Unnerf Pack 2 → Unnerfs** with optional Mod Config Menu
Pure. Without MCM, the pack still loads its saved choice or defaults to On.
Settings save immediately, apply to new runs, and are retained by Continue
through the run snapshot. A save without this setting defaults it to On.

## Dependencies and limits

The feature targets vanilla Repentance+ **v1.9.7.17** and does not require
REPENTOGON. Local single-player checks cover Apollyon and Isaac holding Void.
Multiplayer and other modes are untested. A native Angel Room pair was not
tested directly; the owner selected Boss Rush as its substitute. Death
Certificate and Genesis checks verify the exclusions after native entry;
their full return sequences were not exercised.
A naturally hidden active item (ID 65) in one untouched Treasure Room pair was
tested on the supported build: Void did not trigger it immediately; the stored
effect spawned bombs on each of two later Void uses. Off, On, and native-unlinked
controls were compared. This selected-item result does not establish behavior
for all hidden actives. Full photo-gated route transitions remain untested.

## Related features and technical reference

- [Maw of the Void](maw-of-the-void.md) is an unrelated adjustment.
- [Configuration reference](configuration.md) describes persistence and MCM.
- [Void validation record](../testing/void-choice-1.9.7.17.md) records fixtures,
  observations and untested limits.

---
*Last updated: 2026-11-12*
