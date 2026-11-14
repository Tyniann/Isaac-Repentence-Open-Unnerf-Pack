# Sack Head: issue #20 validation

[Technical reference](../agents/sack-head.md) ·
[Issue #20](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/20)

## Status

Implementation and local contracts are present. The native source pilot and
corrected Normal-On pool, depletion, ownership and chain checks passed. The
Normal-Off control and actual Greed-mode pool check also passed. The original
setup has been restored and the disposable session returned to the owner.
The tested candidate is archived and the original game setup has been restored.
This receipt certifies the game setup only; GitHub integration is tracked through
issue #20 and its pull request. Release publication is separate.

## Historical native data

The versioned files below are community mirrors of native game XML, not
publisher-hosted sources. The complete files were parsed for every ID 424 row,
including their separate normal and Greed pool sections.

| Version | ID 424 placement | Weight | DecreaseBy | RemoveOn |
| --- | --- | ---: | ---: | ---: |
| Afterbirth 1.06.0109 | shop only | 1 | 0.5 | 0.1 |
| Afterbirth+ 1.06.J168 | shop only | 1 | 0.5 | 0.1 |
| Mirrored Repentance+ | shop | 0.5 | 0.5 | 0.05 |
| Mirrored Repentance+ | secret | 1 | 1 | 0.1 |
| Mirrored Repentance+ | greedSecret | 1 | 1 | 0.1 |

- [Afterbirth file](https://github.com/Derugon/TBoIR-resources/blob/72f096c0669b3c4c9dd91f0dbfb129d006865f5c/1.06.0109/resources/itempools.xml),
  SHA-256 `e81b6321f1bfd20d8b186a3828b5eb38f3e3160bb2b24ff0f745e5a528e96f90`.
- [Afterbirth+ file](https://github.com/Derugon/TBoIR-resources/blob/56df9a8d1f5232bc9bd5c2c7c80b4eeb5344c491/1.06.J168/resources/itempools.xml),
  SHA-256 `11a88dc28c07e153c4072803fe4b31566875d11b04d108dcc40947cb4fcd5296`.
- [Repentance+ file](https://github.com/Derugon/TBoIR-resources/blob/9927c3ea3502ddd9a01a4eeae24b7938eb8d5f5f/resources/itempools.xml),
  SHA-256 `9261ce14b4b65e15045deaac240c7ac46ccb87e55f455e2b0df95fcee4928ede`.

Neither historical file contains Sack Head in Treasure, Secret, Greed Treasure,
Greed Shop or Greed Secret. Restoring the normal Shop entry must not add a
Greed Shop entry. The historical decrease and removal values are restored too.

## Session and build pins

The owner explicitly handed this thread the disposable Mafia-Server session,
including backup, deployment, native checks and restoration. The game was closed
before each deployment. Initial backups contain 189 user-data files and the
game's separate mod-data tree. Original EID, MCM, pack and tinted-rocks trees
were hashed; unrelated mods remain unchanged.

- Session: `D:\T3ValidationSessions\issue20-source-20261114T003441Z`.
- Original state and hashes: `before.json`, `backup-user`, `backup-data`.
- Original pack after test-build deployment: `original-pack` in that session.
- Executable SHA-256:
  `e5faf6f513c6de9cc9ff1c335ef9c541e2b33fc623aa3b8ffbd2e6a6c0027bb0`.
  Windows version fields were blank. The preserved game log identifies
  **Repentance+ v1.9.7.17.J460**, `Game Version: J460`; the directory name is
  not build evidence. The candidate log records **Mod Config Menu v113**.
- Candidate is an uncommitted working-tree build on base
  `536d07ad939216c7ad2e5faf90e5db1390bafef8`.
- Runtime file-map SHA-256:
  `f40c7043579205ba7d9e01a2989a94586640979b752e5e558d9d65e413c645af`.
- 22-file package SHA-256:
  `fd3fd014b546399c89aef50d8d4a8a540170adc76bb3cc81e5e0a86daf8e5719`.
- [Validation fixture](../../tools/validation/sack-head-probe.lua) SHA-256:
  initial `c6a3960eb5ee27f2fe2ba85c64df6c230336d3e1d8804b4d79b8046568ba9f9e`;
  corrected observer `f955f16c00f1f73b57e9b432fc7bc7dc67bd4d0d98db77d9f3b224a1a8d3b631`.

The final working-tree `metadata.xml` description was subsequently corrected
from nine to ten adjustments and now includes Sack Head. Its SHA-256 is
`9bc2d5a4690d68c3589a0e09141e155e1a58850d0681919c814ffaf72cc23ec3`;
the tested package's metadata SHA is
`04041ca11f2249cefa475e06d6eeb54c7f41b83031182a70c30227fc9133c9f1`.
A file-by-file comparison against the package confirmed this description is
the only differing pack file. Gameplay Lua, configuration and content XML
remain byte-identical to the deployed build. No version or mod identity changed;
the package/runtime hashes above describe the tested package, not a repackaged
final artifact.

The complete package file hashes are in the session's `test-build.json`.
The separate source probe stays passive after its four-sack terminal event;
the new validation mod also remains passive until explicitly started.

Isaac reformatted the new source probe's `metadata.xml` on launch, adding
default version `1.0` and empty visibility fields. The deployment guard was
corrected after verifying that its `main.lua` remained byte-identical. Known
metadata normalization is compared separately; code, file sets and original
backups retain exact hash checks. No candidate was installed by the stopped
first deployment attempt.

A later read-only startup capture still contained the previous source-pilot
session, with no running Isaac process, new validation mod or
`ISSUE20_VALIDATE` records. It is not a candidate startup/check failure and
does not establish that the candidate has been loaded. The owner was asked to
launch another fresh normal Isaac run on slot 1 before the next command.

## Native source pilot — pass

This ran with the original production pack, before deploying the fix. Save slot
1 and a fresh normal Isaac run were owner-reported. The probe checked one normal
Isaac with no collectibles except an optional starting D6. It did not observe
the game-start callback, so the fresh/Continue distinction is not independently
engine-observed in this pilot.

The owner ran `lua OUPSackProbe.Start()` and closed the console. Seed
`4095573086`, difficulty `0`, frames 53–414: four normal native sacks opened,
producing nine rewards (four coins, four keys, one card). Each reward's
pre-spawn callback received its real spawn seed and the actual source sack
entity, type `5`, variant `69`. Selection/init callbacks retained the source;
selection's pickup type and init seed were still zero. This supports using the
pre-spawn hook rather than inferring origin from position or frame timing.

Runtime collectible 424 metadata was Type `1`, Quality `3`, Tags `17825792`,
name `#SACK_HEAD_NAME`. The pilot establishes source provenance and metadata,
not successful chain conversion or exact native pool weights.

Captured evidence is under the session's
`source-captures\capture-20261114T004241268Z-dbbe8936`:

- `log.txt`: 34,840 bytes, SHA-256
  `17ad213c2dbf87af92003293349c62177b30000535bf52d7f38ea69eef0aa472`.
- `sack-records.jsonl`: 66 exact-label records, SHA-256
  `294498e676019fc00c6d86b305af901e4e08bde287eb3154f5c0c106393e67a9`.
- Source length, mtime and hash matched before/after the shared-read copy.
  No malformed JSON payloads or matching native errors were found.
- Source-probe Lua SHA-256:
  `82228f722836cb8d64e4f22c7736bfca6a2cf5187a75e68156b20c08e142f79a`.

## Candidate acceptance

### First Normal-On attempt — stopped at depletion assertion

Seed `5127894`, difficulty `0`, helper `734`, active adjustment On, no
Equality!, frame 6583. The native preparation log confirms matching metadata
and exclusion of original ID 424 at game-start frame zero. The isolated Shop
query returned real Sack Head (424). Secret, Greed Shop, Greed Secret, Treasure
and Greed Treasure all returned fallback Breakfast (25), as expected for the
historical placement.

The subsequent decreasing Shop query returned Sack Head, but the following
nondecreasing query did not. The fixture stopped at line 79 with
`unexpected depletion after first draw`. It emitted no depletion detail record
before that assertion; the exact second ID was not captured. This is a failed
fixture expectation, not a verified feature pass. The subsequent diagnostic
below separates room-blacklist interference from weight depletion.
No helper grant or chain fixture ran after this stop.

The log also contains eight native repick-exhaustion warnings. The pool
isolation permits expected fallback checks; these warnings are retained and
must not be used as proportional-rate evidence.

Stable capture:
`candidate-captures\capture-20261114T015949554Z-629cd036`, 19,780-byte log,
SHA-256 `8cd3b898b9f33d825702c5c64b3ff62692299487842223d8b9982c81bb32c6b3`;
eight selected JSONL records, zero malformed, JSONL SHA-256
`bf7b507d80545d4af174ebaa3b6daebdb30446dddd36a44bf02592584670319c`.

### Room-blacklist diagnostic and observer correction

In the same run, the owner made a nondecreasing Shop query, called
`ItemPool:ResetRoomBlacklist()`, then repeated the nondecreasing query with the
same seed `24680`. Results were **25 before, 424 after**; the copied native log
contains `OUP_SACK20_RESET 25 424`. The entry remained available after clearing
the independent room restriction. The failed assertion did not establish that
its weight was exhausted.

This diagnostic's stable capture is
`candidate-captures\capture-20261114T023320370Z-63b3a3e7`, log SHA-256
`c605690741a4216cd8020d23c58dfbaeea409c0d89e134f95a9d12f5d2b579ac`.
The copied log also retains `[ASSERT] - EL: invalid sublist` and repick warnings;
their individual cause is not established. They are not omitted from evidence.

The observer now clears the room blacklist between its controlled pool queries,
records each draw before asserting its result, and resets its own check state
on a new game-start callback. The On/Off local protocol model reproduces the old
failure when a decreasing draw adds a room blacklist, and passes after the
correction. This is a verifier correction; production bytes and runtime file-map
SHA remain unchanged. The corrected native execution passed as recorded below.

The previous observer and manifest are retained under
`observer-update-c6a3960eb5ee-to-f955f16c00f1`. The session's current
`test-build.json` records the observer overlay and its provenance; the original
22-file ZIP remains the immutable base package. The update and restoration
driver passed a full filesystem install/update/restore smoke before deployment.

### Corrected Normal-On run — pass

The owner reported another fresh Normal Isaac run on save slot 1 and ran
`lua OUPSackCheck.Start(8)`, then closed the console. The corrected observer
reported seed `3939804839`, difficulty `0`, active Sack Head adjustment On,
helper `734`, native-matching Type `1`, Quality `3`, Tags `17825792`, and no
Equality!. The pool-rule preparation line records original ID 424 excluded at
game-start frame zero. The new-run choice and this preparation are distinct
from the earlier failed run.

All six explicit pool queries matched the historical placement: Shop returned
424; Secret, Greed Shop, Greed Secret, Treasure and Greed Treasure returned
fallback 25. With the room blacklist cleared between each query, the decreasing
Shop draw returned 424, a nondecreasing query still returned 424, the second
decreasing draw returned 424, and the final nondecreasing query returned 25.
This demonstrates the restored two-draw depletion threshold in the isolated
native pool; it is not a proportional-odds measurement.

Four native sacks without Sack Head produced nine ordinary rewards and zero
conversions. The grant then became exactly one real Sack Head with no helper
remaining (frame 185). With Sack Head held, five root sacks produced six
converted sacks, including three generation-2 descendants. Natural payout
lineages in the pre-spawn and sack-init records include:

- Root `672320741` produced coin `3903683730`, converted at frame 346. That
  native sack produced bomb `1205642145` and key `3286148864`, both converted
  at frame 370.
- Root `1610652331` produced coin `3664477730`, converted at frame 391. That
  native sack produced key `1275679401`, converted at frame 415.

Root sacks are generation 0, so these are two conversion generations, not
generation-3 records. The fixture observed real native openings and payouts;
it did not synthesize descendant reward lists. It completed with `pass` at
frame 455, reporting five owned-phase roots, six conversions, three further
generation conversions and 29 unconverted native outputs across both phases.
All six converted sacks resolved to normal subtype 1. Owned-phase input
rewards included coins, keys, bombs, a card and a battery; live troll bombs,
black-sack distribution, exact native conversion rates and co-op were not
established by this sample.

Stable capture:
`candidate-captures\capture-20261114T024241666Z-3da1af7b`:

- `log.txt`: 41,930 bytes, SHA-256
  `96981ddf44e621aab7d1dd9d9dbe67638fd281c82ab06531d1f6acd20c22e4ed`.
- `sack-records.jsonl`: 110 records, 17,178 bytes, zero malformed, SHA-256
  `6e6f8401c19d0dfffb7ab249c09a80c4cc79c67d6f3348663dae4420208b4bb7`.
- The source length, mtime and hash were unchanged during collection. An
  independent audit of the preserved bytes found ten repick-exhaustion warnings
  at lines 438–456 and no matching `[ASSERT]`, `[ERROR]`, Lua error, traceback,
  exception or failed lines. The warnings belong to the isolated negative pool
  queries and are retained. The audit found the Sack Head preparation at line
  430; it did not find an engine/MCM version or successful shutdown line in
  these bytes. Build identification above comes from earlier captures of the
  same deployed executable, not an invented line in this log.

The collector's initial process check used the wrong executable name and
reported absence. A follow-up using exact name `isaac-ng` found PID `32504`;
that earlier absence report is invalid. No restoration was attempted on that
basis. The owner subsequently selected Sack Head Off in MCM for the next run;
the already active On run is not treated as the Off control.

### Normal-Off control — pass

The owner confirmed the MCM next-run choice showed Off, returned to the menu,
and reported a fresh Normal Isaac run on slot 1. The same corrected observer
ran once. Its start record independently reports active `enabled=false`, seed
`616304311`, difficulty `0`, no Equality!, helper `734`, and matching native
metadata at frame 42. Preparation at game-start frame zero excludes helper
734 rather than real ID 424.

Shop, Secret and Greed Secret returned real Sack Head. Greed Shop, Treasure
and Greed Treasure returned fallback 25. The decreasing Shop draw returned
424 and both subsequent nondecreasing queries returned 25, preserving the
vanilla one-draw depletion threshold in this isolated control.

Four sacks without Sack Head produced nine ordinary rewards and no conversions.
The direct native grant then yielded one real Sack Head with zero helpers at
frame 623. Another four sacks with Sack Head held produced the same nine
ordinary reward identities and no conversions. All eight sacks were native
normal sacks, generation 0. The run completed with `pass` at frame 800,
`enabled=false`, four owned-phase roots, zero converted sacks, zero further
generations and 18 ordinary outputs across both phases. This confirms the
adjustment does not restore chain behavior when disabled, including with the
real item held; exact vanilla spawn rates outside these sacks were not sampled.

Stable capture:
`candidate-captures\capture-20261114T040839061Z-f8bc96eb`:

- `log.txt`: 68,462 bytes, SHA-256
  `09e5c158909e5b7017e0fe794245bf0a72b016b14dde3f069bdbe70a1ab25fa6`.
- `sack-records.jsonl`: 177 records, zero malformed, SHA-256
  `29c8d0b8cdec201801111db96ca18908a32a5d50b033b6b486d51ba1f759fdbc`.
  These include the previous 110 On records followed by the 67 Off records;
  earlier completion records are not a substitute for the latest Off result.
- Before/after source hash, length and mtime matched. Collector and installed
  observer hashes and the runtime manifest pin matched the versions above.
- A hash-guarded raw read confirmed all 67 latest records. Native diagnostics
  include nine new repick-exhaustion warnings at lines 928–944 (19 including
  the prior On run), with no matching assertion, error, Lua error, traceback,
  exception or failure. The copy identifies J460 / Repentance+ 1.9.7.17.J460
  and MCM v113; Off preparation is at line 920. Isaac remained running.

Evidence collection initially stopped at an incorrect manifest path, before
capturing anything; the corrected path used the existing session manifest.
The subsequent deep PowerShell formatting command lost its output handle.
Its identified diagnostic PID 22852 was later confirmed absent. A cleanup
filter matched its own shell and stopped that diagnostic command; a Python
inline reader then failed on PowerShell argument quoting. The final simple
hash-guarded file read succeeded. None of these diagnostic failures repeated
gameplay or changed the game, settings, build or captured files. The failed
diagnostics are not native feature failures or successful cleanup receipts.

### Actual Greed-mode pools — pass, diagnostic retained

The owner confirmed the next-run MCM choice was On, then started a fresh Greed
Isaac run on slot 1 and ran `lua OUPSackCheck.Pools()` once. The observer reports
seed `3260128097`, difficulty `2`, active `enabled=true`, matching item metadata
and no Equality! at frame 152. Preparation excluded real ID 424 at game-start
frame zero. All six explicit availability results matched the Normal-On run:
Shop 424; Secret, Greed Shop, Greed Secret, Treasure and Greed Treasure 25.
The four controlled Shop draws were 424, 424, 424, 25, with the room blacklist
cleared between queries. The check completed with `pass` in the same frame,
explicitly scoped to isolated native pools. No sacks or helper grants were
tested in this Greed run, and no separate Greedier run was performed.

Stable capture:
`candidate-captures\capture-20261114T041946526Z-8009fe21`:

- `log.txt`: 83,443 bytes, SHA-256
  `3ad3850454b97e76ecfd720a99434101b5a66a3df067cbb7b8f2fa3dc9253f3d`.
- `sack-records.jsonl`: 190 records, zero malformed, SHA-256
  `d33d303b2d6a6de11aeee47f6b850b6dc9ed37bf15ed8cbf22388e0202cb9c48`.
  The final 13 records belong to Greed; preceding records are the earlier
  Normal On and Off cases. Before/after log hash, length and mtime matched.
- Collector/observer hashes and the runtime manifest pin matched. The process
  check found `isaac-ng` PID 32504 still running, not a closed-game state.

The first diagnostic extraction accidentally used the live log. A subsequent
hash-guarded audit of the actual saved copy confirmed 28 repick warnings total
(nine new warnings), no matching error/Lua error/traceback/exception/failure,
and one native `[ASSERT] - EL: invalid sublist` at line 1034. The assertion
occurs after the prior Off result and before the new Greed preparation at line
1354; its surrounding lines report ANM2/cache and entity loading times. Its
cause is unknown. It is retained as a native diagnostic, not silently treated
as a clean log or attributed to the new feature without evidence. The latest
13 fixture assertions passed; this does not explain the separate engine
assertion or prove all other game behavior.

| Check | Current result |
| --- | --- |
| Historical complete normal/Greed pool XML comparison | Pass: source files above |
| Native restored availability | Pass for the six explicit pools in Normal-On and an actual Greed run |
| Native depletion | Pass in corrected Normal-On run; original verifier failure retained above |
| Ordinary 10%/20% conversion boundaries | Local contract pass; natural native conversions observed, exact native rates unmeasured |
| Natural sack rewards convert with Sack Head alone | Pass in Normal-On run, no Equality! |
| Converted sacks produce another converted generation | Pass: three generation-2 descendants |
| Without Sack Head and adjustment Off | Pass: without-item and real-item-held Off controls, zero conversions |
| Type/source exclusions and repeated processing | Local contract pass; exhaustive native combinations unmeasured |
| Real helper ownership conversion | Pass: one real Sack Head, zero helper copies |
| Final original setup restored | Pass: exact original profile/data/mods verified, test mods archived, game closed |

The fixture isolates collectible pools only for availability/depletion. Native
repick/fallback output in that case is not proportional-weight evidence. Pool
checks precede actual grants, since ownership removes the helper identity.
Natural reward generations are observed from real sack collisions; fixture
positioning and cleanup do not replace native sack payout generation. A bounded
sample with no further generation is inconclusive, not evidence of impossibility.

## Restoration and owner handoff — pass

After the owner confirmed Isaac was closed, the verified restoration command ran
once and exited 0. Both driver hashes matched before execution:

- `build_session.py`:
  `8c27e0ea7331de7a8c8ce0f11cd910ab4f905781f184218a8c2b155f9fdf055c`.
- `stage_probe.py`:
  `32fe245cd6ab1c25e005f1ddf26dd52d0e30634b4939d1d86030643c6f518b10`.

The driver checked the original pack archive and all owned candidate files,
including the corrected observer overlay and bounded metadata normalization.
It moved the candidate pack and validation mod into `captured-build/pack` and
`captured-build/observer`, returned the untouched original pack to its installed
path, and moved the source probe to `captured/probe-mod`. It restored the 189
original user-data files and the original game mod-data tree from their verified
backups, comparing complete file hashes and directory sets against `before.json`.
The original executable and all four original mod trees matched the snapshot.

The session's `restored.json` records `restored-original-setup-verified`,
`original_mods_unchanged=true` and `probe_active=false`. Runtime test data was
preserved by same-volume moves, not discarded:

- `C:\Users\Mario\Documents\My Games\Binding of Isaac Repentance+.oup-issue20-source-20261114T003441Z-runtime`
- `D:\The.Binding.of.Isaac.Repentance.v4.0.2\data.oup-issue20-source-20261114T003441Z-runtime`

A separate read-only inventory confirmed exactly the original four mod
directories, no active source/validation probe, the pinned executable hash,
all 189 backup-user files, the expected backup-data directory, both runtime
archives and the original metadata/capture paths. Archived source-probe,
validation-observer and Sack Head runtime Lua hashes matched their recorded
pins. Isaac and the old audit PID 22852 were absent; the scoped search for the
lost diagnostic and its wait under their recorded parent found zero matches.
The inventory first stopped on a mistakenly constructed `originalbackup-user`
path; the correct existing `backup-user` path was then checked without any
restoration rerun or game-file changes.

Backups and native evidence remain in the session directory. Ordinary play uses
the pre-test setup, not the candidate. The owner may resume control of the game;
this thread holds no continuing disposable-session lock. The restoration receipt
certifies game setup only; GitHub integration is tracked through issue #20.
Release publication is separate.

## Local checks

Passed: `lua tests/config_spec.lua` (21 cases),
`lua tests/pool_rules_spec.lua`, `python3 tests/pool_assets_spec.py`,
`lua tests/sack_head_spec.lua`, and the On/Off simulated fixture protocol checks
in `tests/sack_head_probe_spec.lua`. These do not substitute for engine checks.
The private deployment driver's filesystem smoke verified install, overwrite
guards, metadata normalization, rejection of changed Lua, restoration of the
original profile/data/mod hashes, and preservation of test-run evidence.
