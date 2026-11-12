# Void choice edge cases

Research note for the native Repentance+ interaction behind the mod’s Void
choice absorption behavior. Initial source research is followed by the
target-build native results captured for issue #17 below.

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
| Exact internal native Void eligibility predicate | No public first-party implementation/source found | Internal predicate unresolved; observable photo/passive outcomes now captured below |
| Untouched hidden passive identity and contribution | Issue #17's native Off/unlinked/On records | Direct target-build observations for the captured natural pair |
| Newly absorbed books wait until later uses | Our captured target-build pilot and Continue records | Direct runtime evidence for the controlled book fixtures; not a dedicated hidden-item case |

No leaked or private game source was used. `IsBlind()` is preferable to inferring
“naturally blind” from Curse of the Blind: its documented contract explicitly
excludes curse-imposed hiding and includes the alternate-path item. A generic
blindness test would conflate these states.

## Regression implication

### Released code and actual test coverage

The initial source/coverage audit concerns v2.1.0, source commit
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
  its behavior on this pair had not yet been measured. If the pair is normally
  consumable, the intended prediction is two passive contributions instead
  of one; this does not mean owning both route items. A special progression
  protection would be an additional gameplay policy, not a conclusion from
  their quest classification alone.
- The legacy [alternate-path fixture](../../tools/validation/void-choice-batch.lua)
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
- At v2.1.0's release, neither the Polaroid/Negative pair nor its native
  progression consequences had a captured case in the shipped evidence.

The gameplay wiki specifically reports that voiding the photos trades their
Chapter 6 access for stats. This is an existing-gameplay report, not a fresh
1.9.7.17 baseline or a proof of the engine's predicate. It supports testing
normal consumability rather than assuming immunity from the quest tag. The
code alone could not certify this particular pair's native outcome.

The source research motivated two focused regressions, with a fresh session
handoff and backups after the issue #16 cleanup. Their measured results follow.

## Native follow-up: issue #17

The [native edge-case ledger](../testing/void-choice-edge-cases-1.9.7.17.md) and
[frozen records](../testing/evidence/void17-edges.jsonl) now establish:

- Mom's real Polaroid/Negative pair is free, untouched, quest-tagged and linked
  by native group 3. Feature Off consumes the pair and grants stats without
  owning either photo. On matches the native unlinked two-item reward, still
  without owning either photo. There is no new photo immunity rule to add for
  these observed outcomes; usual route-item access is not granted by stat
  conversion.
- The untouched alternate-path pair already contains hidden item ID 222 and
  visible item ID 62, with native group 1. The hidden state is observed through
  the installed EID vanilla question-mark texel comparison. No Morph or
  replacement spawn is used. On matches native unlinked rewards for both
  original passive identities, while Off produces the one-choice outcome.
- All six comparisons pass with identical per-cohort fixture identities,
  entity seeds, initial groups, hidden presentation and starting stats. The
  controlled Void RNG intervention is explicit. This is target-build evidence
  for the selected passive pair, not a natural-rate or every-item survey.

The production module needs no change for these cases. The later hidden-active
follow-up used the untouched natural pair at seed `1344027651` (hidden active
65, visible familiar 113) and captured passing Off, native-unlinked and On
results: the active had no immediate effect, then produced its room-local bomb
effect on each of two subsequent Void uses in the enabled cases. See the
[active capture ledger](../testing/void-choice-edge-cases-1.9.7.17.md#fixed-hidden-active-native-results)
and [retained records](../testing/evidence/void17-active.jsonl). This closes
only the selected fixture case; full photo-gated route entry, other hidden
active items and the broader character/mode matrix remain untested. The earlier
book timing tests remain separate evidence.

---

*Sources researched: 2026-11-11. Native follow-up captured: 2026-11-12.*
