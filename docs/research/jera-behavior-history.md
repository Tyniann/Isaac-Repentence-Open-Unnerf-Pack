# Jera behavior history and unnerf candidates

[Technical documentation index](../agents/README.md)

Researched 2026-11-13. Scope: historical behavior and possible restoration targets,
not an implementation specification or gameplay validation.

## Assessment

The strongest documented loss is **repeatable Jera through its copying active**:
Afterbirth+ references list four-room Blank Card, while Repentance references
list twelve-room Clear Rune for Jera. That is three times the room-charge cost
per copied use, calculated from the documented values. Rune copying also moves
to a different item with different availability. These are interaction changes;
the evidence below does not establish a reduction in the ordinary rune's
duplication effect. [1][2]

The detailed mechanics come from community references. Official patch notes
confirm some mimic-item cooldown adjustments but do not establish the exact
Jera-specific transition. No current-target native observations were collected.

**Launch-era self-duplication remains unresolved.** The earliest recovered wiki
wording does not specify whether another Jera was eligible, the first developer
patches leave gameplay changes undescribed, and the earliest explicit failed
attempts located so far are later player reports. These findings cannot refute
a short-lived behavior in the initial release. See the follow-up below.

## Old versus later behavior

Use **Afterbirth+** as the concrete old baseline here. Do not read its present-day
reference page as proof that every Rebirth or Afterbirth patch behaved identically.
Likewise, the Repentance reference is not a frozen record of launch-day behavior.

| Mechanic | Afterbirth+ reference | Repentance reference | Assessment |
|---|---|---|---|
| Ordinary Jera | Duplicates room pickups; can multiply the Chest's starting chests. [1] | Still duplicates pickups and starting item chests. [2] | No general loss of duplication established. |
| Reusable Jera | Blank Card copies held runes without consuming them. [1] | Rune copying belongs to Clear Rune; Blank Card copies cards. [2] | The old combination is split across different items. |
| Charge per copied use | Blank Card: **4 rooms**. [1] | Clear Rune with Jera: **12 rooms**. [2] | A documented increase in repeat-use cost. Exact patch of introduction remains unpinned. |
| Copier availability | Blank Card: Treasure, Shop and Secret pools. [1] | Clear Rune: Secret and Crane Game pools. [2] | The ordinary shop route to the copier is lost in this comparison; no numerical rarity estimate established. |
| Unpurchased shop pickups | Duplication is documented. [1] | Copies are documented as free to collect. [2] | No supported restoration target based on a claimed removal of free copies. |
| Chest contents | The reference establishes more chests, not exact content identity. [1] | Describes matching content types, without establishing identical specific rewards. [2] | An old-identical/new-randomized nerf is not established. |

The Repentance reference also excludes trinkets and other Jera runes from
duplication. It does not date these limits and cannot establish whether allowing
self-duplication would restore an earlier launch-build behavior. [2]

### Follow-up: could one Jera duplicate another?

#### Owner's recollection and scope

On **2026-11-13**, the owner clarified that the remembered direct Jera-on-Jera
duplication occurred on **PC**, when “true platinum god was still the max
achievable.” The working interpretation is the original Rebirth era, with
**Real Platinum God** as the completion ceiling, before Afterbirth expanded the
game. This is a first-hand recollection and a search constraint, not a pinned
executable version or reproduced test.

The disputed 3DS Blank Card account below cannot establish the owner's PC
experience. Likewise, later D1 duplication is a different mechanic. The open
question is direct duplication in an early **PC Rebirth** build. The completion
ceiling identifies a ruleset, not a particular patch or necessarily the calendar
date of play. Steam dates Rebirth's release to November 4, 2014, and Afterbirth's
to October 30, 2015. Those dates bracket the original pre-expansion release era,
not every possible date someone could have played without the DLC. [23]

Contemporary player reports place the prohibition well before Repentance:

- A **November 13, 2014** Rebirth discussion includes a player reporting that
  trying to copy a second Jera failed, and another exchange explicitly answering
  that Jeras on the floor cannot be copied by Jera. [8]
