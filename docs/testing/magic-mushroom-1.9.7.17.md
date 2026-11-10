# Magic Mushroom: validation ledger

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

Local checks pass: configuration (16 cases including eight independent gates),
compatibility regressions, pool-rule/diagnostic contracts, asset definitions,
existing batch/Maw/stomp harnesses, and Lua syntax. These are source and harness
evidence only. The diagnostic `tools/validation/pool-rule-probe.lua` checks
metadata before mutation and then, only on explicit Run, isolates a disposable
run to a single identity and checks bounded depletion against an explicit
fallback. It must not be used in a valuable run. It permits one destructive
pool check per fresh run; its Continue query does not isolate or reset pools.
Its early native-pick trace also records selections before game-start settings
are chosen. The baseline and installation/loading smoke are captured below;
collection-exclusion acceptance and early-generation timing remain unverified.

Starting-item generation is handled in MC_PRE_GET_COLLECTIBLE, before native
selection, not only at game start. The configuration preview reloads the selected
slot and uses next-run choices at frame zero, or a matching resumed-run snapshot
after frame zero. It does not change other features' active cache or write data.
Player initialization/exit invalidates preparation; the game-start listener
confirms the actual selected run settings without resetting weights. Same-seed
fresh and Continue selection have local contracts, with engine timing still
pending validation.

The engine protocol also captures 64 fixed-seed nondecreasing queries for every
native pool, both before and after excluding just the two Magic Mushroom
identities. Capture the baseline before installing the feature. Compare equal
start seeds and the same build/other settings using
`tools/validation/pool_fingerprints.py`: On `without_magic` profiles must match
the baseline, and Off `full` profiles must match the baseline. The comparer
rejects missing pools, incomplete/duplicate captures, seed differences and changed
outputs. This combines unchanged source/archive records and targeted-only
production mutations with actual native preservation/restoration evidence;
finite fingerprints alone are not an enumeration of every engine entry/weight.
Native helper XML/metadata plus per-pool controlled depletion remain separate
parts of the exact-definition evidence. Fingerprint excludes only Magic Mushroom
and Run is destructive to the rest of the disposable pools; use fresh runs
between those tests. The completed baseline capture is recorded below.

The feature-reference documentation thread owns `docs/features/**` and the
root README index. Those files are intentionally unchanged here; hand off
actual behavior, the eighth option and final evidence after implementation lands.

## Native baseline captured, 2026-11-10

The owner started a fresh disposable Normal Isaac run and executed the staged
baseline wrapper. The wrapper loaded mid-run, so fresh setup is owner evidence;
no game-start callback was observed. This is a control with the existing pack
and MCM, before the Magic Mushroom feature was installed, plus nil-returning
diagnostic callbacks. It is not an uninstrumented or whole-pack-absent control.

![Owner baseline completion output](evidence/magic-mushroom-baseline.png)

Screenshot SHA256: `43c7b6391f7f95f149df4fcf36152e1f33d361121ede83f69c1a0fff2a672744`.

The preserved raw output establishes:

- Label `MM_BASELINE`, frame 17, difficulty 0, seed **SVW0 6RZE** / numeric
  **2299138499**. The captured run snapshot uses that same seed.
- Exactly 31 `full` and 31 `without_magic` profiles, 64 outputs each; 64 selected
  JSON records total, one successful completion and no malformed payloads.
- Helper ID -1 (not installed), real item quality 4/type 1/hidden false,
  tags 17826048, MCM 113, and all seven existing saved choices/run settings On.
  The legacy config has no Magic Mushroom key; its false lookup is not a test
  of the new Off toggle.
- No probe-bounded Lua error/traceback. Completion means the baseline was
  captured; it does not establish the feature's modified weights or behavior.

The initial collector hit a sharing violation before copying the log.
`tools/validation/collect-pool-profile.ps1` corrected this by using
FileShare.ReadWrite for every live source read, including hashes. No engine
test was replayed. Its first native capture succeeded with source length 54,413,
mtime `2026-11-10T04:02:20.2965282Z`, and identical before/after SHA256.
The main agent inspected the actual capture command's raw JSON result.

