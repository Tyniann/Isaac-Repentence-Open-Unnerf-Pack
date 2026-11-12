# Void choice edge cases

Research note for the native Repentance+ interaction behind the mod’s Void
choice absorption behavior. This is source research, not runtime validation.

## Direct findings

### Polaroid and Negative

The Polaroid and The Negative are quest collectibles (IDs 327 and 328 in the
collectible enum, [IsaacDocs enum](https://github.com/wofsauge/IsaacDocs/blob/main/docs/enums/CollectibleType.md));
the IsaacDocs API describes manually spawned Polaroids as “quest collectible[s]”
([EntityPickup.Morph](https://github.com/wofsauge/IsaacDocs/blob/main/docs/EntityPickup.md)).
The game’s 1.7.6 notes also call these two items examples of “quest items” in a
change to Esau Jr. ([official Steam patch notes](https://store.steampowered.com/news/posts/?appids=250900&enddate=1647905707&feed=steam_community_announcements),
lines 359–368).

They are **not categorically immune to Void** according to the gameplay evidence
available: the community wiki says Polaroid lacks Dad’s Note’s immunity to
Void-type rerolls and explicitly notes the two items can be converted into Void
stat increases ([Polaroid gameplay notes](https://bindingofisaacrebirth.wiki.gg/wiki/The_Polaroid)).
That is secondary corroboration, not first-party engine documentation. The
official patch-note evidence establishes quest classification, but says nothing
about Void. No public first-party Void source or vanilla game source code found
here documents a special Polaroid/Negative exclusion.

Consequently, “quest item” does not mean “native Void-ineligible.” The sources
do not establish whether any particular native Void exception is keyed by item
ID, `TAG_QUEST`, or another internal predicate. REPENTOGON documents
`EntityPickup:CanReroll()` as covering Void among other reroll-like effects,
without documenting its native internal predicate ([REPENTOGON EntityPickup
API](https://repentogon.com/EntityPickup.html#CanReroll)). The public API also
documents `OptionsPickupIndex` as the mechanism joining a pickup to its choice
group, and `TriggerTheresOptionsPickup()` as removing pickups with the same
index ([IsaacDocs EntityPickup](https://github.com/wofsauge/IsaacDocs/blob/main/docs/EntityPickup.md#optionspickupindex),
[REPENTOGON method](https://repentogon.com/EntityPickup.html#TriggerTheresOptionsPickup)).
Thus group handling and collectible eligibility are distinct concepts in the
exposed API. It is not evidenced that native Void’s eligibility safeguard uses
group membership as an item-class test.

### Naturally hidden alternate-path pedestal

The API evidence supports treating an alternate-path hidden item as
a real collectible pedestal whose identity is obscured by rendering, rather
than an item assigned only when picked up:

- REPENTOGON exposes `EntityPickup:IsBlind()` for collectible pedestals and
  says it detects pickups that are naturally hidden without Curse of the Blind;
  its own example includes “alt path’s extra item.” Its `SetForceBlind()` docs
  separately describe an imposed visual hiding effect similar to Curse of the
  Blind ([REPENTOGON EntityPickup API](https://repentogon.com/EntityPickup.html#IsBlind),
  [SetForceBlind](https://repentogon.com/EntityPickup.html#SetForceBlind)).
- IsaacDocs says an entity’s type, variant, and subtype define its identity,
  and for a collectible pedestal the subtype distinguishes collectible items
  ([entity identity docs](https://github.com/wofsauge/IsaacDocs/blob/main/docs/entities/Overview.md#type-variant-and-subtype)).
  The game API exposes pickup subtype on the entity; the docs do not say blind
  rendering postpones subtype assignment.

The sensible answer is therefore: the hidden pedestal has a collectible
identity at spawn, and its blind state masks its presentation; Void interacts
with the pedestal under its normal pickup/choice logic. The API evidence
supports this model but does not disclose the native rendering or Void code.
`SetupCollectibleGraphics` also accepts the collectible identity and the `Blind`
rendering argument separately ([graphics API](https://repentogon.com/EntityPickup.html#setupcollectiblegraphics)).
The public sources checked do not establish that native Void has a
special-case exclusion for an unknown passive item on a naturally blind
pedestal, nor fully specify native handling when that naturally hidden item is
an active item.

Our own [target-build pilot](../testing/evidence/void16-final-pilot.jsonl) and
[Continue evidence](../testing/evidence/void16-continue.jsonl) establish native
delayed storage and later exactly-once effects for the controlled books. That
evidence does not establish what happens to an untouched naturally blind item.

## Evidence strength and boundaries

| Claim | Evidence | Strength |
| --- | --- | --- |
| Polaroid and Negative are quest items | Official patch notes name both as quest items; API item description identifies Polaroid as quest collectible | Strong for classification |
| Quest classification alone does not prove Void immunity | Community gameplay notes say Polaroid/Negative can be converted by Void; no public vanilla engine source found | Moderate, gameplay corroboration only |
| Option grouping is represented by `OptionsPickupIndex` | Public IsaacDocs and REPENTOGON API documentation | Strong for exposed API contract |
| Naturally hidden alternate-path pedestal is blind independently of Curse of the Blind | REPENTOGON `IsBlind` docs explicitly mention alt-path extra item | Strong for API semantics |
| Hidden pedestal has an identity before pickup | Entity subtype defines identity; `IsBlind` is a property of an existing collectible pedestal; rendering implementation itself is not public here | Strong inference, not a direct engine-code proof |
| Exact native Void eligibility predicate and untouched hidden-pedestal consumption | No public first-party implementation/source found; community wiki fills some gameplay details | Unresolved / secondary |
| Newly absorbed books wait until later uses | Our captured target-build pilot and Continue records | Direct runtime evidence for the controlled book fixtures; not a dedicated hidden-item case |

No leaked or private game source was used. `IsBlind()` is preferable to inferring
“naturally blind” from Curse of the Blind: its documented contract explicitly
excludes curse-imposed hiding and includes the alternate-path item. A generic
blindness test would conflate these states.

## Regression implication

### Released code and actual test coverage

This audit concerns v2.1.0, source commit
`e2b71f9fc81a6880694e565e29bcd192a1aa8102`.

- [Production Void handling](../../Mods/Void%20Choice%20Unnerf/main.lua)
  filters free, untouched, nonempty collectibles with an actual option group.
  It retains one original marker, temporarily clears the others, and returns
  nil to native Void. It changes neither collectible IDs nor graphics and
  grants no items or stats itself. It has no specific Polaroid/Negative,
  `TAG_QUEST`, or blindness condition. Genesis and Death Certificate are the
  explicit exclusions.
- Consequently, any eligible-looking native linked Polaroid/Negative pair is
  included in grouping changes. We do not replace the engine's item-specific
  eligibility code. A native identity-based veto would still be native, but
  its behavior on this pair has not been measured. If the pair is normally
  consumable, the intended prediction is two passive contributions instead
  of one; this does not mean owning both route items. A special progression
  protection would be an additional gameplay policy, not a conclusion from
  their quest classification alone.
- The [alternate-path fixture](../../tools/validation/void-choice-batch.lua)
  uses stage `1c`, enters a Treasure Room, checks that native pedestals share
  real choice links, and then **morphs every collectible into known books**.
  It explicitly restores each pedestal's original option group and price.
  The state recorder contains subtype, seed, group, price and touched status;
  it contains no blind-state observation. Original item IDs and the mystery
  presentation are therefore not established by this check.
- The [captured case result](../testing/evidence/void16-final-matrix-results.json)
  is `alt-treasure-native`, seed `1344027538`, StageType 4, Treasure Room grid
  72 / variant 10. It passes with no remaining pedestals and neither fixture
  book owned. This validates replacement-fixture group absorption in a native
  alternate-path room, **not a dedicated untouched mystery-pedestal test**.
- Neither the Polaroid/Negative pair nor its native progression consequences
  has a captured case in the shipped validation evidence.

The gameplay wiki specifically reports that voiding the photos trades their
Chapter 6 access for stats. This is an existing-gameplay report, not a fresh
1.9.7.17 baseline or a proof of the engine's predicate. It supports testing
normal consumability rather than assuming immunity from the quest tag. The
current code alone cannot certify this particular pair's native outcome.

If uncertainty remains after the parent’s code and test audit, keep any native
regression narrow: check the Polaroid/Negative identity edge and a naturally
hidden alternate-path collectible edge separately. Record the pickup subtype,
blind state, option index, whether Void actually consumes the pickup, and
whether an active effect runs on that use or a later use. This note does not
specify a fixture or claim runtime coverage. Both are appropriate focused
regressions; no production exception is justified solely by the current source
research. Future native work needs a new shared-session handoff and disposable
backups, since the prior session has been cleaned up and released.

---

*Research updated: 2026-11-11*
