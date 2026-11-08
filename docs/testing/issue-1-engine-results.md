# Issue #1 engine validation ledger

## Current status

Runtime under test: integrated source f1c8325, MCM Pure v113 and the immutable
separate observer recorded below. This file is a chronological evidence ledger;
later actual settings/seeds supersede earlier requested or assumed setup.

- Fresh local Normal loading and relaunch/Continue are corroborated.
- Single-copy Maw damage/cache acquisition and removal are corroborated with
  independent Maw On/Off controls.
- Independent Sacrificial Dagger field processing is corroborated. Earlier
  doorway/BFFS/Continue field observations were made with Maw Off and retain
  that narrower context; they are not contact-DPS measurements.
- Full Maw ring/drop/player-isolation, orbital combat/variant coverage, other
  feature behavior and true pack-absent vanilla/stacking comparisons remain open.
- Current session owner is #3 after #1's second explicit return. #3 is preparing
  an independent Relic-Off batch. #1 sends no owner prompts or shared mutations
  until another explicit handoff. No claim of complete issue acceptance.

## Session ownership and provenance

Issue #3 owned initial deployment and the first MCM/persistence interaction.
Subsequent #1 Maw and orbital batches were owner-executed during explicit
handoffs, with read-only log collection. Each current owner has exclusive control
of prompts and shared state until an explicit return; no competing sequences.
The observer was deployed once by #3, unchanged, and shared across both issues.