Artifacts are retained outside the game at
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T041352297Z-60f10ba8`:

| File | SHA256 |
| --- | --- |
| `log.txt` | `c6ad5466cf2f0a75e49c919763c15e24c42c0891908f6f47d9f015b1922eb241` |
| `pool-records.jsonl` | `dd7017f5a86f735d355b35eef849113c007ff6ff7c8f31b32e68a5206a9a10aa` |
| `capture.json` | `4dc8e06571a496b145d391f7bb7600b3057b3097f035fa821bc171d93016e5c9` |

Executable hash remains `e5faf6f513c6de9cc9ff1c335ef9c541e2b33fc623aa3b8ffbd2e6a6c0027bb0`.
Legacy deployed main/config hashes are respectively
`caedfc800e679e5b094bcdf38fd4380a7a3a859f7b9891ea9d6eb3e73ba4a530` and
`a6c2443f863914c140134b663259d226e91dbd1e118789851f240c3ed3c811d5`.
PID 26076 was left running during that baseline collection. This historical
state predates the backed-up installation and fresh-state smoke recorded below.

## Current evidence, 2026-11-10

### Installation and fresh-state smoke

The owner closed the game before the maintained installation driver ran. Session
`D:\T3ValidationArchives\issue4-install-0bbc5d5-20261110T113633080Z` retains the
backup subdirectory. Runtime source `0bbc5d5d690b3434bdaec3c057edd01b1c885dc0`
installed 42 files matching the manifest before launch; the driver recorded
`gameStarted=false`. Independent verification found the MCM, userData and
`GameRoot/data` state unchanged; the original pack was archived, userData and
game-data backups match their before-state, the executable is unchanged, and
the game was closed at that verification. The inventory counted 22 MCM, 180 userData, 5 game-data and
14 archived-pack files. No save was restored, and the historical baseline
archive remains untouched.

The stable fresh capture is
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T120500547Z-16bf55d4`.
It contains label `MM_ON_FRESH`, one state, zero malformed records and zero
completion records. The log is 17,389 bytes, has mtime
`2026-11-10T12:02:05.3168015Z`, and has identical before/after SHA256
`11b733b2bd9b4062e55c9325de05d1ec891c4d552b14d0f6436bb8d32cba25de`.
The selected record SHA256 is
`287b87a81acedd9e98d92fb70ca0715fed1189f43b6605a065d6db16b8b55db2`; capture
metadata SHA256 is
`7351cbffaefc415592234287300fb54ff334f2460a2226fee23a2f5f678c9d05`.

The owner started a Normal Isaac run; the observed state had seed `SVW0 6RZE` / numeric
`2299138499`, difficulty 0, frame 18, `continued=false`, feature
`enabled=true`, helper ID 733, and helper quality 4/type 1/tags 17826048/
hidden false. The real item was quality 4/type 1/tags 17826048/hidden false;
MCM was 113. All eight selected and current-run choices were On, including
Magic Mushroom. The trace records exactly
`OUP_POOL_RULE magicMushroom enabled=true metadata=true excluded=12 removed=true phase=game_started seed=2299138499 frame=0`
and `game_started continued=false frame=0`. It contains no
`pick_before_game_started` record, so early selection timing remains untested.
No Lua errors were observed. The owner screenshot and raw capture were inspected.

This is a configuration/loading fresh-state smoke only. Exact weights,
unrelated-pool preservation, depletion/one-item availability, actual grants,
Off restoration and Continue behavior remain **PENDING**. A fingerprint pass
has not been captured.

After launch, 41 of 42 manifest files still matched. The only changed file was
`mods/open_unnerf_validation_observer/metadata.xml`: installed size 284 bytes and SHA256
`c8a8fa15763dc0b445c4196a132e6fcb0ab4b5ec68bc74120ff232c2ccefa302`; staged
size 237 bytes and SHA256
`ef6fe552fd6acc52588926e132d48cac5f37c1f91a7396c141409f27c2f00cbd`. The
installed copy adds version `1.0`, empty visibility and formatting. The cause
is not established; this difference was observed after launch. All Lua and
content files match. Observer main SHA256 is
`32e56e884c63ea2a3153f1b0b9b278850a0c6ebe83af2a16a26c1a3699156e2c`; pack
main SHA256 is
`36f500e9abbde407c3aeffed3fcf6b22db403c908e96589678541a888d13f2f0`.
The copied metadata is at
`C:\Users\Mario\.t3\scratch\2026-11-10-act-as-the-research-sub-e5bb9e30\evidence-issue4-metadata-20261110\observer-metadata.xml`.

### Enabled profile: capture passes, cross-build comparison fails