- A **September 27, 2015** discussion describes testing two actual Jera runes
  and failing to duplicate one with the other. A different commenter claims
  successful **Blank Card** duplication on **3DS**, while others report failure
  on PC. That conflicting platform-specific claim is not confirmation of direct
  rune-on-rune duplication. [9]
- A **July 13, 2023** recollection claims that direct duplication was possible
  initially, but identifies neither a build nor a removal patch. [10]

These are player accounts, not first-party patch records or reproduced tests.
They date reports of the restriction, but do not settle the original release
build's behavior or rule out a platform exception. The historical
self-duplication restoration claim remains open and unverified.

#### The launch-patch evidence gap

The deeper patch search found that early developer notes explicitly omit
gameplay changes:

- **November 7, 2014, v1.01:** developer Simon writes, “We also fixed some minor
  gameplay related issues that I will not mention here in detail.” [12]
- **November 11, 2014, v1.02:** Simon mentions additional gameplay fixes without
  identifying them, alongside the listed technical and achievement fixes. [13]

Both updates precede the November 13 player reports. Neither names Jera. They
therefore neither prove a self-duplication fix nor rule one out. The launch
build and any unrecorded change before those reports remain unresolved; treating
the November 13 prohibition as proof that self-duplication never worked would
overstate the evidence.

#### Recovered launch-era descriptions

The archive search retrieved a **November 8, 2014** capture of Gamepedia's old
`Jera` page. Its metadata identifies **revision 4973**, last modified
**November 5, 2014**. It says: “It doubles consumables in one room.” There is no
explicit statement about copying another Jera. The capture is near release, but
the description is too general to decide whether self-duplication worked. [14]

A **December 25, 2014** capture of the merged `Cards and Runes` page likewise
describes pickup/chest cloning without specifying the self-copy exception. This
later generic description overlaps with the period when player reports already
describe failed direct copying. Consequently, omission of the exception from
the earlier generic description is not positive proof of eligibility. [15]

The Fandom API exposes a surviving `Jera` page history beginning with a
**November 23, 2014** redirect to `Runes`, and `Cards and Runes` history beginning
with a **December 3, 2014** merge. Neither current title's earliest surviving
revision alone recovers the initial game's rules. A November 13 Platinum God
capture was listed by Wayback's CDX index, but its contents could not be
retrieved because of HTTP 429 responses. The index entry is not mechanical
evidence. [16][17][18]

The final API check retrieved all **10 surviving `Runes` revisions**, beginning
with **11880, November 7, 2014**. The first revision transcludes
`{{Rune of Jera}}`; it does not contain the underlying effect description.
The corresponding `Template:Rune of Jera` title is missing from the current
API. Therefore, reading this table's revision alone cannot recover what a reader
would have seen in its Jera row at the time. [19][22]

The accessible `Talk:Runes` history gives an explicit exception in revision
**32388, November 19, 2014, 16:40:26 UTC**: “Duplicates all pickups except Rune
of Jera.” Revision 32391 retains it two minutes later. This confirms historical
wiki documentation of the restriction by that date, not the launch game's rule
or the date any engine change occurred. An explicit API lookup for archived
revision **4973** returns `badrevids` with that revision marked missing; it
cannot recover the November 5 text through the current wiki. [20][21]

The deeper search covered developer launch-week patch posts, early patch-note
mirrors, Wayback page captures and capture indexes, surviving merged-page and
talk-page API histories, contemporary community discussions, and searches for
dated direct gameplay footage. No launch-build test or located video directly
showing Jera copying a dropped Jera was obtained. The result is an unresolved
launch-build question, not a finding that the remembered behavior never existed.

After the PC clarification, Steam's own **within-topic comment search** was
checked for both developer patch threads, rather than relying only on indexed
web-search snippets. Positive controls using `gameplay` returned matching posts
in both threads. Searches for `jera`, `rune`, `duplicate` and `duplication`
returned no relevant copying discussion: the sole `rune` match in v1.01 concerned
a graphics problem; the other searches returned no results. This closes those
specific keyword checks, not every possible wording or an undocumented engine
change. A November 10, 2014 Idle Thumbs post also describes ordinary duplication
without testing another Jera, so it does not settle the question. [24][25]

