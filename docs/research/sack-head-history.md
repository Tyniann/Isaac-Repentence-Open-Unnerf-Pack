# Sack Head: historical behavior and unnerf assessment

Researched 2026-11-13. Current project target: Repentance+ v1.9.7.17.
This is source research, not gameplay validation or an implementation spec.

## Assessment

**Current battery presence:** after initially reporting no batteries in hundreds
of sacks, the owner observed batteries dropping during the disposable Hard-mode
test and explicitly cancelled further testing. Batteries can therefore still
drop from sacks in the supported build according to that direct owner
observation. The community reference's **6% figure remains unverified**: the
cancelled experiment does not establish an exact rate, a historical rate change,
or an active-item condition. Do not infer unchanged odds from patch-note silence.

Sack Head is a reasonable candidate for restoring **Shop availability**.
Repentance's reproduced release notes explicitly list reduced Shop weight and
addition to the Secret Room pool. The current item reference lists Shop weight
0.5 and Secret Room weight 1.0. Restoring full Shop weight is a plausible
proposal; confirm historical and current native pool data before implementation.
The Secret Room addition also dilutes the other items' selection shares, holding
their weights fixed. Retaining it is therefore a tradeoff, not an unconditional
benefit. A restoration of the old pool placement would also consider removing
that entry. [4][5]

The evidence does **not** establish a reduction in its pickup-to-sack conversion
chance. Platinum God's separate Afterbirth, Afterbirth+, and Repentance guides
all currently list 10% for coins and 20% for bombs, keys, cards, runes, and
batteries. IsaacGuru gives those same rates for Repentance and Repentance+.
These are secondary references, not preserved release-day code or measurements.
Their agreement cannot prove that no earlier change ever occurred. [2][3][4][5]

## Timeline and comparison

| Period | Supported description | Evidence limit |
| --- | --- | --- |
| Afterbirth release, 2015-10-30 | Sack Head was introduced in Afterbirth. Near-launch players describe coin conversion, bomb conversion, and powerful battery/D20 combinations. | The release date is first-party; the December discussion is contemporary player testimony, not an exhaustive item specification. [1][6] |
| Afterbirth version guide | 10% coin conversion; 20% for bombs, keys, cards, runes, and batteries; one sack on acquiring the item; Shop pool. | The guide is maintained today and is not an archived October 2015 snapshot. [2] |
| Afterbirth+ version guide | Same listed conversion rates, immediate sack, and Shop pool. | This likewise does not establish the exact behavior on the DLC's launch day. [3] |
| Repentance release, 2021 | Reduced Shop weight; added to Secret Room. Its version guide continues to list 10%/20% conversion. | Pool changes are available in a secondary reproduction of the release notes; the matching first-party release entry was not retrieved. [4][7] |
| Repentance v1.7.2 | Fixed a progression-related tarot card from a special rock sometimes becoming a sack. | First-party patch notes; this is a specific bug fix, not evidence of a general conversion-rate nerf. [8] |
| Current Repentance+ reference, target 1.9.7.17 | 10% coin conversion; 20% for bombs (including troll bombs), keys, cards, runes, and batteries; immediate sack; Shop weight 0.5; Secret and Greed Secret weights 1.0. | Current community reference, not a local engine test. [5] |

## What the contemporary evidence actually establishes

The December 13, 2015 discussion's opening summary mentions only coins, but
comments in the **same thread** report troll bombs and ordinary bombs turning
into sacks. Consequently, that opening summary does not support a claim that
Sack Head originally converted only coins and gained other pickup types later.
The thread also documents the contemporary importance of batteries and the D20
interaction. It does not establish exact conversion probabilities. [6]

October 2020 community summaries claim a 33% conversion chance and include
pills. Both are explicitly descriptions of wiki information, and both are from
the same commenter; they are not independent measurements. They conflict with
the version-specific guides and should not become an assumed historical
baseline or justification for adding pill conversion. [9][10]

The current reference lists coins, bombs, keys, cards, runes, and batteries as
eligible. It excludes pickups spawned directly by Isaac (its example is IV Bag)
and the contents of other sacks, and describes conversion of eligible pickups
already present on the floor. That exception should not be generalized to every
pickup arising from an item interaction without testing its particular source.
Hearts, pills, and chests are not in its eligible list. [5]

## Sack contents and indirect effects

Follow-up investigation on 2026-11-13 focused on sacks themselves rather than
the items that produce them. No historical build was run. Most available detail
remains community documentation; direct wiki requests returned 403 and excerpts
were treated as leads rather than inspected full pages.

### Current normal brown sacks

