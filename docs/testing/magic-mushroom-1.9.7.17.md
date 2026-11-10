# Magic Mushroom: native API prerequisite

Issue [#4](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/4)
remains open. A helper-backed implementation is now in development; no
modified-pool engine pass or release is claimed. The required change is one normal Boss entry and an update to the
existing normal Treasure entry for collectible 12, both at Weight 1,
DecreaseBy 1 and RemoveOn 0.1. Other entries/pools/effects stay intact. The
independent persistent toggle is required now that configuration issue #3 has
landed, including its next-new-run and Continue semantics.

## Owner-approved helper implementation

The owner explicitly approved helper-backed behavior if exact weighting,
one-item availability, unrelated pools and toggle/Continue behavior are verified.
The physical record for collectible 12 is therefore not rewritten: one private
native identity mirrors all five of its pools, and generated outputs map to 12.
All other acceptance conditions remain unchanged.

`Mods/Pool Rules/main.lua` provides one registration interface for future
pool-only reverts. Its contract requires a helper definition that mirrors every
pool of the real item, because native RemoveCollectible is global. On runs
exclude the original identity; Off runs exclude the helper. No runtime entries
are appended or reset, including on Continue. Configuration selects active run
settings before notifying rule listeners. MCM stays optional; this adds the
eighth default-On choice while preserving all seven prior defaults and the
disabled Nail/Satanic Bible.

The helper uses quality 4 and `summonable mushroom offensive`, verified from the
current checksum-validated `repentance.a` metadata record (SHA256
`42b3eb47a2f39d7120708ad32a790fc0c1129dd845f3cbdc969d702a5f17152e`).
At run start, a type/quality/tag mismatch excludes the helper and retains the
original item instead of silently applying mismatched selection metadata.
Inventory and direct-pedestal fallback paths prevent a private helper escaping
the normal selection callback. Temporary wisps/modifiers are excluded from the
inventory ownership conversion; broader interactions still need engine checks.

Local checks pass: configuration (15 cases including eight independent gates),
compatibility regressions, pool-rule/diagnostic contracts, asset definitions,
existing batch/Maw/stomp harnesses, and Lua syntax. These are source and harness
evidence only. The diagnostic `tools/validation/pool-rule-probe.lua` checks
metadata before mutation and then, only on explicit Run, isolates a disposable
run to a single identity and checks bounded depletion against an explicit
fallback. It must not be used in a valuable run. It permits one destructive
pool check per fresh run; its Continue query does not isolate or reset pools.
Its early native-pick trace also records selections before game-start settings
are chosen. No engine check has run yet, including the collection exclusion
and early-generation paths.

The feature-reference documentation thread owns `docs/features/**` and the
root README index. Those files are intentionally unchanged here; hand off
actual behavior, the eighth option and final evidence after implementation lands.

## Current evidence, 2026-11-10

- The issue worktree started clean at current default SHA
  `3be8e611c96cb6a48d0d5b8c64f38b06a4ea0829`, including the integrated #1/#3
  validation evidence. The root checkout's older HEAD was not used.
- Read-only inspection of Mafia-Server's deployed
  `mods/open_unnerf_pack_validation` found the seven existing configuration
  choices and no Magic Mushroom module. The seven runtime entrypoint hashes
  matched the current repository's corresponding files; this is not a full
  deployment inventory or proof of which mods a running game loaded.
- Executable SHA256:
  `e5faf6f513c6de9cc9ff1c335ef9c541e2b33fc623aa3b8ffbd2e6a6c0027bb0`.
  A new read-only byte scan found `1.9.7.17.J460`. Blank Windows version fields
  do not contradict that build evidence. Build identification is separate from
  the console capability observation below.
- The owner confirmed MCM is active, supplied the console screenshot below,
  and explicitly assigned the disposable shared test session to issue #4.
  No specific MCM version is inferred from that statement.

![Owner-supplied native pool API query output](evidence/magic-mushroom-native-api.png)

The main agent read the supplied screenshot directly. It shows:

```text
MM_API native
MM_METHOD AddCollectible nil
MM_METHOD AddTemporaryCollectible nil
MM_METHOD GetCollectiblesFromPool nil
MM_METHOD GetPool nil
```

Screenshot SHA256:
`f8667f23b02cbe8943a5897a72453d3ddd8c41ebe863ce89e6e2be9840d8f2f7`.

The query read method availability through protected lookups. It did not draw
items or modify pools/settings. These four methods are absent in the observed
runtime. The screenshot does not independently establish deployed build hashes,
pool contents, all possible native APIs, or full MCM behavior.

## Consequence and remaining work

The documented [native ItemPool interface](https://wofsauge.github.io/IsaacDocs/rep/ItemPool.html)
has no pool-entry insertion/edit API. The observation confirms the absence of
the four queried methods in this session; an exact native implementation path
has not been established. Global item removal affects other pools, and replacing
individual roll results does not prove the required entry definitions.
The [XML reference](https://wofsauge.github.io/IsaacDocs/rep/xml/itempools.html)
does not establish selective replacement of an existing entry or per-run toggle
control over static content.

[REPENTOGON's methods](https://repentogon.com/ItemPool.html) are a possible research
direction, not an approved dependency or a verified solution. Its
[pool interface source](https://github.com/TeamREPENTOGON/REPENTOGON/blob/0cd8f863fe9947a8414d9018a700269603e629e6/repentogon/LuaInterfaces/LuaItemPool.cpp)
returns copied descriptor tables from GetCollectiblesFromPool, and its add paths
insert entries rather than replacing Treasure's existing entry. Editing those
copies or appending a second Treasure entry would not meet acceptance.

## Pointers from other mods

The owner requested existing GitHub implementations and prioritized a simple
player installation. These are source references, not dependencies added to the
pack or engine-tested solutions for #4:

- **Racing+**, pinned at `3dc91d15709c526461cbd345a92912c4c2f42ad2`:
  its [partial content XML](https://github.com/Zamiell/racing-plus/blob/3dc91d15709c526461cbd345a92912c4c2f42ad2/mod/content/itempools.xml#L3-L5)
  adds a custom Magic Mushroom Placeholder with values 0.5/0.5/0.05. Its
  [ExtraStartingItems feature](https://github.com/Zamiell/racing-plus/blob/3dc91d15709c526461cbd345a92912c4c2f42ad2/src/classes/features/optional/gameplay/ExtraStartingItems.ts)
  swaps helper pickups to real items, handles duplicate pickups and inventory
  rerolls, and removes helper IDs from pools. The relevant GetCollectible and
  RemoveCollectible calls are native APIs; **neither was reported missing** in
  our screenshot. This is a useful configurable native pattern, but it adds
  custom helper entries rather than changing the existing vanilla entry. Its
  first-floor behavior is not a whole-run weight/depletion equivalence proof.
  The repository also contains a full resource pool table; that separate
  approach would violate this issue's whole-file-replacement restriction.
- **Revelations**, pinned at `1ce39bf9289affb59702279d56e1ca197bfd6899`:
  its [special-room callback](https://github.com/filloax/revelations-mirror/blob/1ce39bf9289affb59702279d56e1ca197bfd6899/scripts/revelations/chapter1/glacier/features/dante_mega_satan.lua#L222-L231)
  redirects non-Devil selections to the Devil pool through GetCollectible.
  This demonstrates native selection interception, not entry mutation. The
  example's surrounding StageAPI room machinery need not be adopted to study
  that native callback.

These sources establish native workarounds worth assessing, not impossibility
of a native solution or compliance with the exact #4 criteria. Partial XML
addition of a new helper does not establish whether an existing vanilla ID is
replaced or duplicated. A substitute implementation would need an explicit
requirements decision if its actual pool definitions differ from the request.

Prefer the existing pack-only installation with MCM optional. A bundled Lua
helper need not add a player installation step, but it cannot expose missing
engine functions on its own. An external engine extension is different:
[REPENTOGON's installation guide](https://repentogon.com/install.html) requires
its launcher and setup. No dependency, launcher, helper item or gameplay change
was installed during this research.

## Remaining acceptance

Preserve the exact acceptance criteria while resolving the implementation path.
Still required: effective Boss/Treasure definition evidence, unchanged unrelated
definitions, once-only application across Continue/reload, and independent
toggle-off restoration under the established configuration semantics. The
historical archive inspection is vanilla baseline evidence only. Do not infer
modded pool behavior from it or request random loot rolls as absence tests.

Use the [shared validation guide](../agents/game-validation.md) for future
owner interaction and evidence collection. No production deployment, restart,
save/settings write or fixture restore was performed for this capability check.