A **January 11, 2017** discussion separately describes using **D1** to copy a
dropped Jera; its comments also describe direct Jera-on-Jera as prohibited.
This is an indirect method and does not establish the direct interaction or
its availability throughout Afterbirth+. [11]

## Batteries and other alleged nerfs

The old battery-fed break is explicitly documented in the Afterbirth+ Blank
Card entry. Community strategy references still describe using Clear Rune with
Jera and batteries in Repentance. The supported interpretation is a harder setup,
not proven removal of repeatable duplication. This does not guarantee a
self-sustaining loop
for any particular battery count or fixture. [1][4]

Restock pricing is a separate mechanic. Community documentation describes rising
prices and a 99-cent cap, but this research did not establish its complete
historical transition. It should not become a Jera change by implication. [5]

A lower-priority guide claims shop copies keep their prices, conflicting with
Platinum God and indexed wiki text. Prefer the agreement between the established
references for the documented rule; measure the target build before promising
runtime behavior. [2][6][7]

No supported version change was established for chest reward identity, recursion
markers, Sack Head, booster interactions, or a Repentance+-specific Jera nerf.
Missing evidence is not proof that no such changes ever occurred.

## What the official notes actually establish

The official Steam archive contains these distinct entries: [3]

- **1.7.5, November 10, 2021:** “Rebalanced the cooldown of Blank Card, Placebo
  and Clear Rune with certain effects.” It names no rune and gives no Jera
  charge value.
- **1.7.7, December 3, 2021:** explicitly changes D1 so its copies can differ
  from the original pickup. That statement concerns D1, not Jera.
- **1.7.9, November 4, 2022:** adjusts Blank Card cooldowns for some cards. It
  does not repeat the three-item statement above or establish a Jera charge
  change.

Consequently, do not assign the four-to-twelve comparison specifically to 1.7.5
or 1.7.9. A dated launch-era reference or historical build observation would be
needed to pin the exact transition.

## Restoration candidates

**The narrowest supported candidate is an optional four-room Clear Rune charge
when holding Jera.** It targets the documented repeat-use cost while retaining
the game's current division between card and rune copiers. This is a design
recommendation, not a verified implementation recipe. Its feasibility and charge
handling remain untested.

Restoring Blank Card's Jera interaction is a separate candidate if recovering
the exact old combination matters. Restoring all rune copying would broaden the
effect to other runes. Changing Clear Rune's pools would separately address access.
Neither decision follows automatically from reducing Jera's charge requirement.

There is insufficient evidence here to justify changing ordinary Jera's chest
contents, shop pricing, or self-duplication rules as historical restorations.

## Current-target limits

The repository's [installed-game evidence](repentance-plus-installed-evidence.md)
identifies target **Repentance+ 1.9.7.17**, but contains no Jera-specific native
behavior or held-rune charge observations. The recorded Windows installation was
not available to this research checkout. No game was launched or modified.

Before implementation, establish that build's Clear Rune/Jera charge cost,
Blank Card's response to Jera, battery recharge behavior, and any shop/chest rule
the proposed feature would touch. The present research does not prepare console
recipes or claim those checks have passed.

## Sources and confidence

All web references were consulted on 2026-11-13. Sources [1] and [2] were directly
retrieved and cross-checked at the relevant entries. The official archive was
checked against its version headings rather than attributing an archive-wide
search match to the newest patch.

