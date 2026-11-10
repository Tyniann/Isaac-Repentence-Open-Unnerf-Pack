# Magic Mushroom: validation ledger

Issue [#4](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/4)
remains open. A helper-backed implementation has native weight and controlled
availability passes below; full acceptance and release remain pending. The required change is one normal Boss entry and an update to the
existing normal Treasure entry for collectible 12, both at Weight 1,
DecreaseBy 1 and RemoveOn 0.1. Other entries/pools/effects stay intact. The
independent persistent toggle is required now that configuration issue #3 has
landed, including its next-new-run and Continue semantics.

Current evidence: native intact-pool Treasure rates pass On/Off, Boss and
Treasure availability/depletion pass, all five helper pools survive an anchored
full-process Continue, and the saved On snapshot stays independent of next-run
Off. Actual grants convert one and two owned helper copies correctly while a
forced helper wisp remains a modifier. The forced-wisp fixture's cleanup fails;
that failure is preserved separately below. Both final review axes and local
checks pass; the diagnostic run is discarded and the observer archived with
protected files unchanged. Early starting-item generation and
separate Greed/Ultra Secret exhaustion recipes have not been engine-tested.

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

### Boss availability/depletion and Continue

The fresh Normal Isaac Boss check (`MM_ON_BOSS`, frame 23, seed
`2299138499`) **passes controlled availability and depletion**. The diagnostic
removed every other collectible identity from this disposable run. The early
native trace selected helper 733 from Boss pool 2 with `decrease=true`; the
production callback returned collectible 12. The next nondecreasing query
returned explicit fallback 668. The result records `expected=1`,
`outputs=[12]`, `after=668`, `pass=true`. No Lua error or assertion was found.
This proves one effective Boss draw in this controlled case, not relative
weight, actual player inventory grants or preservation of the removed items.

The stable five-record capture is
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T125109083Z-60c6453d`:

| File | SHA256 |
| --- | --- |
| `log.txt` | `f2f2d8b0133e0570aaef5ac70d024ef2f617c5aab93bfa4624a724c2ed41fa26` |
| `pool-records.jsonl` | `1d359372c0c2dbf2bb60efafa876d53bf45aa69f8d873d997fa1d928b6ed15c2` |
| `capture.json` | `f3bf8130da79f2a9183058154bdb6fba96dcf90fb59fa9d150235af110ee6de5` |

The owner then changed only Magic Mushroom pools to Off in MCM and continued
the depleted run. `MM_ON_BOSS_RELOAD` records `continued=true`, seed
`2299138499`, frame 436, enabled true, selected `magicMushroom=false` and
run-snapshot `magicMushroom=true`; all seven other choices remain On, MCM 113.
Boss pool 2 returned fallback 668 again, with `continue_result.pass=true`.
The run-start rule trace excluded original 12 with `removed=false`, consistent
with its prior exclusion; no helper entry was appended or reset by production.
This **passes Continue depletion and next-run/active-run separation**.

Stable evidence is
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T125636359Z-8cf66c4a`,
log SHA256
`dabb499c0d97bad69ffce647fe5f17524bd1ec465977605f0d8f1a29ca9ffd18`,
three-record SHA256
`09acb8a64bb2b1ec7faf3e9d520166f3aed6039138c68756092555cd18a6c18e`.
There are no malformed records or Lua errors. The owner reported exiting to
desktop and relaunching, but the continued game-start event retains diagnostic
label `MM_ON_BOSS`. The subsequently observed process (PID 31116) was created
at `2026-11-10T12:00:41.1448310Z`, before the pre-exit Boss capture at 12:51.
That process did not restart for this Continue test. Full application restart
remains **PENDING**; do not treat the label `RELOAD` as proof of a fresh Lua VM.

The pre-exit job searched standard Steam paths and did not verify the actual
installation. The subsequent job corrected that inspection to the explicit
game root: executable SHA matches, and 41/42 runtime files match, with only the
previously documented observer metadata difference. All Lua/content bytes match.

### Same-content On/Off preservation: pass

The fresh Off profile (`MM_OFF_PROFILE`, seed `2299138499`, continued false)
records both selected and run-snapshot Magic Mushroom settings false. The
other seven choices remain true, MCM 113, helper 733 and matching metadata.
The stable 64-record capture contains both 31-pool phases, one successful
completion and zero malformed records or Lua errors:
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T132149704Z-a9d9b788`.
Log SHA256 is
`064b638bbddbc30b618ad2b7ecc7b86ae15f6af80f42ab07e81043741e4acc4b`.

With content/instrumentation unchanged, the pinned comparer reports
`pass=true`, `phase=without_magic`, `pools=31`, `queries=1984`; child exit code
0, empty stderr. Exact command and output are preserved in that capture's
`same-content-comparison.json`. Full-phase On/Off samples differ only in
Treasure (3/64), Greed Treasure (1/64) and `POOL_24` (3/64); all other pools
match. A lack of sampled Magic Mushroom picks is not treated as absence.

This **passes the controlled native target-excluded preservation comparison**
and verifies the new-run gate becomes Off independently. It does not resolve
the failed comparison against the earlier installed content, whose initial
state/shuffle difference remains unexplained. Partial source XML and the
vanilla archive remain separate evidence of which definitions change; finite
profiles do not enumerate every weight. Relative weight, Treasure/Greed/Ultra
Secret depletion, actual grants and full process restart remain outstanding.

### Retired isolated Treasure weight experiment

The current archive recheck validates all three Repentance XML checksums. Both
collectibles 4 and 169 have Treasure Weight 1 / DecreaseBy 1 / RemoveOn 0.1
and quality 4. The fixture uses Cricket's Head (4), a passive without a hidden
attribute; Polyphemus (169) has a separate `special=true` attribute and is not
needed. The three-line parser change only adds the metadata filename and
changes the ID filters. Result SHA256:
`e7dc389d3947246ad4d0ad15d6011c64bb6662f8ee17737781c8cc7ada9e2d6f`.

The retired `tools/validation/treasure-weight-probe.lua` left only that Weight-1 reference
and the active Magic Mushroom identity. It made 4,096 nondecreasing queries
with fixed seeds paired across both halves of the 32-bit domain. Its bounded rate assertion expected 1:1 On
or 0.5:1 Off, with a three-percentage-point window. An early callback counts
native identities before translation, rejecting unexpected identities. It
then removes the reference and expects exactly one Magic Mushroom draw followed
by fallback 668. This deliberately empties other disposable-run entries.

The proposed rate check did not expose native entry
descriptors or prove arbitrary floating-point values by itself. Exact values
remain source evidence. Local safety
contracts pass for On/Off, metadata rejection before mutation and callback
cleanup after query failure; Lua syntax passes. Focused review found zero
findings. The experiments below failed; no native weight pass is claimed. The fixture staged outside the
game directory and neither installs content nor starts a run. The owner opted
to keep manual fresh runs, so no restart automation is added.

The first native Off weight run **fails** the original lower-half-only fixture.
Its stable capture is
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T135036474Z-48fb10a0`:
log SHA256 `d8d39e790ac34772bb05dfa082747af8a68cd2377f7bc388a4d70bd15da88a7f`,
record SHA256 `1c342cc7b28db6d09b893ad0ec7a5ae7c66c638670be1c0544605d60f5a62f55`,
capture SHA256 `36264f85e710d5cabed24eed34396a13fb7d0f0991a04e9f767634ad5cd4854e`.
It is an observed fresh Normal run: a frame-zero game-start event follows the
previous Off Boss result, then the weight state appears at frame 46. No run
reuse is inferred. Native and returned counts agree: 2,781 Magic Mushroom / 1,315
Cricket's Head, no unexpected identities, rate 0.678955078125 versus expected
one third. The assertion stops before removing the reference or consuming
either remaining identity. The diagnostic callback is removed on this path.

The original test covered only the lower half of the 32-bit seed domain. The
corrected fixture pairs 2,048 lower-half seeds with upper-half counterparts and
records each half's counts separately. Expectation, sample count and tolerance
are unchanged. Local coverage now rejects incomplete seed-domain sampling and
verifies that a rate failure stops before depletion. Whether seed-domain bias
explains the native failure is **unverified** until the next native check. No
production code was changed. The immediate bounded diagnostic may reuse the
already isolated two-entry state because the failed check consumed neither;
ordinary subsequent pool checks still require fresh runs. A new label suffix
`_U32` separates the next records from the original failed evidence.

The expanded-domain diagnostic also **fails**: 2,815 target / 1,281 reference,
rate 0.687255859375. Lower-half counts are 1,414 / 634 and upper-half counts
1,401 / 647. Both halves show the discrepancy; broadening the seed domain did
not resolve it. Evidence is preserved at
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T140706260Z-33d21f27`:
log SHA256 `775f932d8ac969d5363c944f7bc89d8c0cf5cd71f511b67d2572a11e4f9c5a85`,
record SHA256 `2421f9f970e9fa6bf655b3718af041d2f73d82b66cefbab20ac5644239c88095`,
capture SHA256 `068156501a2319e2ce876e8da0525390cbc62bec15e57cb18bf44935349fca63`.

The native log explains why this experiment cannot establish relative weight:
between state and sample records, **3,946 of 4,096 queries** emit
`[INFO] - [warn] item pool ran out of repicks`. The artificially restricted pool
drives native fallback behavior; ordinary proportional odds cannot be assumed
for that state. These failed assertions are **inconclusive about production
weighting**, not successful weight checks or confirmed production defects.
The isolated rate fixture and its synthetic spec are retired from the current
tree; pinned source and staged failed files remain preserved. One-identity
availability/depletion tests remain distinct from relative-weight claims.

### Intact-pool weight profiler: native pilot pending

`tools/validation/pool-weight-profile.lua` replaces the isolated rate experiment.
It never removes/decreases entries, changes metadata, grants items or starts a
run. Its initial 8,192-query pilot records all returned-item counts plus native
target/reference counts. It rejects restricted states (fewer than 32 distinct
other items or fewer than 90% other-item draws), and removes its diagnostic
callback after both success and error. Native repick warnings must be inspected
from the captured pilot before broader execution. A pilot is not a weight pass.

After that smallest native case is verified, the bounded full profile can use
262,144 fixed-seed nondecreasing queries against the intact Treasure pool.
It requires at least 256 target-plus-reference observations and compares their
conditional target share against one third Off or one half On with a predefined
four-standard-deviation diagnostic bound. This is finite consistency evidence,
not raw descriptor enumeration or a proof of exact floating-point values.
The XML records remain the exact-value evidence. No depleted isolated state can
be reused for this experiment; a fresh run is required to restore the pool.

Local contracts cover On/Off profiles, seed-domain coverage, refusal to mutate
pools, callback cleanup, metadata rejection, restricted-pool rejection, and a
biased full-profile failure. Standards review found zero issues; spec review
found that the full call could bypass a usable pilot. The corrected API
requires a successful matching pilot and an explicit `ReviewPilot` attestation
after its archived native warnings have been checked. A reviewed pilot permits
one bounded full attempt. Tests confirm failed, unreviewed and already-consumed
pilot review states block further queries. Those pass with synthetic counts; native pilot
and weighting acceptance remain **PENDING**. Production remains at source
`0bbc5d5`; these corrections affect validation tooling only.

### Off Boss and intact-pool weight control: pass

`MM_OFF_BOSS` passes direct native absence: expected zero, outputs empty,
native Boss pool 2 returns fallback 668. The observed fresh Normal run has
Magic Mushroom Off in both choices and snapshot, with the other seven On.
Stable capture:
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T134026354Z-3c6af083`,
log SHA256 `cf83b76b78b60ddf871c9697de7937ad52e1ad734cbb248ed315f70b1043e449`,
record SHA256 `889bac320ff7fb70108d0ad35af877f0697a3633a6e6d88ce7167e97072d0fcd`.

The intact-pool Off pilot is usable: 8,192 queries, 12 target / 32 reference /
8,148 others, 263 distinct other items, zero unexpected identities/fallbacks
or Lua errors, one native repick warning and elapsed 49 ms. Stable capture:
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T154427317Z-10cfbe9d`,
log SHA256 `5d1b2336a514153e30958e51cf3eb858198d12d78d095c86774122998bd07e06`,
record SHA256 `13e7acfe0719ca15d7fdf5db3418fadf76b5b255e93033ed919dff380430ee1b`.
The first capture setup stopped on an expected-hash typo missing its initial
character; correcting that setup reused the existing log without replaying
gameplay. The verified collector is now reusable at
`D:\T3ValidationArchives\issue4-shared-tools-5dc2f625\collect-pool-profile.ps1`.

After main-agent native-warning review, `MM_OFF_FULL_WEIGHT` **passes the
bounded relative-weight consistency check** on that same untouched pool:
262,144 queries, 533 target / 1,061 reference / 260,550 others. Focal count
1,594, observed target share 0.33437892095358 versus expected one third,
z-score 0.088554543371981 (bound 4). Native counts agree with returned IDs;
unexpected identities and fallback counts are zero. There are 263 distinct
other items, seven repick warnings, no Lua errors, elapsed 1,663 ms. The
preceding `weight_pilot_reviewed` event is present. Settings remain Off with
the other seven On, seed `2299138499`, observed fresh, MCM 113 and matching
helper/real metadata.

Stable full capture:
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T154839650Z-6716070e`,
log SHA256 `792e251eba7e72543a296372eac040ee31312f72850872b58897260dc3b74c37`,
record SHA256 `3386b3baf36322f588fcb1d9df6594448ea9249ec58563747bcf5f741cec1cff`.
This validates the native Off control against the archive's 0.5-to-1 values;
it does not yet validate the enabled helper's 1-to-1 behavior. Treasure
depletion, enabled weighting, Greed/Ultra Secret checks, actual grants and full
process restart remain pending. Queries did not decrease weights, so the
same Off run can now be used for its separate depletion check.

The separate `MM_OFF_TREASURE` depletion check also **passes** in that same
nondecreasing-profile run: isolation keeps real identity 12, then native pool
0 selects 12 with decrease true and 668 with decrease false. The result is
`expected=1`, `outputs=[12]`, `after=668`, `pass=true`; no Lua errors. This is
availability/depletion evidence, separate from the intact-pool rate control.
Stable capture:
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T155421986Z-d2b4e73e`,
log SHA256 `af01f9ec5416d7a02d9bfb8310387cc44917f7a9f430a9405fcccfc0d5ebbcf0`,
record SHA256 `b10483c1a99c133199f6dbe49f5e069b787eabf7799a303512d36bcf65fc62f8`.

### Enabled weight and Treasure depletion: pass

The On pilot was invoked twice without decreasing weights. Both completed at
frame 196 with the same 8,192 fixed-seed samples: 21 translated target / 32
reference / 8,139 other, native target **21** from helper 733, 263 distinct
other items, no unexpected identities/fallbacks/Lua errors, one repick warning
each; elapsed 58 and 55 ms. These are repeated samples, not independent extra
observations. The latest pilot was reviewed before the full call. A capture
summary incorrectly required fingerprint completion records and misread the
native counter as 28; direct raw-record inspection corrected both statements.
The profiler's `weight_profile` is its result record. Stable pilot capture:
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T161953201Z-9bbe74b5`,
log SHA256 `a12e8431c224b79f14231d2d33d2c1cf411952a59e3bddc59ad8153d0086f586`,
record SHA256 `39e53de44a35f333e12bafbf261c7b9186b7e4057c60085a34d987d31aff173f`.

`MM_ON_FULL_WEIGHT` **passes**: 262,144 queries, 992 target / 1,058 reference /
260,094 others, focal 2,050; expected share 0.5, observed 0.48390243902439,
z-score -1.457696144188 within bound 4. Native helper counter 992 matches all
992 returned item-12 results; unexpected identities and fallback counts are
zero. There are 263 distinct others, four native warnings and no Lua errors;
elapsed 1,750 ms. The pilot-review event is present. All eight active/saved
settings are On, matching metadata and seed `2299138499`, observed fresh.
This corroborates helper Weight 1 against the Weight-1 reference, alongside
the exact XML values. It does not enumerate raw native entry descriptors.
Stable capture:
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T163619216Z-5e853944`,
log SHA256 `dfd0e5c1f6bdd21847b7605003f89c3da9d8750b453c65ad9346f4489ee8f983`,
record SHA256 `ec6974a6b9b28c5282fe7f1310d4146af6d799a3efdc7e6327313d0c21e8a786`.

The same run's `MM_ON_TREASURE` **passes one-item availability/depletion**:
isolation keeps 733; raw 733 with decrease true returns 12, followed by raw
and returned fallback 668 with decrease false. Result expected 1, outputs
`[12]`, after 668, pass true. Stable five-record capture:
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T165514048Z-555eb5f4`,
log SHA256 `8868facded155aa82863578f8edb19f8ba3dd35ea161fa3be8399502031805d6`,
record SHA256 `0684d7a5d6f1e59fa888fa1d97524b44246f82c825748390be6cbde96ab65665`.
No actual Magic Mushroom was granted during these pool checks.

### Full process boundary verified; reload assertion failed

After changing only the next-run Magic Mushroom choice to Off and saving,
the owner fully closed Isaac. Read-only process verification at
`2026-11-10T17:35:41.1022259Z` found no Isaac process, with old PID 31116 gone
and the executable hash unchanged. Proof:
`C:\Users\Mario\.t3\scratch\2026-11-10-act-as-the-test-sub-a4d07916\shutdown-proof.json`.

`tools/validation/pool-reload-check.lua` was run after Continue of this On snapshot. It
requires next-run Off, matching metadata and zero owned real/helper copies.
It re-excludes **only non-target IDs**, leaving both 12 and the helper
untouched. Thus it does not depend on serialization of the diagnostic's other
bulk exclusions, and cannot itself hide a reappearing original or reset a
helper weight. It expects spent Treasure to return 668, previously unspent
Boss to return 12 from raw helper once, then 668. The early callback captures
all three identities and is removed on pass/failure. Local contracts cover
reset-helper, reappearing-original, missing-Boss and ownership-confound failures;
syntax passes and focused review found zero findings. Native execution after
reopening the application failed its Boss assertion. **The premise that Boss
was unspent before saving was not measured. Do not rerun this historical
recipe or treat that assertion alone as a production failure.**

Stable capture:
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T181438156Z-4ff29c54`,
log SHA256 `33fa33c1e3de96f10a03fd6fe9ec3c677c8e1be132282f6ad63c1bcbdf1a1a48`,
records SHA256 `ddc3273c52064f3c55cb88c37186150eafb6bb9af70223ba82c71e9d174c5802`.
No malformed records. New PID 34156 was created at `2026-11-10T18:08:17Z`,
after the verified shutdown; old PID 31116 is absent. Executable hash still
matches, and 41/42 manifest files match with only the previously recorded
observer metadata-format difference.

State at frame 964 is observed Continue, active/snapshot On and next-run Off,
seed `2299138499`, MCM 113, helper 733 with matching metadata, zero actual
real/helper copies. Raw Treasure query (decrease false) returned 668;
raw Boss query (decrease true) also returned 668. The result is `pass=false`,
error `previously unspent Boss target unavailable`, with two native repick
warnings. It passed the spent-Treasure assertion but cannot distinguish loss
of an unspent entry from depletion before saving without a prior measurement.

The only rule trace in this boot is
`enabled=true metadata=true excluded=12 removed=false phase=game_started seed=2299138499 frame=709`.
There is no pre-generation trace or pre-start selection record in this log;
it provides no evidence that early Continue selected the wrong choice.
The configured On snapshot itself survived the full process boundary.

`tools/validation/pool-cross-depletion.lua` prepares the next bounded native
measurement: in a fresh On Normal Isaac run with zero owned copies, exclude
only non-target IDs, query all five target pools without depletion, draw once
from Treasure, then query those five again without depletion. Both target
identities remain untouched by exclusion. It records raw identities and both
vectors, without assuming Boss or the other pools remain available. Local
contracts exercise both per-pool and shared-depletion models, missing initial
availability, and callback cleanup; these are not native evidence. First engine
execution is recorded below. The XML/API references do not settle cross-pool mutation.

### Native cross-pool depletion measured

The fresh On run used numeric seed `2961248207`, frame 120, difficulty 0,
observed `continued=false`, all eight choices/run settings On, MCM 113 and
matching helper 733 metadata. The diagnostic exclusion loop leaves both target
identities untouched and the owned-item guard passes. All five initial
nondecreasing queries return 12 from raw helper 733. One Treasure draw with
decrease true returns 12 from 733. All five subsequent nondecreasing queries
return raw/translated fallback 668. **The test demonstrates loss of availability
across all five pools after that draw in this build.** Thus another pool cannot
be assumed unspent merely because the test drew from Treasure. The former
reload check's premise was invalid; production code is unchanged.

Stable capture (the collector's actual output location):
`D:\T3ValidationArchives\capture-20261110T184415636Z-a3f5338f`,
log SHA256 `376c0b78a0f02f77df5e4416f652810c05559e0e18bcb6eb956636689e98931b`,
records SHA256 `145300a7a55cdfaef888a7cb0b99cd7cd85e4a7cc9474c1430a4c6cd91cddf8b`.
Two selected records, zero malformed, 11 captured native calls. There are 11
native repick warnings and no Lua errors between state and result. Isolation
supports availability/depletion observations, not proportional weighting.
The preceding game-start trace is On, excludes 12, frame 0, matching seed.

### Replacement unspent-reload protocol: engine pending

The current `tools/validation/pool-reload-check.lua` replaces the failed
single-phase recipe retained at source `531d7effc3977e54fbf4e7c4644b644e2d64aca9`.
It pins seed **SVW0 6RZE** / `2299138499` and uses an explicit two-phase
protocol. On an observed fresh On Normal Isaac run, it excludes only non-target
IDs and records five nondecreasing successful helper selections without drawing
or decreasing the target (`MM_UNSPENT_PREPARE`, `reload_anchor`). Archive that
anchor before the owner changes only the next-run choice to Off and saves,
fully closes and reopens Isaac, then chooses Continue on the same slot/run.

Running the same file on Continue requires the matching seed, active/saved-run
On, next-run Off, zero actual owned copies and matching metadata. It again
excludes only non-target IDs, requires all five measured identities available,
draws once from Boss and then requires all five fallbacks. Its early callback
requires raw helper identities before depletion and fallback identities after,
then unregisters on success or failure (`MM_UNSPENT_RELOAD`, `reload_result`).
This is a positive availability control paired with the earlier spent-Treasure
cold observation. Do not infer this protocol passed from the old failed result.
Local contracts cover prepare without consumption, Continue, seed/choice/owned
guards, missing availability, native original leakage, duplicate availability
after depletion and callback cleanup; syntax passes and focused review reports
zero findings. Engine execution remains
pending.

The replacement **Prepare phase now passes natively**, with the target still
unspent. The staged source `046a77ec3a013f4782d0507f293c8145919f32e3` at
`D:\T3ValidationArchives\issue4-reload-046a77e\pool-reload-check.lua`
matches SHA256 `8ca03a8f9049a37f4a31e037173f614581dc8c796ee47e6e8566a3f26280f0a1`.
The owner reports `MM_RELOAD_READY 5 2299138499`; the stable capture contains
one state and one passing `reload_anchor`, zero malformed records, observed
fresh seed `2299138499`, zero owned real/helper copies and both target identities
untouched by the fixture's exclusions. Each of the five raw picks selects 733
with decrease false and returns 12. All eight choices are On, active Magic
Mushroom is On, MCM 113, and helper metadata matches. There are no native
warnings or Lua errors in the bounded check. The run-start rule trace is On,
excluding 12, frame 0, matching seed.

Anchor evidence:
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T192207235Z-fd0f094d`,
records SHA256 `e2b23b494663eb34984024c867f1f0bec02913a9c914d89108fa748b7f81fac8`.
The raw log is preserved alongside the records. Pre-shutdown process anchor
is PID 34156, creation `2026-11-10T18:08:17Z`, at the tested executable path.
At that capture the owner had not yet changed the next-run choice, saved or
exited for this new anchor. The completed cold Verify phase follows.

### Anchored full-process Continue passes

The owner changed only the next-run Magic Mushroom choice to Off, saved and
fully exited. At `2026-11-10T19:29:18.0122873Z`, read-only verification found
no Isaac process and old PID 34156 absent, with the executable SHA unchanged.
Proof: `C:\Users\Mario\.t3\scratch\2026-11-10-act-as-the-test-sub-ea8edbcb\shutdown-proof.json`,
SHA256 `6b2b4294b2614e32e43e2572a66b2df54154ea14759396ae0a1d7931d977c35d`.
Its additional archive check used a wrong filename filter; a subsequent direct
literal-path check confirms the anchor records hash above and log SHA256
`03b095628b6cc32b33928c0a80b014a46ceae97e831b142f463d55d41512240d`.
No anchor was altered or game test replayed for that collection error.

After reopening the same installation/slot and choosing Continue, the owner
reports `MM_UNSPENT_RELOAD_PASS 11 2299138499`. The stable two-record capture
confirms `pass=true`, frame 472, observed Continue, seed `2299138499`, zero
owned real/helper copies and untouched target identities. The five initial
queries again select raw helper 733 and return 12. One Boss draw selects 733
and returns 12, then all five queries return raw/translated fallback 668.
The original/helper identity does not yield an extra copy after that draw.
Snapshot/active Magic Mushroom remains On; next-run choice is Off; all seven
other active and selected settings stay On. MCM 113 and metadata match.

New process PID 32068 was created at `2026-11-10T19:34:33.9717510Z`, after
verified shutdown, at `D:\The.Binding.of.Isaac.Repentance.v4.0.2\isaac-ng.exe`.
Its SHA256 matches `e5faf6f513c6de9cc9ff1c335ef9c541e2b33fc623aa3b8ffbd2e6a6c0027bb0`.
Game start is observed Continue at frame 449; the rule trace excludes 12 with
active On (`removed=false`, already excluded), without adding/resetting rows.
There are no captured Lua errors. The first process-path lookup failed before
capture; a separate read-only collector preserved the log before broad lookup
successfully found the process. No replay or game mutation was needed.

Evidence:
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T193844414Z-928a5417`,
log SHA256 `313b1d6c72e65ee5a3b1ca3582c6d3d995859169adc78ab5350b057e45148f66`,
records SHA256 `f0ec51bc4f2f6545c6e93fd04d034761862f6e456fcda98fcd8d6e86784de044`,
zero malformed payloads. Main-agent inspection of the raw JSON corroborates
the eleven native picks. The capture's first manifest sidecar checked zero
files because its path handling stripped a prefix; this does not establish
drift and must not be reported as a successful deployment comparison.

### Actual-grant fixture prepared: engine pending

`tools/validation/pool-grant-probe.lua` starts with one explicit actual helper
grant in a disposable Normal Isaac run. The console must close to advance its
late player-effect observer; completion requires two stable frames with the
expected real-item count and zero actual helper copies. It records damage,
speed and health alongside true/full item counts. A subsequent two-copy case
requires an existing real copy and creates one tracked helper item-wisp. It
first checks that this is only a modifier, then verifies conversion counts
while retaining that modifier, removes only the fixture-created wisp, and
checks the owned copies remain. This forced-private-modifier case does not
claim to test natural Lemegeton selection.

Native count/wisp APIs are documented in the
[EntityPlayer reference](https://wofsauge.github.io/IsaacDocs/rep/EntityPlayer.html).
Callback timing and actual grants remain for the first native pilot. Local
scripted transitions are only driver safety evidence: they cover successful
one/two-copy protocols, modifier cleanup, distinct Lua wrappers for one actor,
and timeout cleanup. Review found that a wrong actor could bypass the deadline;
the deadline now precedes that return, with a failing-then-passing regression.
The driver leaves granted real items in the disposable run and does not undo
health gains or restore saves.

**Run these grants after depletion/reload checks.** Holding an actual Magic
Mushroom intentionally excludes the helper globally; a fallback while holding
it would not independently prove saved pool depletion persisted across restart.

### Native one-copy grant passes

In the same continued On run after the reload check, the owner ran the staged
source `0030a04273d3895bc14bed23ce8ab7b998cd0251` grant pilot (SHA256
`aedbbce67b1b97df6f85ae05af9ee599908b600727dfebaab03b12c908e0b307`).
`MM_GRANT_ONE` **passes**. At frame 472, before counts are real 0/helper 0,
damage 3.5, speed 1, max/current hearts 6/6. The explicit grant immediately
produces helper true/full 1/1 while real stays 0. At frame 474, after two stable
frames, real true/full is 1/1 and helper true/full 0/0. Damage is
6.1224994659424, speed 1.2999999523163, max/current hearts 8/8. The passing
result records copies 1, beforeReal 0, expectedReal 1, withModifier false.
These are actual native inventory/effect observations, not stub results.
The eight run settings stay On; only the next-run Magic Mushroom choice is Off.

Stable five-record capture:
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T202345926Z-e8e06ba2`,
log SHA256 `3fcf84e183d0e37f87e76edac8088925c3ea0af8b98b5b938b4c6c87384a14f4`,
records SHA256 `3c8a360f5d16ce4f162232a2052c0a80e721fd9d96651da6a9ba1294e150c2ca`,
zero malformed records. Main-agent inspection corroborates the raw sequence.
The two-copy/temporary-modifier follow-up is still pending.

The corrected literal-relative-path deployment check now verifies all 42
manifest entries: 41 match by SHA256 and length, including all runtime Lua and
content. Only the already documented observer metadata-format difference
remains. The earlier zero-file sidecar is retained as a failed verifier result.
Corrected evidence:
`D:\T3ValidationArchives\issue4-install-0bbc5d5-20261110T113633080Z\capture-corrected-deployment-20261110T202445211Z-54ecc26e\corrected-deployment-provenance.json`,
SHA256 `811c32d325a3453b8a97bb1bb41169b0b4f528fd14edff54cf77946c6c9a3f6e`.
The old artifacts and installation were not modified.

A corrected warning scan of the entire preserved cold-reload log finds one
startup SteamCloud/options warning and ten native repick warnings, with no Lua
errors. The earlier summary's zero-warning claim used a pattern that missed
literal `[warn]`. This correction does not relabel the availability results as
weight-rate evidence; rates were measured separately against intact pools.

### Two-copy conversion verified; forced-wisp cleanup fails

The owner then ran `MM_GRANT_MODIFIER` in the same run. The native sequence
distinguishes production conversion from the fixture's cleanup:

- Frame 550: real true/full 1/1, helper true/full 0/0.
- Frame 551 modifier control: real stays 1/1, helper true/full is 0/1, wisp
  subtype 733. The temporary helper does not become a permanent item.
- Frame 551 after two explicit actual helper grants: real stays 1/1, helper
  true/full is 2/3.
- Frame 553 after two stable conversion frames: real true/full 3/3, helper
  true/full 0/1. The two actual helpers converted once each while retaining
  the modifier. Damage 7.5716571807861, speed 1.9000000953674, hearts 14/14.
- The fixture called `wisp:Remove()`, then waited for full helper count zero.
  It stayed 1 until frame 671. The original `grant_result` is **pass=false**,
  error `grant fixture timed out; preserve evidence`, real 3/helper true 0/
  helper full 1. No Lua error or native warning occurs within this case.

Thus the recorded production conversion assertions pass, but the original
overall fixture does not. Do not relabel it a clean pass. This forced-private-
wisp check does not claim natural Lemegeton selection coverage.

Stable six-record capture:
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T212538418Z-a9989052`,
log SHA256 `22d04cc2ed5ec0360962a7aa9bd463da3be4bf1f707920b64949574eb1bb8f90`,
records SHA256 `35b458d2f8a279b25702528095ff13524a4bbc9efa610d74fd848b356249d063`.
The one-call targeted native helper removal also fails to clear that virtual
count: `MM_MODIFIER_CLEANUP` records real 3/helper full 1, without granting
anything. Its stable one-record capture is
`D:\T3ValidationArchives\issue4-evidence\capture-20261110T213902903Z-71336fc7`,
log SHA256 `e092dad76e8e1ec43d7fbd65f0d65e2132e0ff83fa4911af42abc2853703eef6`,
records SHA256 `cea2638fa8c1f8d453a2e1850df45ffb98ff300bb0e048a18e804885f2a4d56a`.
Both captures have zero malformed records. No further guessed cleanup calls or
grant replay is requested. The disposable run must be discarded before play.

The driver now records `conversionVerified`, `cleanupComplete` and
`discardRunRequired` separately. It stops after verified conversion instead of
waiting 120 frames for an entity removal to clear virtual inventory. A retained
modifier still makes overall `pass=false`; Status explicitly reports
`MM_CONVERSION_PASS_DISCARD_RUN`. A local red/green contract retains the virtual
count after entity removal and verifies bounded callback removal plus honest
verdicts. This revised driver has local verification only; the historical
native failure above remains unchanged. Production pool/conversion code is
unchanged from the validated runtime.

The native [player removal API](https://wofsauge.github.io/IsaacDocs/rep/EntityPlayer.html#removecollectible)
defaults to removing the transformation contribution and documents modifier
handling; it does not promise this forced-wisp cleanup. The separately named
[TemporaryEffects API](https://wofsauge.github.io/IsaacDocs/rep/TemporaryEffects.html)
is not a general fake-inventory cleanup contract. No extension was added.

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

The numerical and preservation requirements remain unchanged. Exact helper
assets/metadata and deployment hashes combine with native rate, availability,
depletion and anchored cold-Continue evidence above. The same-content On/Off
31-pool comparison supports preservation; the older cross-build comparison
remains failed and unexplained, not a pass or a promise of unchanged seed
mapping after adding custom content. No source mutation touches unrelated
entries, and the three Greed/Ultra Secret helper definitions exactly mirror
the checksum-verified originals. Native checks observe those five identities
before/after depletion and Continue. Separate Greed/Ultra Secret exhaustion
recipes remain unexecuted; no per-pool independence is assumed after the
cross-pool measurement.

Final source/spec and standards reviews each report zero findings on
`95625cfa7394b30ec1e309b68ed2bde9d69e04a8`. The final local suite passes all
11 standalone specs (9 Lua, 2 Python), syntax on 37 tracked Lua files, and
`git diff --check`. Full local output is `/tmp/issue4-final-tests-95625cf.txt`.
These local checks are not engine evidence. After fetch, default `origin/master`
is still the starting `3be8e611c96cb6a48d0d5b8c64f38b06a4ea0829`; the scoped
diff is nonempty and the checkout remains owned by this issue.

Before final cleanup, at the read-only check around
`2026-11-10T21:50Z`, PID 32068 is still running and the log has no fresh start
or exit after `MM_MODIFIER_CLEANUP`. The owner has been asked to set Magic
Mushroom On, discard the disposable run through an ordinary new run, save/quit
and fully close Isaac before reversible observer removal. No further cleanup
commands are guessed and no mod directory is moved while it is running.
Feature-reference files remain with their
owner; supply the actual loader, eighth default-On key and final evidence for
that handoff. No early starting-item, co-op or every-item-reroll matrix is claimed
from the Normal Isaac checks. The owner explicitly requested a reasonable
manual-test budget; retain valid evidence and limit additional checks to a
specific unresolved acceptance condition.

## Final cleanup and reviewable-PR handoff

The owner restored Magic Mushroom On, started a fresh ordinary run to discard
the forced modifier, saved/quitted and fully closed Isaac. The preserved log
confirms a fresh `continued=false` start after the cleanup marker, active On,
then exit; no freshness conclusion depends on the retained diagnostic label.
At `2026-11-10T23:16:07Z`, no Isaac process remains and the executable hash is
unchanged. Prerequisite proof:
`C:\Users\Mario\.t3\scratch\2026-11-10-act-as-the-test-sub-a5ffc631\scratchlogcopy.proof.json`,
SHA256 `3e24ea5c74635495d97fda30476c6d1d086488ab66b7050e8236410cc8cfe92c`;
log SHA256 `df47be62e1957e1b7370ab1abf0f584e1443490ad78b410ab9870e3a0eaab204`.

The two-file observer is reversibly archived at
`D:\T3ValidationArchives\issue4-cleanup-20261110T232734137Z-e78f7f7c\open_unnerf_validation_observer`.
The installed source directory is absent, its archived hashes match, the
unrelated mod-directory listing is unchanged, and Isaac remains closed. All
before/after protected inventory strings and parsed path/size/SHA256 maps match:
pack **18**, MCM **22**, game data **5**, user data **183** files (**228 total**).
No save was deleted/restored and no engine launched after removal. Original
deployment backups remain intact.

The executed archive script is pinned at `fd893f85ff0e2ed7ecbc5bbd1f8238017cc00635`,
SHA256 `88b5084ec7e36a17e99f0043cebc721616e20ae0b9b32c73b6ce599d544e1c10`;
native PowerShell parser errors zero. Its result's four file counts were
incorrectly reported as 1 because of array handling; the protection comparison
itself covered the full inventories. Offline parsing confirms the actual counts
above in a new `inventory-counts.json`, retaining the original result. The
maintained script fixes reporting only and was not rerun against an absent
observer. Earlier aborted guards/invalid command encoding moved no files; the
pinned raw-file recipe avoids those transfer errors.

Cleanup session proof hashes:

- `before.json`: `6a517298e7637667737034e2a9f0691b761df2775b11edac5dc26cb78659469a`.
- `after.json`: `61e8bc3184a2f3a09d0ff2e743cc31a4fd2867763c03cac30aac577b08127dbb`.
- `result.json`: `61ee7807e9ee34f988c13066d4ab7d62c326ff402af2c778c313840e9ad26a73`.

The tested pack and optional MCM remain installed. Both final review axes report
zero findings; all local checks above pass. The additional
[technical contract](../agents/pool-rules.md) has a clear focused source review,
and its/shared-guide **25 local links** pass. The feature-documentation owner
received exact behavior, key/default, evidence limits and technical pointers;
their reviewed player draft and deferred PR #15 integration checklist are
prepared without advertising unmerged work.

Implementation, validation and diagnostic cleanup are complete for a reviewable
PR #14 handoff. The issue stays open pending merge; unexecuted supplementary
paths and all failed experiments remain explicitly recorded. No release or
merge of the separate PR #15 is claimed.

Use the [shared validation guide](../agents/game-validation.md) for future
owner interaction and evidence collection. No production deployment, restart,
save/settings write or fixture restore was performed for this capability check.
