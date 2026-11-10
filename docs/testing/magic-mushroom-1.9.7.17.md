# Magic Mushroom: native API prerequisite

Issue [#4](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/4)
remains open. No Magic Mushroom implementation or modified-pool engine pass is
claimed. The required change is one normal Boss entry and an update to the
existing normal Treasure entry for collectible 12, both at Weight 1,
DecreaseBy 1 and RemoveOn 0.1. Other entries/pools/effects stay intact. The
independent persistent toggle is required now that configuration issue #3 has
landed, including its next-new-run and Continue semantics.

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

Preserve the exact acceptance criteria while resolving the implementation path.
Still required: effective Boss/Treasure definition evidence, unchanged unrelated
definitions, once-only application across Continue/reload, and independent
toggle-off restoration under the established configuration semantics. The
historical archive inspection is vanilla baseline evidence only. Do not infer
modded pool behavior from it or request random loot rolls as absence tests.

Use the [shared validation guide](../agents/game-validation.md) for future
owner interaction and evidence collection. No production deployment, restart,
save/settings write or fixture restore was performed for this capability check.