1. **Secondary, version-specific reference:** [Platinum God — Afterbirth+](https://tboi.com/afterbirth-plus).
   Relevant entries: Blank Card and Rune of Jera. This is maintained community
   documentation, not vanilla source code or a contemporaneous patch snapshot.
2. **Secondary, version-specific reference:** [Platinum God — Repentance](https://tboi.com/repentance).
   Relevant entries: Clear Rune, Blank Card and Rune of Jera. Its Repentance
   designation does not independently validate the repository's Repentance+ build.
3. **Primary, historical patch statements:** [Official Steam announcement archive](https://store.steampowered.com/news/posts/?appids=250900&enddate=1670456752&feed=steam_community_announcements).
   Contains the dated 1.7.5, 1.7.7 and 1.7.9 entries discussed above; not an
   exhaustive history of Jera.
4. **Secondary strategy corroboration, indexed excerpts only:** [Isaac Wiki — Clear Rune](https://bindingofisaacrebirth.wiki.gg/wiki/Clear_Rune)
   and [Breaking Run](https://bindingofisaacrebirth.wiki.gg/wiki/Breaking_Run).
   Full-page requests returned HTTP 403. Use these as corroboration, not primary
   confirmation or a verified battery-count recipe.
5. **Secondary, indexed excerpts only:** [Isaac Wiki — Blank Card](https://bindingofisaacrebirth.wiki.gg/wiki/Blank_Card).
   Restock interaction lead; its complete version history was not verified.
6. **Secondary, indexed excerpts only:** [Isaac Wiki — Jera](https://bindingofisaacrebirth.wiki.gg/wiki/Jera).
   Corroborates free shop copies and content categories; full-page access blocked.
7. **Conflicting secondary account:** [Bamboo Gaming — Jera](https://www.bamboogaming.net/the-binding-of-isaac/consumables/jera).
   Its shop-price claim is not sufficient evidence of a historical nerf.
8. **Contemporary player reports:** [Reddit — PSA: Rune of Jera, November 13, 2014](https://www.reddit.com/r/bindingofisaac/comments/2m54c2/psa_rune_of_jera/).
   Relevant comments by everythings_alright and the SrewTheShadow/leonvision
   exchange discuss the direct restriction. Full discussion retrieved.
9. **Contemporary player reports:** [Reddit — TIL: You cannot duplicate Jera using Jera, September 27, 2015](https://www.reddit.com/r/bindingofisaac/comments/3mjpm1/til_you_cannot_duplicate_jera_using_jera/).
   Separates the poster's failed direct attempt from a commenter's disputed 3DS
   Blank Card account. Full discussion retrieved.
10. **Retrospective, unverified recollection:** [Reddit — Anyone else remember when Jera came out?, July 13, 2023](https://www.reddit.com/r/thebindingofisaac/comments/14yorea/anyone_else_remember_when_jera_came_out/).
    Claims initial self-duplication without a version or patch citation.
11. **Contemporary player report of a different method:** [Reddit — The D1 is one of the best active items in the game, January 11, 2017](https://www.reddit.com/r/bindingofisaac/comments/5nfl21/the_d1_is_one_of_the_best_active_items_in_the_game/).
    Describes indirect D1 duplication, with comments distinguishing direct Jera
    duplication. Full discussion retrieved; not native implementation evidence.
12. **Primary developer patch statement:** [Simon — Patch v1.01, November 7, 2014](https://steamcommunity.com/app/250900/discussions/0/613941122666978458/).
    Full post retrieved and cross-checked. Explicitly leaves minor gameplay
    changes undescribed; no Jera entry.
13. **Primary developer patch statement:** [Simon — Patch v1.02, November 11, 2014](https://steamcommunity.com/app/250900/discussions/0/613941122878237053/).
    Full post retrieved and cross-checked. Mentions unspecified gameplay fixes;
    no Jera entry.
14. **Contemporary community documentation, archived:** [Gamepedia — Jera, captured November 8, 2014](https://web.archive.org/web/20141108053151if_/http://bindingofisaacrebirth.gamepedia.com/Jera).
    Retrieved by the archive research delegate; revision and modification date
    are page metadata. The main agent's separate web-tool request could not
    retrieve the replay. No explicit self-duplication rule in the recovered text.
15. **Contemporary community documentation, archived:** [Gamepedia — Cards and Runes, captured December 25, 2014](https://web.archive.org/web/20141225093344if_/http://bindingofisaacrebirth.gamepedia.com/Cards_and_Runes).
    Retrieved by the archive research delegate; the generic Jera description does
    not specify the self-copy exception.
16. **Wiki revision metadata and content:** [Fandom API — earliest surviving Jera revisions](https://bindingofisaacrebirth.fandom.com/api.php?action=query&titles=Jera&prop=revisions&rvprop=timestamp%7Cuser%7Ccomment%7Ccontent&rvslots=main&format=json&rvlimit=50&rvdir=newer).
    A redirect under the surviving title does not recover its earlier lost page.
17. **Wiki revision metadata and content:** [Fandom API — earliest surviving Cards and Runes revisions](https://bindingofisaacrebirth.fandom.com/api.php?action=query&titles=Cards_and_Runes&prop=revisions&rvprop=timestamp%7Cuser%7Ccomment%7Ccontent&rvslots=main&format=json&rvlimit=50&rvdir=newer).
    The earliest returned revision identifies a merge, not launch-day behavior.
18. **Capture index only:** [Wayback CDX — Platinum God, 2014–2015](https://web.archive.org/cdx/search/cdx?url=platinumgod.co.uk&output=json&filter=statuscode:200&from=2014&to=2015).
    Capture existence was inspected; the November 13 replay was rate-limited.
19. **Surviving wiki revision content:** [Fandom API — Runes, oldest first](https://bindingofisaacrebirth.fandom.com/api.php?action=query&format=json&prop=revisions&titles=Runes&rvdir=newer&rvlimit=max&rvprop=ids%7Ctimestamp%7Ccomment%7Ccontent&rvslots=main).
    Earliest revision and revision count independently cross-checked. Its Jera
    row is a template transclusion, not an inline effect description.
20. **Contemporary wiki discussion:** [Fandom API — Talk:Runes, oldest first](https://bindingofisaacrebirth.fandom.com/api.php?action=query&format=json&prop=revisions&titles=Talk%3ARunes&rvdir=newer&rvlimit=max&rvprop=ids%7Ctimestamp%7Ccomment%7Ccontent&rvslots=main).
    Revisions 32388 and 32391, their timestamps, and the explicit exception were
    independently retrieved and cross-checked.
21. **Missing-revision response:** [Fandom API — revision 4973](https://bindingofisaacrebirth.fandom.com/api.php?action=query&format=json&prop=revisions&revids=4973&rvprop=ids%7Ctimestamp%7Ccomment%7Ccontent&rvslots=main).
    Independently retrieved: `badrevids` marks revision 4973 missing.
22. **Missing template history:** [Fandom API — Template:Rune of Jera](https://bindingofisaacrebirth.fandom.com/api.php?action=query&format=json&prop=revisions&titles=Template%3ARune%20of%20Jera&rvdir=newer&rvlimit=max&rvprop=ids%7Ctimestamp%7Ccomment%7Ccontent&rvslots=main).
    Independently retrieved: current API marks the template page missing.
23. **Primary release dates:** [Rebirth on Steam](https://store.steampowered.com/app/250900/The_Binding_of_Isaac_Rebirth/)
    and [Afterbirth on Steam](https://store.steampowered.com/app/401920/The_Binding_of_Isaac_Afterbirth/).
    Release metadata dates the games, not the owner's play session or build.
24. **Steam topic-comment search:** [v1.01: Jera](https://steamcommunity.com/app/250900/discussions/search/?gidtopic=613941122666978458&q=jera&l=english),
    [v1.02: Jera](https://steamcommunity.com/app/250900/discussions/search/?gidtopic=613941122878237053&q=jera&l=english).
    The `q` parameter was separately checked for `rune`, `duplicate`,
    `duplication` and the positive control `gameplay`. Main agent verified the
    form, v1.01 Jera search and positive control; the bounded remainder was
    executed by a research delegate.
25. **Contemporary player discussion, nondiagnostic:** [Idle Thumbs — Binding of Isaac: Rebirth, page 3](https://www.idlethumbs.net/forums/topic/9517-binding-of-isaac-rebirth/?page=3).
    November 10, 2014 ordinary-effect description; no direct self-copy test.