Source prepared against integrated commit
`f1c83253af3636816c3b83c6ab28d2221ad345ea` (includes merged PRs #5/#6).
This is **not a deployment claim**. Test installation SHA, source file hashes,
observer hash, MCM version/revision, other enabled mods, settings and game build
must accompany each engine session. Running target previously confirmed as
Repentance+ 1.9.7.17 / executable string 1.9.7.17.J460.

### Coordinated package (deployment confirmed; engine checks pending)

Issue #3 reports successful deployment at 2026-11-08 15:22 UTC, after its
parent-owned Linux package verification and remote Luna's independent comparison
of all 38 installed file hashes with the manifest. This establishes installed
bytes, not a successful game load or gameplay result. The game was closed after
installation. The first owner MCM check has been requested; no result is recorded
yet and #3 retains session ownership through its first persistence batch.

- Pack source: `f1c83253af3636816c3b83c6ab28d2221ad345ea`.
- MCM Pure v113 source: `a4c15349c8ed8c38f31bf45bdf5d2896f4e9d23d`.
- Package: 38 files, SHA-256
  `971aacb895cae5f1c08107ab07b4e33820c68ed21a7407c2d3ddf99653d0a471`.
- Immutable observer SHA-256:
  `aea0ac0b0098c29aeb8c5bbe1a73447ee0fd721c085baa2dcd99cd539ec2a7db`.
- Intended mod directories: `open_unnerf_pack_validation`,
  `mod_config_menu_pure`, and `open_unnerf_validation_observer`.
- Observer is a separate `main.lua` mod, so `OUPProbe` should become available
  on normal game load without `luarun`; that availability still needs observation.
- Windows session root:
  `C:\Users\Mario\.t3\scratch\ounp-issue3-validation-f1c8325-20261108`.
- Installed manifest: `installed-manifest.json` under that session root.
- Backups: `backup\repentance-plus-user-data`, `backup\game-mod-data` and
  `before.json` under that session root. Original two mods retain their disabled
  markers. Installed MCM has the Version 113 declaration.
- #3 retains the interactive lock for its initial MCM/persistence batch.

## Observations collected so far

| Evidence | Conditions / result | What it establishes |
| --- | --- | --- |
| Read-only Windows snapshot, 2026-11-08 15:03:02 UTC | No game process. Two issue-2 test directories absent, but earlier log names both as loaded. Log also reports mod-state Continue mismatch for slots 2/3. | Deployment provenance unresolved at this instant; no load/Continue pass or product diagnosis. #3 is reconciling current state. |
| Integrated-source preparation | Clean checkout moved from old merge 83f0037 to f1c8325. | Recipes will retain configuration gates. No engine result. |
| Deployment report, 2026-11-08 15:22 UTC | #3 reports all 38 installed runtime file hashes match its manifest, exact observer unchanged; game closed afterward. | Installation provenance confirmed through #3's verified recipe/Luna report. No engine load or gameplay pass. |
| C1 fresh UI/load, log at 2026-11-08 15:25:15 UTC | Owner confirmed all seven controls On and new-run notice in pack Unnerfs. Matching `evidence/C1-initial-log.txt` loads pack, observer and MCM v113 with no Lua errors. Seed `AHF4 DXT0`, decimal `237297203`, logged `[New, 2]`. | Fresh local load/UI evidence on deployed f1c8325, shared from #3. No item-behavior or Continue result. |

C1 log SHA-256:
`6672ae5357afcd230f51b8f930fda1c2799d1cf5d4663d9cdd19dd56be64e8d7`.
Evidence path is under the coordinated Windows session root. #3 reports pack
data target `game/data/open unnerf pack/save2.dat`, 312 bytes; file existence/size
alone is not persistence verification. The prior mod-state Continue refusal
belongs to an earlier run and is not evidence about C1's Continue behavior.
### C1 initial observer engine snapshot (shared from #3)

#3's main Sol reports a successful first engine snapshot recovered from the log:
exactly one JSON snapshot, 914 bytes, with no subsequent probe/error lines.
This verifies the initial Snapshot API path for this fixture and state, not every
event callback or gameplay mechanic. Owner difficulty scrolling the long JSON
does not invalidate the recovered log record; use short console queries for
owner feedback and read-only log collection for complete records.

- `runStartObserved=true`, `continuedObserved=false`.
- Seed `237297203` / `AHF4 DXT0`, Normal difficulty `0`, Isaac player type `0`.
- Player damage `3.5`, zero Maw copies, six red half-hearts, no soul hearts and
  no familiars.
- MCM present, literal runtime Version `113`.
- All seven active gates true. Saved schema `1`, saved settings and run settings
  all true; saved run seed matches current seed.
- Evidence: `evidence/C1-observer-start.jsonl` under the Windows session root.
- Associated log SHA-256:
  `ed5ffc72353620f90a0bd5019ddb4055287e982aae31ea1b9ea018f47946282f`.
- `save2.dat` SHA-256:
  `c994073bfb9002db42ecaf836667160a68fc181f2619610049853a09afbcc2b1`.

This is a valid pre-item baseline for #1, not a Maw behavior pass. #3 next asked
the owner to change only next-run Maw choice to Off and query that current-run
active gate remains true. No result for that change, Continue or relaunch is
recorded here yet. #3 retains the session lock and has granted no items.

### C2 deferred choice and pre-relaunch persistence

#3 reports the owner confirmed the current-run Maw query remains true after
changing only the menu's next-run Maw choice to Off. With the game then closed,
slot 2 saved schema `1` contains next-run Maw `false` and run-snapshot Maw `true`
at seed `237297203`; all other six settings remain true in both tables. No
source/deployment changes or subsequent Lua errors were reported.

- `C2-pack-save2.dat`: 313 bytes, SHA-256
  `750958afa7e06901adf8faba6c005f7cb08600a7e70aaffd6821dc7d746fbea5`.
- `C2-before-relaunch-log.txt`: 30142 bytes, SHA-256
  `ccf38bb33afb328eb77f97bb3ab4823b696060a7238c0c5adc1dfad91c5aba85`.

These files are under the coordinated session's evidence directory. This is
deferred-choice and saved-data evidence, not successful restoration after
relaunch. #3 has requested slot-2 Continue as C3; result remains pending. It will
retain ownership through the fresh-Off boundary, then hand over with Maw Off
active so #1 can start the acquisition/removal control without another reset.

### C3 relaunch and Continue (owner observation; log capture pending)

After relaunch and slot-2 Continue, the owner confirmed menu Maw Off and the
short query `C3 true,true`: active Maw is true and the observer actually received
`continued=true`. This supports persistence and retained run settings after
relaunch. #3 will collect the matching same-process log, seed and error evidence
with C4; until then, #1 does not mark the full error-free Continue criterion
complete.

#3 has requested return to main menu followed by a NEW Normal Isaac run in
slot 2, retaining Maw Off and other six On. C4 should report active Maw false
and actually observed continued false. No items have been granted. Owner C4
confirmation, evidence capture and explicit session handoff remain pending.

### C4 corroboration and explicit session handoff to #1

#3 handed session ownership to #1 for a bounded Maw Off/On acquisition/removal
comparison. Owner confirmed C4 `false,false`: fresh Normal Isaac in slot 2,
seed `3112725348` / `03XT KGK9`, item-free, Maw Off active and next-run, other
six On in both. C4 saved schema 1/run seed matches. Same-process log corroborates
C3 seed `237297203 [Continue, 2]`, then C4 `3112725348 [New, 2]`, no Lua errors;
slot-3 mod-state refusal notices are unrelated to these successful transitions.

- `C4-continue-and-newrun-log.txt`: 27869 bytes, SHA-256
  `4240614951110764275bf25b0571d04a7fe948d42928a5388406b436970e886c`.
- `C4-pack-save2.dat`: 315 bytes, SHA-256
  `7739b8a81112f997bcdc673856198f7b95aba95d7102cfc469d589d43fc9890d`.
- `installed-manifest.json` SHA-256:
  `2610e74bda40aa237d00a066f9b722e3693a34c6e0daefe7fbda7d8489c1b475`.
- Process at handoff: PID 10212, launched 2026-11-08 15:35:26 UTC. Observer
  loaded inactive; actual latest start callback recorded continued false.

These matched shared observations satisfy the fresh/Continue error-free load
check for this local Normal configuration on f1c8325. They do not establish other
mode support or any item behavior. #1 may now prompt for this Maw batch; #3 will
not send competing prompts until #1 explicitly returns ownership. No pack/source
or mod changes are authorized by that handoff. Backups remain intact.

### M1 Off acquisition/removal (owner-observed and log-corroborated)

In a fresh Normal run with Maw active Off (actual recorded seed `1299135721`),
the owner ran `OUPProbe.Start('M1-off', full f1c8325 SHA, 'fresh')`, the short
baseline query, `giveitem c399`, then closed the console for one second and
queried/snapshotted again:

- `M1 BEFORE 3.5 0` (damage, Maw copies).
- `M1 AFTER 3.5 1`.

This matches the expected Off-control acquisition behavior in this state:
collecting Maw added no damage. It is not a Maw-On result, a ring/drop test, or
an uninstrumented pack-absent vanilla test. The observer should have captured
`start` and `M1-off-acquired`; log corroboration and removal are pending.

Owner then executed `remove Maw of the Void`, allowed one second outside the
console, and recorded `M1 REMOVED 3.5 0` with checkpoint `M1-off-removed`.
The complete owner-observed Off sequence is damage `3.5 -> 3.5 -> 3.5`, item
count `0 -> 1 -> 0`. No error was reported.

The preserved log independently records three unique snapshots, sequences
`1/2/3` at frames `22/98/185`, seed `1299135721`, difficulty 0, Maw false in
active/saved/run settings, all other gates true and actual continued false.
The observed seed differs from the earlier C4 handoff seed `3112725348`; use
`1299135721` as this test's provenance rather than assuming the handoff run
survived unchanged. Identical settings and per-checkpoint item/stat evidence
remain available, so the Off comparison is interpretable without a repeat.

- Preserved `M1-off-log.txt` SHA-256:
  `a7d5634cf0de9949eb0a462757f4abdc5bd1c543380b736f8500c9145a79d373`.
  Source/copy hashes matched before/after collection at 15:50:19 UTC.
- Corrected `M1-off-snapshots-corrected.jsonl` SHA-256:
  `4a21fa22d8541a1a2de14fe9b9e4c76593443076b1c13303f0f74b817b983ba0`.
- The first extractor produced an empty file because it confused `label` and
  `checkpoint` and escaped its parser incorrectly. That is a verifier defect,
  not missing engine output. The corrected extraction parses literal prefix
  `OUP_PROBE ` and separately filters label `M1-off` and snapshot checkpoints.
- Its projected `health=null` used a nonexistent generic health key; do not
  infer missing engine health from that projection. The observer uses separate
  `redHalfHearts`, `soulHalfHearts` and `blackHeartMask` fields.
- No literal `Luaerror` or `traceback` was found between the selected records;
  a broader Lua-error assessment will accompany the final On/Off log capture.

For the On comparison, #1 instructed changing only Maw's next-run choice to On,
then starting a NEW Normal Isaac run in slot 2. Before granting items, record
`M1-on` baseline with damage/count/active-gate/observed-continued values. The
expected baseline is `3.5 0 true false`; actual result is pending. No deployment,
source, other toggle, or save-slot changes are part of this comparison.

Owner subsequently confirmed `M1 ON BASE 3.5 0 true false`: damage 3.5, zero
Maw copies, active Maw true and actually observed continued false. #1 requested
`giveitem c399`, one second outside the console, then snapshot
`M1-on-acquired` and the short damage/count query. Expected 4.5/1; actual
acquisition result and this run's logged seed are pending.

Owner confirmed `M1 ON AFTER 4.5 1` after acquisition: +1 damage relative to
the 3.5 baseline, whereas the Off control remained 3.5 with one copy. On-run
removal and final log corroboration are pending. Owner requested that future
commands be in the final visible reply (not commentary collapsed by T3, and not
inside the question widget).

Owner confirmed `M1 ON REMOVED 3.5 0` after named removal and one second outside
the console. The On sequence is damage `3.5 -> 4.5 -> 3.5`, item count
`0 -> 1 -> 0`, compared with Off damage `3.5 -> 3.5 -> 3.5` at the same item
counts. This supports the intended single-copy +1 damage and cache refresh on
removal in the tested fresh local Normal Isaac states. Final On log capture is
pending; black-heart drops, multiple copies and player isolation remain untested.

### M1 final log corroboration and return of session ownership

Collected 2026-11-08 15:57:38 UTC with identical source-before/source-after/copy
hashes (no detected race):

- `evidence/M1-final-log.txt` SHA-256:
  `978dbbaf40710f9dafde95808e71914f648c65ebc37c44ceaf45ab714fe2d9f2`.
- `evidence/M1-final-snapshots.jsonl` SHA-256:
  `e1cdcf96892a41754ff669406863d2e7028e1e1dc20f04f87ab7c4504ca6077b`.
- Seven selected unique snapshots, zero duplicates. No matches for the bounded
  Lua-error/traceback/attempt-to/error-in scan between the first and last selected
  snapshots. The observer's deployment string is operator-supplied; installed
  source identity relies on the unchanged prior installation manifest.

Accepted Off sequence: seed `1299135721`, Normal Isaac, Maw false in active and
saved/run settings, damage/copies `3.5/0 -> 3.5/1 -> 3.5/0`, frames `22/98/185`.

Accepted On sequence: seed `2406764967`, Normal Isaac, all seven gates true and
saved/run Maw true, damage/copies `3.5/0 -> 4.5/1 -> 3.5/0`, frames `32/103/132`,
sequences `6/7/8`. `openUnnerfMawCount` tracked `0/1/0`. Both accepted runs
actually observed a fresh start (`continuedObserved=false`), and player state
remained six red half-hearts, no soul hearts/black-heart mask, no familiars.

Excluded from the On comparison: sequence 4 labeled `M1-on` at frame 887 of
seed `1299135721`. It still has active/run Maw false but next-run choice true;
the label was applied before starting the fresh On run. This is another example
of operator labels not replacing actual settings/seed evidence. No item was
granted in that excluded snapshot, and the valid fresh On sequence follows it.

**Result:** single-copy Maw damage acquisition/removal and corresponding cache
refresh pass the recorded local Normal On/Off comparison. This is not a
pack-absent vanilla test or full Maw compatibility acceptance. Black-heart drops,
multiple copies and player isolation remain untested. #1 returns the interactive
session to #3 after this coherent batch: current known state is fresh Normal
Isaac slot 2, seed `2406764967`, all seven active/next-run gates On, no Maw or
other items, damage 3.5, six red half-hearts. No deployments, sources, mod folders
or slots were changed by #1. #3 owns the next prompts and absent-MCM/fallback/slot
checks; #1 will prepare further compatibility batches without shared mutations.

### C5 optional-MCM absence (shared #3 evidence)

Owner confirmed C5 `true,false,false` under #3's query contract: actual MCM
global nil, active Maw Off, fresh start. Matching seed `766725541` /
`EKQD E0AR [New, 2]`; saved/run Maw false and other six settings true. Pack and
observer Lua executed without Lua errors. Although the log lists the MCM content
directory as loaded, it does not execute MCM's main Lua script; directory listing
alone must not be interpreted as MCM present. This supports a fresh load with
the optional integration absent and saved choices retained, not any item effect.

- C5 log SHA-256:
  `a613f7a087a7eda298178d651a7972318d539791a406ea073d685916381b4a98`.
- C5 save SHA-256:
  `f72c90a3fee80d67bd172c6067770c3e84900eb747afe1378a3834ddb1b91cf5`.

Owner then closed the game. #3 moved save2 to its reversible missing-file fixture
`fixtures/C6-original-save2.dat` with identical hash, confirmed live save2 absent,
and retains ownership for the C6 default-fallback check. C6 outcome is pending;
no source, progression or options changes are reported. #1 has no session lock
and issues no concurrent game steps.

### Second session handoff: orbital comparison

#3 explicitly handed ownership to #1 for bounded Orbital On/Off and optional
Maw ring observations. Current state: slot-3 CONTINUE seed `4201988032` /
`80PE ARNB`, all seven active/saved/run settings On, actual continued true.
No items were acquired during C8, but current health/stats/familiars were not
snapshotted; #1 must measure rather than reuse earlier slot-2 values. Process
PID 2272, launched 2026-11-08 16:47:57 UTC. Source f1c8325, MCM113 and observer
hash unchanged. No cleanup of slot-3 pack data while the game is active.

Shared C8 validates distinct-slot settings through one process: slot-2 NEW Off
seed `1371597772`, slot-3 NEW On seed `4201988032`, slot-2 Continue retains Off,
slot-3 Continue retains On. Other six settings remain true and no Lua errors
were reported. C5 MCM absence, C6 missing-data defaults and C7 truncated-JSON
safe defaults also passed #3's engine/log checks; MCM has been restored.

- `C8-slot-isolation-log.txt` SHA-256:
  `d7f11ebd0258fdbc79b1cc4d30ac24dec7f711bba255b09d5c8406f6296c4ad8`.
- Save2 SHA-256:
  `5545628e500a407a58f7182b9067aca2651d40a73e3e1a8b081e3468ccf880de`.
- Save3 SHA-256:
  `68aaeaaa2378670fa5b1faf5041093e8b8b81b9d09aabec5866ca7881132654d`.

Each independent Off control must disable only its component while the other
six remain On. Combining Orbital Off and Maw Off would not demonstrate their
independent gating. Actual seeds/settings/start flags will be logged. #1 returns
ownership explicitly after this batch; no source fix is deployed without
coordinating exact bytes and state transition.

### O1 orbital On baseline

Owner supplied a screenshot; mandatory Terra/xhigh inspection transcribed the
fully legible line `O1 BASE 3.5 6 0 0 true false 1685473150`. Fields are damage,
red half-hearts, soul half-hearts, Dagger copies, active orbital gate, actual
continued flag and start seed. Actual state is therefore fresh at seed
`1685473150`, not the earlier slot-3 continued handoff seed `4201988032`.
The operator-supplied Start label `continue` does not override the observed
continued false. It remains a usable Orbital-On baseline; no item granted yet.

Attachment provenance: owner image
`mcp-launch-f1840b0198b9aa9f5d57e7bc8ab97bebff2741b590b5bd525e90044769d900f5-5e82de18-1707-4573-87bb-edb6e431993c.png`.
Observer log corroboration, exact slot/character fields and orbital behavior
remain pending. The next smallest engine case is one Sacrificial Dagger (c172),
one second of normal updates, then damage/size/processed snapshot without any
enemy interaction or further items.

Owner granted `c172`, allowed one second outside the console and recorded
`O1 DAGGER 30.0 13.0 true`, `O1 COUNT 1` at checkpoint `O1-on-dagger`.
This confirms initial processing of one Dagger in the On run. Native baseline
and room/Continue/stat-modifier lifecycle are not established by this single
observation. Next check is one ordinary doorway transition and repeat snapshot,
without item collection; familiar InitSeed in logs will distinguish the same
entity from native recreation.

Owner confirmed `O1 ROOM 30 13 true`, count 1 after one doorway transition
(`O1-on-next-room`). This supports no repeated doubling on that observed path;
entity identity is still to be checked in captured logs. Next native-modifier
probe grants one BFFS (c247), snapshots the Dagger after updates, and records
actual fields. Field scaling must be interpreted alongside an Off control and
actual contact behavior; a property alone is not measured contact DPS.

Owner confirmed `O1 BFFS 30.0 13.0 true`, `O1 BFFS COPIES 1` at
`O1-on-bffs`. Thus BFFS acquisition did not rewrite these exposed Dagger fields
in the observed On state. This does not establish whether the engine applies
BFFS contact multipliers elsewhere; do not label BFFS nonfunctional or orbital
compatibility complete from this property read. Next check retains Dagger and
BFFS across ordinary quit-to-menu/Continue, snapshots fields and actual continued
flag. Native contact damage remains a separate acceptance question.

Owner confirmed after quit-to-menu/Continue: `O1 CONTINUED 30 13 true`, with
resume flag true, BFFS count 1 and unchanged seed `1685473150` as requested.
This is owner-observed familiar field persistence/recreation coverage for this
On run; logs will identify actual familiar seeds and corroborate settings.
Next control turns ONLY Orbitals Off, retaining other six On (including Maw),
then starts a fresh Normal Isaac in the same slot before granting any items.

### O1 independent orbital Off control (owner observations)

Owner confirmed the requested fresh Off baseline: damage 3.5, zero Dagger/BFFS
copies, active Orbitals false and actual continued false; the new seed will be
read from logs. Only Orbitals was changed; the other six remain On by setup,
pending exact snapshot corroboration.

After `giveitem c172` and one second outside the console, owner reported
`O1 OFF DAGGER 15 10 nil`, count 1 at `O1-off-dagger`. After one doorway
transition, confirmed `O1 OFF ROOM 15 10 nil`. After `giveitem c247` and one
second, reported `O1 OFF BFFS 15 10 nil`, BFFS count 1. After quit-to-menu and
Continue, confirmed `O1 OFF CONTINUED 15 10 nil`, actual continued true, BFFS
count 1 and same run seed. All observer checkpoints were requested explicitly.

This pairs On field processing (damage 30, size 13, processed true) with native
Off fields (15, 10, no processed flag). Both observed states survive the tested
doorway and Continue paths. BFFS acquisition rewrites neither exposed field
in either state; its actual contact multiplier is not measured by these reads.
No claim yet about orbital collision DPS, every orbital variant, Cube-of-Meat
state changes, BFFS combat scaling or pack-absent vanilla restoration/stacking.
Final O1 log corroboration and actual familiar identity/seed details are pending.

Current known game state pending collection: current fresh-origin Off-control
run now continued, Dagger 1 and BFFS 1 equipped, Orbitals Off and other six On.
No source/deployment/mod-folder/save-slot changes by #1. Leave the game open;
return ownership explicitly to #3 after preserving this log, with equipped items
and active/next-run settings disclosed rather than silently resetting the run.

### O1 captured evidence and setup correction

Preserved `O1-final-log.txt` (235630 bytes) SHA-256
`5ee0c315879717b15c1ed254c1267dad70703b827e8ae6e6d3b71d555e2acb09`;
`O1-final-snapshots.jsonl` (13488 bytes) SHA-256
`514744f70f3e2daf048787e227bfc30a63695b78c6b6a1e25288115730b95061`.
Thirteen unique snapshots, no duplicates, no bounded error-term matches in
selected source lines 1776–3322. Copy matches captured source bytes; source
length/mtime were stable, but the collector did not re-hash the entire live
source after copying, so do not overstate its race check as full byte equality.

Log corroboration: On seed `1685473150`, Dagger familiar InitSeed `2897085328`
and owner `3691356602` retain fields 30/13/processed true across acquisition,
doorway, BFFS and Continue. Off seed `992359654`, familiar `1581723886`, owner
`3980557562` retain fields 15/10/unprocessed on those paths. Type 0, player
damage 3.5 and health six red/no soul half-hearts remain recorded. The observer
has no Dagger/BFFS item-count fields; owner short queries supply those counts.

**Important setup correction:** actual active and saved-run settings show
`mawOfTheVoid=false` throughout BOTH O1 runs, with all five other non-orbital
gates true. Thus Off has two disabled components, despite the requested setup.
Earlier statements that the other six remained On were requested/owner-assumed
setup, not corroborated facts. This does not erase the observed Dagger fields
or lifecycle, but it does not satisfy the strict independent-control contract.
Initial On baseline queried only Orbitals, not the other six; #1 corrects that
verification gap before calling the independent case complete.

Next bounded correction repeats just the short acquisition field comparison
under explicitly verified gates: Off with only Orbitals false and other six
true; On with all seven true. Retain prior lifecycle observations with their
actual Maw-Off context instead of pretending the complete lifecycle matrix was
run under all-On conditions. No game-code defect or source fix is inferred.

### O1 corrected independent acquisition field comparison

Owner set Orbitals Off and all other six On, started a new Normal Isaac run in
the same slot, then confirmed `O1 CHECK false true false` and `O1 ITEMS 0 0`.
The middle boolean explicitly ANDs all six non-orbital active gates, including
Maw; the final boolean is actually observed continued false. After one c172 and
one second of normal updates, owner confirmed `O1 INDEPENDENT OFF 15 10 nil`.

Owner then set Orbitals On, retained the other six On, started another new
Normal Isaac run in the same slot and confirmed `O1 ON CHECK true false` and
`O1 ITEMS 0 0`. The first boolean explicitly ANDs all seven active gates. After
one c172 and one second, confirmed `O1 INDEPENDENT ON 30 13 true`.

These corrected acquisition field observations meet the requested isolated
toggle setup; their actual seeds/settings and familiar identities await final
capture. Do not relabel the earlier doorway/BFFS/Continue observations as
all-other-six-On results: they remain valid only in their Maw-Off context.
Current known state is the new all-On run, Dagger 1, BFFS 0. No source/deployment
or slot changes were made. Preserve log then explicitly return #3 ownership.

### O1 independent comparison log corroboration and session return

Read-only capture at 2026-11-08 17:37:03 UTC: both complete source-byte reads
and copied log have identical SHA-256 (no detected race).

- `O1-independent-log.txt`, 536941 bytes, SHA-256
  `e95d7d7df2b85a9df9bde0b4a8937497fd1b50ac4b43d42c59c05ff1316831c7`.
- `O1-independent-snapshots.jsonl`, all six selected raw records, SHA-256
  `b5350229a71b33c294aa0dc940e3288ff0c70f4ad4aa74cdcb5f5f38b5e4e663`.
- Selected sequences 1932–1937, source lines 4959–5281; no bounded
  Lua-error/traceback-pattern matches. Files remain in the shared Windows
  session's evidence directory, preserving earlier artifacts unchanged.

Accepted independent Off: slot 2 NEW seed `2753493845` / `ZR22 KLBA`, Normal
Isaac, sequence 1932 baseline frame 29 and sequence 1933 Dagger frame 87.
Active, saved and run settings agree: only Orbitals false, other six true.
Baseline has no familiar, player damage 3.5, six red/no soul half-hearts and zero
Maw copies. Dagger familiar `1364138763`, owner `2795575305`: damage 15, size 10,
processed absent.

Accepted independent On: slot 2 NEW seed `711482952` / `E0DW DPJF`, Normal
Isaac, all seven active/saved/run settings true, actual continued false. The
new-run event is sequence 1935/frame 0; Start baseline sequence 1936/frame 19
has no familiar; sequence 1937/frame 121 records Dagger `1909136033`, owner
`4017206558`, damage 30, size 13, processed true. Player damage/health and zero
Maw count match the Off baseline. Dagger/BFFS counts come from owner queries,
since the observer reports only Maw collectible count.

Excluded sequence 1934: labeled `O1-independent-on` at frame 304 of the prior
Off seed, actual/run Orbitals false and next-run Orbitals true. This records a
menu choice before the fresh boundary, not the On control. A label alone never
determines active settings or run identity.

**Bounded result:** independent Dagger acquisition field processing passes for
the recorded On/Off setup. Earlier doorway/BFFS/Continue observations remain
corroborated in their actual Maw-Off context. This is not general orbital combat
acceptance: contact damage/ticks, BFFS combat scaling, Meat lifecycle/variants,
other orbitals and actual pack-absent vanilla comparison remain pending.

#1 explicitly returns session ownership to #3 after this capture. Current known
state is slot-2 fresh-origin Normal Isaac, seed `711482952`, all seven On,
Dagger 1, BFFS 0, player damage 3.5, six red/no soul half-hearts, zero Maw copies.
Observer remains active with label `O1-independent-on`, latest snapshot sequence
1937. No source/deployment/observer/mod-folder or progression/save changes by #1;
new test runs and menu choices were owner-controlled. No cleanup while active.
Optional Maw ring observations are deferred to a later explicit handoff.

## Optional observer protocol (not yet deployed or engine verified)

Source: `tools/compatibility-observer.lua`. It is not loaded by production
`main.lua`. #3 must approve exact bytes and record hashes before optional staging.
The session owner chooses its loader/path and verifies `luarun` support; do not
guess a Windows working directory or reload production modules via `luamod`.

After loading the agreed observer file, the console protocol is:

```lua
lua OUPProbe.Start("M1-on", "ACTUAL_DEPLOYED_SHA", "fresh")
lua OUPProbe.Snapshot("before-maw")
lua OUPProbe.Snapshot("after-maw")
lua OUPProbe.Stop()
```

Replace `ACTUAL_DEPLOYED_SHA` with #3's verified manifest value. This argument is
an operator label, not independent verification of installed source. Snapshot
records all seven active `Config.IsEnabled` gates, decoded saved settings/run
snapshot, seed, difficulty, literal available MCM version fields, per-player
damage/Maw count/health, and familiar state. Missing MCM version fields require
the source-manifest version; do not assume a version from mere presence.

Fresh/Continue is recorded as an observed `MC_POST_GAME_STARTED` boolean only if
the observer was loaded before that event. When loaded mid-run,
`runStartObserved=false`; `operatorRunKind` is merely the session owner's label.
Registering an observer is instrumentation, not an uninstrumented vanilla run.

Every record is printed and sent to `Isaac.DebugString` with prefix `OUP_PROBE `
as JSON. Log collection copies those lines read-only. Pickups are recorded once
on first observed update per Start, including pre-existing pickups; a record is
not necessarily a new spawn. A pre-damage record is not proof of applied damage
or cancellation, and earlier cancelling callbacks may prevent this observer from
receiving an event. Laser fields are first-update observations, not drop-rate
proof. Snapshot after the interaction for final health/stats.

Observer callbacks never return a cancellation value or change entities, config,
items or save data. Stop disables event logging; callbacks remain registered
until exiting the application. Coordinate restart/removal with session owner;
never delete a production mod or save as observer cleanup.

## First compatibility batch: M1, Maw cache acquisition/removal

Prerequisites: explicit session handoff; known deployment; fresh disposable
Normal Isaac; no other damage items/cheats; Maw active gate On. #3's own config
assertions remain theirs. Do not change MCM or restart during this batch.

Without the optional observer, this one-line command records the essentials:

```text
lua local p=Isaac.GetPlayer(0); local s='OUP_M1 damage='..p.Damage..' copies='..p:GetCollectibleNum(399)..' enabled='..tostring(openUnnerfPack.Config.IsEnabled('mawOfTheVoid'))..' seed='..Game():GetSeeds():GetStartSeed(); print(s); Isaac.DebugString(s)
```

1. Run the snapshot command. Expect damage 3.5, copies 0 and enabled true on
   otherwise unmodified Isaac. Record actual values; stop if preconditions differ.
2. `giveitem c399`. Close console and allow one second for updates, then snapshot.
   Expect copies 1 and damage 4.5 (+1 over the recorded baseline).
3. `remove Maw of the Void`. Close console one second, then snapshot. Expect
   copies 0 and original damage restored. If named removal is rejected, capture
   the error rather than inventing a replacement command.

After each operation obtain owner observation and matching logs. A separate
fresh run with Maw gate Off provides the engine control while preserving the
mod set. It is not a pack-absent vanilla control. Native stacking acceptance also
requires the actual vanilla comparison arranged by the shared session owner.

## Acceptance matrix

| Criterion | Current engine status | Next bounded evidence |
| --- | --- | --- |
| Fresh and continued load | Pass for recorded local Normal runs C1/C3/C4 | Matched owner observations, source/manifest, seeds, fresh/Continue log and no Lua errors. Other modes unverified. |
| Maw cache/damage and per-player isolation | Single-copy acquisition/removal On/Off pass, owner + logs corroborated | Multiple copies, distinct-player isolation and pack-absent control remain unverified. |
| Maw ring/black-heart drops | Pending | Observe actual ring fields and kill/drop outcomes; no nondrop inference from one trial. |
| Orbitals/native state | Independent Dagger acquisition fields pass with owner + log evidence; doorway/BFFS/Continue fields logged under Maw-Off context | Contact/BFFS combat scaling, Meat transitions, other orbitals and pack-absent comparison remain unverified. |
| Dark Bum/output/exclusions | Pending | Controlled red-heart feeding, record reward provenance and excluded owner cases. |
| Relic timing | Pending | Number actual hostile clears and payouts, snapshot counters; repeat control and Continue. |
| Hard/Normal blue/purple fires | Pending | Record finite trials per type/mode/control, 0/1/2-drop counts and nonlethal/repeated damage separately. |
| Humbling Bundle | Pending | Four pickup types, native reward-selection paths, existing doubles and paired control. |
| Stomp immunity | Pending | Reuse #2 engine evidence only for matching integrated source/fixtures; preserve historical-report uncertainty. |

Preparation alone cannot justify a checkbox or issue closure. Actual commands,
observed values, timestamps and log references above justify only the bounded
results identified in the matrix.

Tracker checkpoint after C1/C3/C4 and M1 evidence: the fresh/continued-run
criterion in #1 is checked; all other acceptance boxes remain unchanged and the
issue remains open. Published result:
https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/1#issuecomment-6723715489

Local results branch is `issue-1-engine-validation` at the prepared f1c8325 base.
The shared observer file is owned/adopted by #3's integration branch and must not
be committed as a divergent duplicate by #1. Results documents are #1-owned.

## Subsequent bounded batches (release one at a time after M1)

These are proposed recipes, not executed tests. Do not send the whole list as an
owner sequence. Establish each smallest case in-engine before broader execution.

- **O1 orbital state:** fresh Isaac, `giveitem c172` (Sacrificial Dagger), allow
  one second, snapshot; walk to an adjacent room and snapshot the same familiar;
  reuse #3's Continue workflow and snapshot again. With only the orbital gate
  changed in separate fresh control, compare size/damage. Production intends
  minimum size 13 and double the native collision value once per entity; record
  actual values before interpreting. Repeat with `giveitem c73` and extra copies
  to cover orbital-to-follower variant changes. Do not treat familiar recreation
  (different InitSeed) as repeated processing of one entity.
- **D1 Dark Bum output:** full-health Isaac, `giveitem c278`; `spawn 5.10.1`,
  wait for the familiar to collect; repeat one heart at a time until payout.
  Snapshot before feeding and after payout, record consumed hearts and all
  pickup/spider outputs. Full health prevents Isaac from collecting red hearts.
  One absence proves no reward probability. Exclusion cases require fresh Lost,
  Keeper and tainted variants selected by owner; do not change character mid-run
  and assume the existing familiar's owner/counters remain comparable.
- **R1 Relic cadence:** `giveitem c98`, snapshot, clear genuine hostile rooms
  one at a time, snapshot after each payout and number the clears. Continue
  between payouts only through the established shared workflow. Do not replace
  real room-clear events with synthetic counter writes. Counter values and exact
  payout intervals must be paired against the control rather than assuming an
  undocumented threshold.
- **B1 Bundle selection:** full-health Isaac, `giveitem c203`, then spawn one
  each `5.10.1`, `5.20.1`, `5.30.1`, `5.40.1`. Observe actual subtypes and also
  open chests/obtain normal room-clear rewards. Explicit console spawn may select
  differently from native random rewards; a successful direct-spawn observation
  does not establish every selection path. Repeat with gate Off and pack absent
  under shared-session control, recording singles versus double packs.
- **F1 fire pathway:** first verify one `spawn 33.2.0` blue fire destroyed with
  an ordinary bomb on Normal, then one purple `spawn 33.3.0`; record damage event
  and 0/1/2 soul-heart outputs. Keep player away from pickups. Repeat smallest
  case on Hard/control. Only after verifying these pathways, design/verify a
  bounded automated trial runner to reduce owner repetition. The runner must
  count deaths and all drops, distinguish repeated/nonlethal damage, preserve
  deterministic trial provenance, and retain natural-bomb controls. No finite
  nondrop sample proves a zero probability, and no single drop proves 25%.
- **S1 stomp:** use the current integrated #2 fixture and its exact tested source
  identity/flags, not an obsolete branch. Reuse evidence only after matching SHA,
  mod gates, character, health, attack source and engine procedure. Test Host Hat,
  Pyromaniac, both/neither and an ordinary-damage control separately; snapshot
  actual red half-heart units before and after. Distinct stomp entities are not
  interchangeable acceptance cases.