The current Repentance+ community reference lists **1–4 pickups** from keys,
coins, bombs, cards/runes, and batteries. It does not list hearts, pills, or
chests as normal brown-sack rewards. The owner subsequently observed battery
drops in the disposable current-build test, resolving the initial disagreement
about their presence. The listed category percentages include 6% batteries, are
rounded, and sum to 101%; they are documentation claims rather than measured
current-engine odds. This reference does not establish the launch-day table,
the exact current battery mechanism, or a historical change in average payout.
[12]

Item conversion rules and the contents of sacks are separate mechanics. The
2015 reports and today's version guides both discuss batteries and D20
combinations. Those sources alone could not establish current battery presence;
the owner's subsequent observation supplies that evidence, without establishing
an exact rate or historical comparison. [2][4][6]

### Follow-up on the disputed battery claim

The owner's initial report was a reason to check the reference table,
not an established explanation of what changed. A focused follow-up found no
verified condition involving active-item charge, character, unlocks, difficulty,
or pickup source that resolves the discrepancy. Do not invent one to reconcile
the sources. No modern footage demonstrating a battery from an ordinary brown
sack was inspected during that source-only stage. The later native pilot and
owner observation are recorded separately below.

The initial read-only installed-file investigation did not start because the
remote project mapping was missing. Access was subsequently resolved by using
Mafia-Server's existing scratch project and active Codex connection. One remote
attempt then incorrectly treated that machine's empty outgoing environment-link
list as an access failure; a corrected local-shell assignment succeeded. These
were execution mistakes, not evidence that shared-environment access was absent.

The successful read-only check on 2026-11-13 established:

- The game root `D:/The.Binding.of.Isaac.Repentance.v4.0.2` exists and is readable.
- `isaac-ng.exe` hashes to SHA-256
  `e5faf6f513c6de9cc9ff1c335ef9c541e2b33fc623aa3b8ffbd2e6a6c0027bb0`,
  matching the previously recorded target executable. Its Windows version
  fields are blank; this hash comparison is not a new runtime version check.
- The installed `changelog.txt` starts at v1.7.9b. Searches for sack/battery
  entries found no normal-sack battery probability or removal rule. For example,
  line 611 concerns The Hermit? converting sacks into pennies, not their loot.
  This older changelog cannot establish all later Repentance+ behavior.
- The retained archive-research notes and inspected third-party EID description
  text did not supply the native brown-sack reward logic. This was not an
  exhaustive reverse-engineering analysis of the executable or packed resources.
- No game launch, console input, GUI interaction, save/settings/mod change,
  or other game-directory write was performed.