The owner ran `OUPPoolProbe.Fingerprint("MM_ON_PROFILE")` in the same fresh
run. The stable capture is
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T122248441Z-1884202c`.
It contains 31 `full` and 31 `without_magic` profiles with 64 outputs each,
one state, one successful completion and zero malformed records. Seed
`2299138499` / `SVW0 6RZE`, frame 18, difficulty 0 and observed fresh status
match the state smoke. The probe span has no Lua errors. The log is 45,124
bytes with identical before/after SHA256
`b09cded0b2023318cf806af3e453848f511a4070910715a231bdf293e31682f5`;
selected-record SHA256 is
`e14c5689244e4488137fcb6f773af7858c63a6ac424bbcfd9eda238dc5f1b7e8`.

The pinned comparer (`fd539a4ba70a3a35f46bb0ed3d7b64458cfb14d982c11162e1fa06153d1d6493`)
reports **FAIL** for baseline versus enabled `without_magic`: all 31 pools
differ. The baseline hash, run seeds, pool sets and unique successful
completions were verified. PowerShell initially stopped at the first Python
stderr line, losing the useful error text. A locally verified subprocess
capture recipe recovered exit code 1 and the complete `ValueError` from the
same preserved files; no game test was replayed. That diagnostic is retained at
`C:\Users\Mario\.t3\scratch\2026-11-10-act-as-the-test-sub-79ffd3db\diagnostic-68d6bd2fbc7f484b92a75018ffc6d1c5\comparison-diagnostic.json`.

Offline phase comparisons provide a narrower observation: baseline `full`
versus `without_magic` differs only in `POOL_24` (2/64 samples), while the
enabled capture differs only in `POOL_TREASURE` (2/64) and `POOL_24` (3/64).
The other 30 baseline pools and 29 enabled pools match within their respective
captures. This does not explain the cross-build mismatch or establish exact
weights. Adding content may change seeded initialization, but that cause is
**unverified**. The baseline also lacked an observed game-start callback.

Preservation remains **unverified**. The next comparison will hold installed
content and instrumentation fixed, change only the Magic Mushroom toggle on
fresh same-seed runs, and compare target-excluded profiles. Keep the original
failed comparison as evidence; do not relabel it a pass. Off must still retain
the native original definitions, and controlled native depletion/grant and
Continue checks remain required. The owner has been asked for the independent
fresh-run Boss depletion check; no result is claimed here.

### Historical environment and native API research

The issue worktree started clean at then-current default SHA
`3be8e611c96cb6a48d0d5b8c64f38b06a4ea0829`, including the integrated #1/#3
validation evidence. The root checkout's older HEAD was not used. The owner
explicitly assigned the shared disposable validation session to issue #4.

The earlier read-only inspection of Mafia-Server's deployed
`mods/open_unnerf_pack_validation` found seven configuration choices and no
Magic Mushroom module at that time. Its seven runtime entrypoint hashes matched
the then-current repository files; this was not a full deployment inventory or
proof of which mods a running game loaded. The executable SHA256 recorded then
was `e5faf6f513c6de9cc9ff1c335ef9c541e2b33fc623aa3b8ffbd2e6a6c0027bb0`, with
read-only byte-scan evidence `1.9.7.17.J460`. This finding predates the
installation above and is not the current installation state.

![Owner-supplied native pool API query output](evidence/magic-mushroom-native-api.png)

The earlier capability query showed:

```text
MM_API native
MM_METHOD AddCollectible nil
MM_METHOD AddTemporaryCollectible nil
MM_METHOD GetCollectiblesFromPool nil
MM_METHOD GetPool nil
```

Screenshot SHA256:
`f8667f23b02cbe8943a5897a72453d3ddd8c41ebe863ce89e6e2be9840d8f2f7`.
That protected lookup queried method availability without drawing items or
modifying pools/settings. It records four methods absent in that observed
runtime, not an exhaustive API survey or proof that all native approaches are
impossible. It does not establish current deployed build hashes, pool contents,
or full MCM behavior.

## Historical API research and remaining work

The documented [native ItemPool interface](https://wofsauge.github.io/IsaacDocs/rep/ItemPool.html)
has no pool-entry insertion/edit API. At the time of the query, the four listed
methods were absent in that session; this did not establish an exact native
implementation path. Global item removal affects other pools, and replacing
individual roll results does not prove the required entry definitions. The
[XML reference](https://wofsauge.github.io/IsaacDocs/rep/xml/itempools.html)
does not establish selective replacement of an existing entry or per-run toggle
control over static content. This is historical implementation research, not a
current claim that the pack is uninstalled or that no engine check has occurred.

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