Evidence and command outputs are retained in
[Read local Windows sack evidence on Mafia-Server](t3-thread://v2/e15aaef5-d140-426f-b121-95959c5277c7/mcp:launch:2b352be0d6a944a8d1b482c336085bb711acbc4c3da0ae8500a7895a6d295188).
The subsequent disposable native test and owner observation are recorded below.
Battery presence is no longer the unresolved question; the exact probability,
conditions, and historical comparison were not established.

### Native pilot and owner cancellation

The owner explicitly handed over the shared game for a disposable test on
2026-11-13. The supported desktop connector failed twice with a missing native
pipe, so the owner started a new Hard-mode Isaac run manually after the
diagnostic was staged. Only the diagnostic mod was loaded; original mods and all
186 files in the configured save directory were preserved first.

The main-authored diagnostic observed native sack collection and pickup-init
events, without replacing loot or callback return values. Its source SHA-256 was
`849261a230abf215f6b45aded2fdfd6b26e48ad49ed79ad8db7297e690cead67`.
The smallest engine pilot passed:

- Repentance+ flag true, difficulty 1, seed `3360254081` (`28XB Q9HK`).
- One forced normal brown sack, InitSeed `646738969`, was collected with an
  empty D6 (item 105, charge 0).
- It generated one key and one coin. Both pickup-init records identify native
  spawner type 5, variant 69. No battery appeared in that single pilot.
- Native result: completed 1, success true, actorRestored true; no Lua errors.
- Stable preserved log: 17,452 bytes, SHA-256
  `b3acc6183b07fd00f34f30e5e4c983597c2f6ecfda4ba1a0ef89b289eb99c224`.

After main-agent inspection of that pilot, a larger sample was initiated. The
owner then reported, **"cancel test, I already saw batteries dropping"**.
Further sampling was cancelled. This owner observation supports current battery
presence; no completed rate study or definitive charge-condition comparison is
claimed. No additional tests should be run under that cancelled request.

Windows session archive:
`D:/T3ValidationArchives/sack-battery-20261113T032521104Z`.
Cancellation cleanup completed on 2026-11-13: the owned test process was stopped;
all 186 original save/settings files, all 287 original mod files, and all eight
original game-data files matched their pre-test length/hash manifests, with no
extra files or mismatches. The diagnostic mod and its data were archived, and
the changed disposable save directory was retained separately. The game was not
relaunched. Backups and evidence remain in the session archive.

Cleanup command output and verification are retained in
[Stop cancelled sack test and restore original game state](t3-thread://v2/e15aaef5-d140-426f-b121-95959c5277c7/mcp:launch:d36ebd19cf7cc09a1111f02fd8a4d38fb7d7eb822f77c607db16990cce8847da).

### Reported loss of reward repeatability

A community wiki mirror describes same-floor sacks tending to have the same
contents, with that behavior removed in Afterbirth+. This is a useful lead for
why early Sack Head could feel more predictable, but neither a first-party
change record nor the historical seed behavior was established here. Do not
treat that lead as a validated mechanic or conflate it with an item-specific
Repentance nerf. No historical/current reward-distribution comparison was
measured. [11]

If the reported correlation supplied repeated useful cards on a floor, removing
it could reduce the reliability of a resource loop without changing the number
of rewards per sack. That is an implication of the reported behavior, not a
measurement of the old engine. The evidence does not establish a floor-wide
guarantee, an identical full reward sequence, or which RNG seed produced it.
The appropriate unresolved question is the historical correlation mechanism,
not an assumed nerf to battery or card probabilities.

### Repentance additions and related mechanics

- The current reference identifies **Black Sacks** as a Repentance addition,
  unlocked through Tainted Judas. They rarely replace brown sacks and have a
  separate reward list: pills, bombs, black hearts, and bone hearts. This is
  a new sack variant, not evidence that ordinary brown sacks acquired that table.
  Brown sacks can also be sold in shops. [12][13]
- The reproduced Repentance release notes document the D20 losing the ability
  to reroll already opened **chests**. They do not document a parallel change
  to opened sacks. This can weaken a D20 resource loop without proving a sack
  loot-table nerf. [7]
- Those notes also introduce Micro Batteries, which supply two charges. The
  current battery reference agrees on the amount. This is a change to the wider
  recharge economy; these sources do not establish which sack-generated battery
  rewards use general battery-subtype selection. Do not infer a measured loss
  of charge per sack from random-battery subtype odds alone. [7][14]

No retrieved first-party change record established a reduction in normal-sack
pickup count, battery chance, or card/rune chance. Patch-note silence cannot
establish unchanged behavior. Current battery presence instead rests on the
owner's observation; historical odds remain unresolved. The reported
Afterbirth+ change to repeatability is a separate historical sack-content lead.

## Sack contents converting into more sacks

The owner clarified the historical claim: with Sack Head held, eligible coins,
bombs, or keys released by one sack could themselves become sacks. This is a
claim about applying Sack Head's replacement effect to a sack's payout, rather
than a separate sack entry in the sack's reward table. It could explain chains
without any special trinket if the old engine allowed those pickups to be
converted. That explanation is conditional; it is not established by the
current loot table or the later Equality! synergy.

The current 1.9.7.17 reference explicitly excludes the contents of other sacks
from Sack Head conversion. This identifies the precise rule to compare against
old behavior; it does not date the introduction of that rule. [5]

The approximate 2014 recollection should be investigated against early
Afterbirth, released October 30, 2015. Sack Head was introduced in that DLC.
Equality!, introduced in Afterbirth+, cannot explain a genuinely pre-2017
observation. Its documented interaction below is therefore not an answer to
this earlier claim. [1][5][16]

### What the preserved early descriptions say

Wayback's March 12, 2016 Sack Head capture describes broad pickup replacement
and says:

> This includes pickups spawned by anything: chests, slot machines, special shopkeepers, etc.

The November 23, 2016 capture retains that wording. Neither explicitly
includes or excludes the contents of sacks. These are preserved contemporary
community descriptions, unlike a currently maintained Afterbirth guide, but
the broad wording still cannot prove that every pickup source was eligible.
In particular, the old description also includes pills, conflicting with the
current eligible list; it is not a verified specification of native code.
The first inspected January 2017 description retains the broad wording. [19][20][21]

The January 26, 2017 capture separately documents a **Flat Penny** chain: a
sack supplies coins, collecting those coins can trigger a key reward, and
Sack Head can replace that reward with another sack. This is another route
to resource chains that should not be mistaken for directly converting the
original sack payout. This inspected capture is after Afterbirth+ launched;
it does not by itself date the interaction to 2015 or 2016. [21]

Targeted searches of pre-2017 player reports and first-party patch notes did
not retrieve an explicit statement confirming direct sack-payout conversion,
denying it, or dating its removal. The December 2015 discussion confirms
multiple pickup types becoming sacks and D20 combinations, not this precise
source rule. The available evidence therefore leaves the owner's specific
mechanism **unresolved**, rather than disproven or explained away by Equality!.
[6][19][20]

Archive retrieval limits matter: the researcher received successful archived
HTML responses for the March and November Sack Head captures, but attempts to
inspect the archived Sack page and further captures hit HTTP 429. The main
agent checked the recorded successful retrieval output; its independent live
retry also hit 429. The archived Sack page's capture date alone establishes
no facts about its contents.

### A separately documented, later Equality! interaction

Follow-up source research on 2026-11-13 found a specific historical interaction
that can also produce sacks from sacks:
**Sack Head plus active Equality!**. The community Sack Head reference explicitly
documents that combination as allowing sacks to produce further sacks, and
marks it as an Afterbirth+ interaction. It does not establish an unconditional
nested-sack chance for Sack Head alone at Afterbirth's 2015 launch. [15]

Equality! was introduced in Afterbirth+. Its old effect required equal coin,
bomb, and key counters and doubled pickups. The Repentance-specific reference
still describes that pickup-doubling effect. The documented nested-sack synergy
requires the trinket's active condition; it should not be generalized to every
sack or to Equality! without Sack Head. Exact conversion order, repeat-chain
limits, and historical engine behavior were not tested here. [15][16]

There is a verified first-party change relevant to the old mechanism:
**Repentance+ v1.9.7.13**, announced September 9, 2025, changed Equality!'s effect
to a tear-rate bonus when the same three counters match. The official notes say:

> Equality: When keys bombs and coins are all equal in number, gives +2 tear rate

The current 1.9.7.17 reference likewise lists the fire-rate effect, whereas the
separate Repentance reference lists pickup doubling. Therefore the old synergy
description must not be presented as a verified current Repentance+ mechanic.
The documented pickup-doubling mechanism has been replaced; the official patch
entry does not separately name Sack Head or claim a sack-specific fix. [16][17][18]

Current Sack Head documentation explicitly excludes the contents of other sacks
from ordinary pickup-to-sack replacement. No retrieved source established
Humbling Bundle as another route to nested sacks. These are source findings,
not new engine tests; the earlier test cancellation and restored game state
remain in effect. [5][15]

The old Equality! pickup interaction is one documented restoration target.
It should not be treated as the only historical way nested sacks could have
occurred without confirming the earlier engine behavior. Neither that synergy
nor the owner's hypothesis supplies a universal sack-within-sack probability
or establishes a change in Sack Head's base replacement rate.

## Candidate scope and outstanding evidence

- **Best-supported candidate:** restore full normal Shop weight; separately
  evaluate undoing the Secret Room addition and its dilution of other rewards.
  The documented direction of the Shop nerf
  is stronger evidence than the exact historical numeric baseline. [4][5][7]
- **Not supported as a historical restoration yet:** raising conversion rates
  to 33%, enabling pill conversion, or changing all sack rewards.
- **Possible further investigation:** recover a dated release-era resource or
  executable observation for probabilities, sack seeding, and direct
  conversion of sack contents. The latter must be checked separately from
  Equality!, Flat Penny, and D20 resource chains. Compare against the current
  documented exclusion without restarting the cancelled game test.
- **Before implementation:** verify native pool weights and mode-specific
  eligibility, including Greed modes. Pool weight is a relative selection
  weight, not an absolute probability per shop slot; restoring it does not by
  itself establish an exact multiplier for the chance of finding the item.

The repository and tracker searches during this investigation found no existing
Sack Head implementation, documentation, or matching issue. No gameplay code,
tracker records, or game installation were changed.

## Sources

All links consulted 2026-11-13. Primary sources were sought first; most balance
details below remain secondary evidence.

1. **Primary, release date:** [Steam: Afterbirth](https://store.steampowered.com/app/401920/The_Binding_of_Isaac__Afterbirth/), release date October 30, 2015.
2. **Secondary, version-specific guide:** [Platinum God: Afterbirth, item 424](https://tboi.com/afterbirth#424).
3. **Secondary, version-specific guide:** [Platinum God: Afterbirth+, item 424](https://tboi.com/afterbirth-plus#424).
4. **Secondary, version-specific guide:** [Platinum God: Repentance, item 424](https://tboi.com/repentance#424).
5. **Secondary, current item reference:** [IsaacGuru: Sack Head, Repentance+](https://isaacguru.com/wiki/isaac/c424), footer identifies game version 1.9.7.17; [Repentance counterpart](https://isaacguru.com/wiki/isaac_repentance/c424), footer identifies 1.7.9b.
6. **Contemporary player testimony, 2015-12-13:** [Afterbirth Sack Head discussion](https://www.reddit.com/r/bindingofisaac/comments/3wmw2e/daily_item_discussion_afterbirth_edition_18_sack/). Relevant comments include buschap on troll bombs and bananabm on ordinary bombs; opening text is incomplete about pickup types.
7. **Secondary reproduction of patch notes:** [Pro Game Guides: Repentance patch notes](https://progameguides.com/binding-of-isaac/the-binding-of-isaac-repentance-patch-notes/), Item pool changes → Shop → Reduced weight and Secret → Added. Retrieved article is marked updated May 24, 2021.
8. **Primary, official developer announcement:** [Steam update archive containing v1.7.2](https://store.steampowered.com/news/posts/?appids=250900&enddate=1622654445&feed=steam_community_announcements), Sack Head tarot-card fix in General fixes.
9. **Secondary, conflicting historical wiki summary, 2020-10-04:** [Sinvicta discussion](https://www.reddit.com/r/Sinvicta/comments/j52ala/daily_isaac_video_discussion_thread/), Lugbor's wiki report.
10. **Secondary, same author's conflicting summary, 2020-10-08:** [Sinvicta discussion](https://www.reddit.com/r/Sinvicta/comments/j7gued/daily_isaac_video_discussion_thread/), Lugbor's wiki report.
11. **Secondary, historical lead only:** [Community wiki mirror: Sack Head](https://isaacrebirthwikijp.netlify.app/wiki/sack_head/), Notes, same-floor sack contents marked removed in Afterbirth+.
12. **Secondary, current reward description:** [IsaacGuru: Grab Bag](https://isaacguru.com/wiki/isaac/5.69.1), current Repentance+ 1.9.7.17 reference, lists reward count/categories and shop availability.
13. **Secondary, current variant description:** [IsaacGuru: Black Sack](https://isaacguru.com/wiki/isaac/5.69.2), identifies Repentance introduction, separate rewards, replacement chance, and unlock.
14. **Secondary, current battery description:** [IsaacGuru: Micro Battery](https://isaacguru.com/wiki/isaac/5.90.2), identifies Repentance introduction and two charges; does not specify sack-specific reward generation.
15. **Secondary, historical synergy documentation:** [Community wiki: Sack Head](https://bindingofisaacrebirth.fandom.com/wiki/Sack_Head), Synergies, Equality! active allows further sacks. Full indexed search text was available; the page's mixed version tags are not proof of current Repentance+ behavior.
16. **Secondary, pre-rework effect:** [IsaacGuru: Equality! in Repentance](https://isaacguru.com/wiki/isaac_repentance/t103), equal consumable counters enable pickup doubling; identifies introduction in Afterbirth+.
17. **Primary, official v1.9.7.13 announcement:** [Internal Item Descriptions, September 9, 2025](https://steamcommunity.com/games/250900/announcements/detail/521976260528701585). Full notes were inspected in [the official news feed](https://steamcommunity.com/app/250900/allnews/), Trinkets, Equality. This is first-party evidence of the new effect, not a separately documented Sack Head fix.
18. **Secondary, current effect:** [IsaacGuru: Equality! in Repentance+](https://isaacguru.com/wiki/isaac/t103), +2 fire rate with equal counters; footer identifies 1.9.7.17.
19. **Preserved contemporary community description, 2016-03-12:** [Archived Sack Head page](https://web.archive.org/web/20160312171305/http://bindingofisaacrebirth.gamepedia.com/Sack_Head), broad pickup-source wording; not explicit about sack contents. Archived HTML retrieved successfully by the researcher; main checked the retrieval output, with independent retry blocked by HTTP 429.
20. **Preserved contemporary community description, 2016-11-23:** [Archived Sack Head page](https://web.archive.org/web/20161123012535/http://bindingofisaacrebirth.gamepedia.com/Sack_Head), same broad source wording; not proof of recursion.
21. **Preserved community description, 2017-01-26:** [Archived Sack Head page](https://web.archive.org/web/20170126233354/http://bindingofisaacrebirth.gamepedia.com/Sack_Head), broad wording plus separate Flat Penny and D20 resource chains. Its date is after Afterbirth+ launched.
