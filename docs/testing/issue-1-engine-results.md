# Issue #1 engine validation ledger

## Current status

Runtime under test: integrated source f1c8325, MCM Pure v113 and the immutable
separate observer recorded below. This file is a chronological evidence ledger;
later actual settings/seeds supersede earlier requested or assumed setup.

- Fresh local Normal loading and relaunch/Continue are corroborated.
- Single-copy Maw damage/cache acquisition and removal are corroborated with
  independent Maw On/Off controls.
- M2 additionally corroborates two-copy damage and removal of one copy, plus
  native ring fields of 0.05 with Maw On and 0 with only Maw Off. Actual
  black-heart output is now observed in the controlled one-Clotty v2 pilot;
  distinct-player isolation and pack-absent comparison remain unverified.
- Independent Sacrificial Dagger field processing is corroborated. Earlier
  doorway/BFFS/Continue field observations were made with Maw Off and retain
  that narrower context; they are not contact-DPS measurements.
- Held-Maw Continue/removal and Hard Jacob/Esau cache isolation are corroborated.
  Maw's pack-absent comparison, orbital combat/lifecycle behavior, Relic cadence,
  fire stacking/probability and other outstanding matrix rows remain open.
- Current session owner is #1 after #3's explicit final cleanup/handoff. #1 is
  preparing remaining compatibility tests and owns eventual coordinated shared
  deployment restoration. No claim of complete issue acceptance.

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

### Relic initialization observations; shared log collection blocked

During #3's exclusive session, owner completed strict initialization setup:
Off baseline `R0 false,true,false,0` (Relic Off, other six On, fresh, zero copies),
then observed actual Relic counter 0 after acquisition. Fresh On baseline
`R2 true,false,0`, then observed counter 2 after acquisition. These are
owner-reported initialization/gate observations, not cadence or payout proof.
Current On run remains open with one Relic; #3 asked owner to stay in the room.

#3 reports its remote Luna/medium capture failed BEFORE START during provider
setup: the existing `shadow/state_5.sqlite` entry is not the expected symlink.
No collection ran and no capture files or game/source changes resulted. Do not
remove provider databases, substitute models, or claim a log-backed Relic pass.
#1's latest remote collector was a completed bounded task, not a maintained live
Windows shell; metadata-only availability check follows this report. Preserve
the owner run/log and #3 session ownership while collection access is blocked.

### Relic records recovered after provider repair (no replay)

Owner repaired the Windows provider environment and #3 reports the same
Luna/medium shell successfully recovered five existing R-off/R-on snapshots.
The prior collection blockage is therefore historical, not current. No test
replay, source change or synthetic payout was used to recover the evidence.

- `R-final-log.txt` SHA-256:
  `012e44e44fada520971fa62ce091185115a2913ce29516704e7f0b37a95beaf3`.
- R snapshot JSONL SHA-256:
  `194be4f949aef5d1a49f969a2c0b8853b3fd6c127865d3eafdd7e022a8b4e438`.
- Captured save SHA-256:
  `f9c2931af6613f5065861f516341cf4c1cfa18039a5fd4ebd57049ab175df807`.

Strict Off seed `3124566089`: Relic false, other six true in active/saved/run
settings; familiar variant 23, InitSeed `3779570156`, owner `2482275868`,
RoomClearCount 0 after acquisition and at stop. On seed `3074871929`: all seven
true; familiar InitSeed `2038030361`, owner `768699799`, counter 2. Both actual
continued flags false, player type 0, six red half-hearts and zero Maw copies,
MCM113, no Lua errors. #3 reports stable log/save metadata, same PID2272.

**Bounded result:** independent Relic initialization/gating is owner- and
log-corroborated. No cadence, native payout interval, reset-ordering or Continue
counter-persistence pass follows from these initial counters. Current Relic-On
run remains open with one Relic; #3 keeps ownership and plans a separate strict
Dark-Bum-Off fresh setup. Any new payout trace is separate diagnostic
instrumentation requiring explicit verification, not part of immutable observer
deployment or production-source changes.

### Dark Bum trace preparation under #3 ownership

Owner confirmed strict `DB0 false,true,false,0` setup (Dark Bum Off, other six
On, fresh, zero copies), and both `AddPriorityCallback` and `RemoveCallback`
are functions in this engine. This establishes API availability, not trace
registration or payout execution.

#3's main Sol authored a separate read-only trace v1 at
`tools/validation/dark-bum-pickup-trace.lua`, published commit prefix `87093f`.
Reported syntax-checked file: 3404 bytes, SHA-256
`f30c68cc350e3c08ed24d3baba90601da02c32f82c8103b6491380f7320a4c9b`.
Staging provenance SHA-256:
`356a2c4b3649add757dd84cf2ef97c44311d2f7bef87d91d0656dbb242543e33`.
It is a dormant extra file in the observer mod directory, separately recorded
from the original 38-file package; immutable observer `main.lua` remains
unchanged. It is not production source and has not yet been loaded or proven
to run in this reported checkpoint.

The specified trace uses existing pack mod reference, init observers at -100
and +100, and first-update observer +100, always returning nil. No production
callback functions/priorities, RNG, Morph, spawn, save or config behavior is
replaced. Separate `OUPDBTrace.Stop` removes only its own callback references.
It logs only DB-off/DB-on while OUPProbe is active. Identity records Index and
InitSeed separately because Morph may change the seed. Spawner presence,
conversion and owner type are diagnostic observations, not inferred provenance.

#3 owns the first registration smoke before granting a Dark Bum. Registration
outcome and actual native payouts remain pending. #1 neither deploys nor prompts
the owner during this session; later interpretation may reuse valid records.

### Native Dark Bum observations reported; final capture review pending

#3 reports a strict native payout comparison without forced RNG or synthetic
payouts. Off fresh seed `3699682887`: only Dark Bum false, other six true;
two familiar-attributed pills (type/variant/subtype `5/70/9` and `5/70/8`)
remain unchanged across init-before, init-after and first-update observations.

On fresh seed `3582772347`: all seven true, Dark Bum familiar variant 64,
InitSeed `3357659119`, owner `572960397`, player type Isaac 0. Six native
pickups at frames 223, 247, 286, 319, 349 and 383 begin with variant/subtype
`70/11`, `70/6`, `300/15`, `10/6`, `70/6`, `70/3`; reentrant init and later
observations report soul hearts `5/10/3`. Morph changes InitSeed and initial
Index 0 is nonunique; neither may independently identify the full before/after
chain. Spawner entity/familiar/owner are ready at init in these observed cases.
Owner `DB_LEFT 0`, six soul hearts and no black hearts agree with the reported
trace. Ten manually spawned red-heart food inputs are separate from payouts.

Separate trace v1 hash remains
`f30c68cc350e3c08ed24d3baba90601da02c32f82c8103b6491380f7320a4c9b`;
production and immutable observer unchanged. #3 is cross-checking raw phases and
awaiting collector final metadata; #1 does not yet mark this log-backed row
complete. No rates, excluded-character behavior, payout cadence or general
compatibility pass is inferred. #3 keeps exclusive ownership for remaining
Bundle/blue-fire/stomp gate checks; #1 only prepares read-only recipe facts.

### Existing issue-2 native Mom evidence (reuse with revision limits)

Parent cross-checked current f1 stomp code against the checked-in
[issue-2 validation note](../research/issue-2-stomp-validation.txt). The existing
native fixture was console-assisted actual Mom via stage 6 and The Emperor,
not merely a manually spawned foot. Protected-item IDs are Pyromaniac 223 and
Host Hat 375. Broken Shovel 550 is a documented convenience candidate, but its
attacks must not be assumed to cover every actual-Mom source/flag path.

Historical baseline e2eb46f, seed `YXZ9 KTZH`: actual source `45.10.0`, state 7,
animation Stomp frames 27/28 generated amount 2/DAMAGE_CRUSH then amount 2/flags
0 in the same game frame 142. Original pack + Host Hat cancelled the first,
allowed the second, and next-frame health changed from six to four half-hearts.
The pair is one measured health transition, not two independent health losses.
Preserved log SHA-256:
`91808a3be8fb811e75275468be8c930e1eac3495ee57956a02784c859f26751b`.

Candidate issue-2-v1, seed `NKKG R339`, stage 6/type 0/room 93: both events
cancelled with Host Hat, health retained six half-hearts; ordinary enemy 15.0.0
Hop/flags 0/amount 1 subsequently allowed health to fall to five. Log SHA-256:
`82478fa50528bde63716e7cea79dff43a305c1f917319b0dfc698d168ac6156e`.
Separate candidate Pyromaniac gain of one full red heart is owner-observed only:
its probe produced no confirming Pyromaniac hit trace. It must not inherit the
Host Hat trace's verification.

Current f1 source retains the narrow added zero-flag source-45/variant-10/Stomp
check behind the configuration gate. It heals two half-heart units only for
flagged crush impacts, not extra zero-flag contact. Candidate-note evidence is
revision-specific; it is not a new strict f1 On/Off validation or proof of every
historical stomp report. #3 received these facts for its bounded native tests.
Any pre-damage trace must precede cancellation to observe On events, return nil,
and group next-frame health by player/event frame. The default observer can be
skipped after an earlier callback returns false; absence there is not evidence
that the native event never occurred. No #1 owner commands were issued.

### Current-build Host Hat/Mom and blue-fire reports from #3

#3 reports completion of seven bounded independent toggle comparisons, pending
its final records/validation PR. It retains exclusive session ownership through
one owner cleanup command; #1 issues no game prompts or shared mutations.

Current f1 Host Hat/Mom comparison supersedes candidate-only uncertainty for
that narrow case: Off seed `1134466152`, only stomp false and other six true,
source 45.10/Stomp animation frame 27, flags 16777216/amount 2 at game frame 144;
next frame 145 grouped red health six to four. On seed `4022326141`, all seven
true, source 45.10/Stomp animation frames 27/28, crush then flags 0 at game frame
84; next frame 85 grouped red health six to six. No other source contacts in
either capture. This is not a Pyromaniac or all-stomp-variants pass. Exact final
artifact hashes are to be reused from #3's configuration-results ledger.

Blue-fire report: Off observes two real explosions, one each on 33.2 and 33.3,
with no nested hearts; On observes ten unique targets with one explosion each,
including a purple-fire-spawned soul heart between early and late callbacks.
The 220 incidental flags-2 fire-to-fire visits are excluded from explosion
trials. This is positive callback-path evidence, not a drop-rate estimate or
proof about native stacking. Exact mode/settings/artifact context awaits #3's
final ledger extraction; do not assume Hard merely from the module's scope.

Current reported run: slot 2, fresh Normal Isaac, seed `4022326141`, all seven
active/saved/run On, MCM113, stage-6 Mom room 142, Host Hat 1, Pyromaniac/Maw 0,
damage 3.5, six red/no soul or black half-hearts. Production f1c8325 and frozen
observer remain unchanged. Four read-only diagnostic files were added separately
beside the observer; their callbacks have been removed as cases ended except
the stomp trace, pending cleanup. Preserve backups and installed pack/MCM/shared
observer for subsequent #1 tests; do not treat pending cleanup as complete or
assume the current room is safe/empty for the next feature batch.

### Final #3 cleanup and session return to #1

Owner confirmed TEST_CLEANUP followed by five true values: OUPProbe inactive,
OUPStompTrace/OUPDBTrace/OUPHBTrace/OUPFireTrace globals nil. Their own callbacks
were removed; base observer remains installed and unchanged. Optional files
remain dormant, not auto-loaded. #3 explicitly returned interactive ownership
to #1 and will issue no competing game prompts/file/deployment changes. A #3
read-only final log copy may occur with race coordination.

Handed-over current run: slot 2, fresh-origin Normal Isaac seed `4022326141`,
all seven active/saved/run On, MCM113, stage-6 Mom room 142, Host Hat 1,
Pyromaniac/Maw 0, damage 3.5, six red/no soul or black half-hearts, paused console.
Source remains `f1c83253af3636816c3b83c6ab28d2221ad345ea`; frozen observer hash
unchanged. #1 must establish a new relevant baseline rather than treat this
boss room as an empty safe test chamber. Backups and installed pack/MCM/observer
remain in place for further validation; #1 now owns eventual restoration.

New reusable #3 results: strict Relic initialization counters 0 Off / 2 On
(no cadence); Dark Bum native unchanged pills Off / six transformation chains
On; Bundle native single penny unchanged Off and key/four pennies/bomb converted
On with half-heart negative control; actual Hard blue/purple explosions and one
nested On purple soul-heart spawn (not rates); current Host Hat/actual Mom
grouped health protection On versus loss Off. Full final setup/hash details are
in #3's configuration-results ledger. None completes the outstanding #1 broad
compatibility/vanilla comparisons by itself.

First #1 step after accepting ownership: owner starts a NEW Normal Isaac in
the same slot, retaining all seven On, then records M2 baseline before Maw or
any test enemies are granted. No file/deployment changes for that transition.

### M2 ring On baseline and first field probe

Owner confirmed `M2 BASE true false 3.5 0 0 1` followed by the run seed (not
transcribed numerically): all seven gates On, observed fresh start, damage 3.5,
zero Maw/Host Hat, stage 1. Actual numeric seed will be taken from observer logs.
Owner requested future result questions use the question tool with choices;
commands remain in visible final replies with Lua syntax fences.

Next smallest engine case grants one Maw, then owner charges shooting for three
seconds, releases and immediately pauses with the console to inspect live laser
Subtype/BlackHpDropChance/sprite fields. The base observer also records the first
laser update, so failure to catch a short-lived ring in the console is not proof
that no ring occurred. No enemy is spawned and no drop inference is made here.

Owner selected `M2 RING shows drop chance 0.05` after granting c399, charging
shooting three seconds, releasing and inspecting a live laser. This confirms
the observed On ring field assignment, not native kill attribution, heart-drop
generation or the final drop probability. Next smallest case adds a second Maw
and snapshots damage/count after a normal effect update; expected 5.5/2.

Owner selected `5.5 damage and 2 copies` at checkpoint `M2-two-copies` after
granting the second c399. This confirms the two-copy additive cache value in
the current On run. Next uses native `RemoveCollectible(399)` once, then waits
for normal effect updates and snapshots expected 4.5 damage / one copy; no
direct Damage write or synthetic cache evaluation is performed by the test.

Owner selected `4.5 damage and 1 copy` at `M2-one-left` after exactly one
native RemoveCollectible call and normal effect updates. Two-copy acquisition
and one-copy removal therefore match intended per-copy damage in this On run,
pending log corroboration. This is still one player; player isolation is open.

### Requested console-only UI automation smoke

Owner explicitly requested a subagent operate the Windows console for tests
that do not involve active gameplay. Mandatory Terra/xhigh was assigned exactly
one read-only stat-query round-trip, with game-only before/after capture and no
item, run, settings or file changes. Windows is reachable and Terra available.

The installed computer-use skill initialized `@oai/sky`, but its first
`list_apps` call failed: `Computer Use native pipe is unavailable: failed to
connect native pipe: ... file not found (os error 2)`. It stopped before window
inspection, keyboard input or screenshots. The query was NOT executed; do not
count this as an automation pass or a feature failure.

Failure manifest is in the Windows scratch thread directory
`2026-11-09-act-as-the-test-sub-d018a3c4/console-smoke-manifest.txt`. A bounded
read of the skill's documented recovery instructions is in progress. No helper
binary launch, custom native-pipe client, model substitution, game change or
silent alternate UI method has been performed. Current game state is still
last owner-observed M2 one-copy Maw at damage 4.5, console left open.

A fresh Terra/xhigh bounded retry initialized @oai/sky but the single list_apps
call immediately failed with the same missing-native-pipe/os-error-2 result.
No UI inspection, screenshots or input occurred in either attempt. The installed
computer-use guidance requires node_repl + supported sky APIs and does not permit
PowerShell UIA/SendInput substitution; no helper/client bypass was attempted.
Desktop automation is currently environment-blocked, not a feature failure.
Owner was offered manual continuation or a pause for desktop repair; choice is
pending, so no new game command is issued meanwhile.

Separate Maw trace source and callback-contract test were authored locally.
After restoring the missing temporary Lua 5.3.6 checker, syntax and the first
parent-run contract smoke passed, including always-nil callbacks, source-record
classification and exact own-callback cleanup. The injected diagnostic-error
case deliberately verifies fail-closed logging without cancelling native damage.
These are diagnostic safety checks only, not engine kill attribution or drops.
At this preparation checkpoint, the new trace had not been staged or loaded in
the Windows installation. The later M2 staging checkpoint below supersedes that
deployment status; engine registration still requires its own observation.

Owner selected manual console continuation after the supported desktop connector
failed its bounded retry. No further desktop-control attempts are authorized by
that choice. #1 is publishing/reviewing the local Maw observer before staging a
separate dormant file; owner will explicitly load it. Existing production source,
frozen observer, settings and current one-copy run remain unchanged.

### #3 final repository checkpoint (configuration-only closure)

#3 reports validation PR #10 merged at
`8af78fc1349423395ebfc238e3faaf16e9532475`, with all seven issue-3 acceptance
boxes checked and that issue closed. This is configuration closure, not #1 full
compatibility closure. Current master includes the final
[configuration-results ledger](configuration-results-1.9.7.17.md), four
issue-specific diagnostic sources/hashes and the unchanged frozen observer.
Production main/config/Mods remain identical to tested f1c8325; do not relabel
the actual deployed runtime as 8af78fc because documentation/tools merged.

- Final immutable `C3-final-handoff-log.txt` SHA-256:
  `358910b4376eb64f1a45023941e05cfb59d296b67285ccc2240128f747b68496`.
- Sidecar SHA-256:
  `84f42b8e46a93924f1b03d7450ba1dff08d1e3ba6da2aa5bcf7dc8dff3405636`.
- Reported `race=false`. ST-on stop at line 20635 belongs to Mom seed
  `4022326141`, not the subsequent M2 new run. DB/HB/ST removal markers appear;
  BF removal marker is absent. Owner cleanup five-true confirmation remains
  separate evidence; marker absence does not establish live callbacks.

#3 performed no further game/deployment changes and returned all ongoing
session/restoration responsibility to #1. Its validation branch was removed and
own worktree left clean/detached. #1 and #8 remain open. Current M2 request is
still waiting for owner baseline; the #3 checkpoint is not an M2 outcome.

### M2: multiple copies and native ring fields

Production remains f1c8325, with MCM Pure v113 and the frozen base observer.
These are fresh Normal Isaac runs (difficulty 0, actual continued false).
Active settings, saved choices and saved run settings agree: the On run has all
seven On; the Off run has only Maw Off and the other six On.

| Label / seed | Checkpoint | Frame / sequence | Damage / Maw copies / cached copies |
| --- | --- | --- | --- |
| M2-ring-on / 3114500365 | start | 188 / 12375 | 3.5 / 0 / 0 |
| M2-ring-on / 3114500365 | M2-two-copies | 481 / 12435 | 5.5 / 2 / 2 |
| M2-ring-on / 3114500365 | M2-one-left | 530 / 12436 | 4.5 / 1 / 1 |
| M2-ring-off / 1072936563 | start | 11 / 12438 | 3.5 / 0 / 0 |
| M2-ring-off / 1072936563 | M2-off-ring-check | 138 / 12451–12453 | 3.5 / 1 / 0 |

All listed snapshots record six red half-hearts, zero soul half-hearts and black
mask zero. The owner separately reported damage/copies 5.5/2 and 4.5/1 after
acquisition and one removal. The three Off checkpoint records are distinct
snapshot invocations at the same game frame, not three independent ring trials.

Both runs contain native laser type 7, variant 1, subtype 3 with sprite
`gfx/007.001.003_Dark Ring.anm2`. The first On observation is frame 374 / sequence
12376, `BlackHpDropChance=0.050000000745058`, spawner player seed 1146726165.
The first Off observation is frame 127 / sequence 12439,
`BlackHpDropChance=0`, spawner player seed 1907838666. Both report laser InitSeed
4215710538; shared InitSeed alone does not identify the same entity across runs.
Further laser observations across frames are not independent kill/drop trials.

The owner reported an On ring value of 0.05. During the Off query, the full
snapshot printed after the short line and obscured it in the console. The supplied
screenshot contains the Off snapshot (one Maw, damage 3.5, only Maw Off), with no
legible ring-result or error line. Read-only log recovery established the Off
ring field without asking the owner to repeat the interaction. Future feedback
commands must print their short result last, after any full snapshot.

Artifacts under the Windows session's `evidence` directory:

- `M2-fields-20261109T031203445Z-full.log`: 3,225,867 bytes, SHA-256
  `5a4ee1b330d086a56d509ffcfa814c9c0022e1fb919455298f00cafa281fe7be`.
- `M2-fields-20261109T031203445Z-probes.jsonl`: 27,702 bytes, SHA-256
  `2650cd5e2ad3da79486e73d8297745bc8eac1f4f8fc0ab7ce66e62da3599aa95`.
  It preserves 79 raw records, all unique by sequence, label and seed.
- Two shared-read full captures matched byte-for-byte, with unchanged source
  length and timestamp. The bounded Lua-error/traceback/error scan found no
  matches. Short console result lines were not present in the collected log;
  the recorded JSON fields provide corroboration.

This establishes the ring-field gate and two-copy stat handling in these runs.
It does not establish any kill reward, final drop probability, distinct-player
isolation or pack-absent vanilla behavior. Maw Off is a feature gate control.

### M2 native kill trace: staging verified, registration owner-observed

The reviewed optional `tools/validation/maw-ring-kill-trace.lua` from source
commit `4e6944b936dc60e2f3f8ce1921c2df371358a31b` is now installed as a dormant
extra file at `mods/open_unnerf_validation_observer/maw-ring-kill-trace.lua`.
It is 6,984 bytes with SHA-256
`0f1e48677ccc646023927dc23af29b393e3473e71cb6aeed42a958e09cc03182`.
Independent read-only verification matches those bytes and the unchanged base
observer SHA-256 `aea0ac0b0098c29aeb8c5bbe1a73447ee0fd721c085baa2dcd99cd539ec2a7db`.
The scratch sidecar `maw-trace-v1/staging-manifest.json` has SHA-256
`26752cb0537590aab050fdb96ebc4acb312c090f7eb023ed6ea7709330375245`
and status `DORMANT`. This source commit identifies diagnostic bytes, not a
replacement for the deployed production commit f1c8325.

The earlier compound command was rejected before execution without a stated
reason. A smaller scratch-only download/hash step succeeded. The subsequent
copy recipe initially stopped at an ordinary PowerShell `Split-Path` parameter
error; correcting that path assignment allowed the guarded copy and sidecar.
No production module, base observer, MCM file or save/config file was changed.
The diagnostic is not auto-loaded. The owner manually loaded it with
`luarun mods/open_unnerf_validation_observer/maw-ring-kill-trace.lua` and reported
`READY 4`. Four is the source's actual callback count (damage, NPC death, pickup
init and pickup update); the initially supplied expected count of five was an
instruction error. This is owner-observed registration, pending matching log
collection, and is not a kill/drop pass.

### M2 first target: player-attributed laser damage

The owner spawned one frozen, one-HP Gaper at the existing native ring's radius
in the Maw-Off run, then resumed without moving or shooting. The owner reported
summary `1 0 0 0`. Matching raw events corroborate:

- Registration at frame 138 / sequence 1, seed 1072936563, callback count 4.
- Damage at frame 139 / sequence 2: target type 10, variant/subtype 0/0,
  index 20, seed 2752254185, HP before 1, amount 3.5, flags 8, countdown 30.
  Source is player type 1, index 0, seed 1907838666, rather than a laser entity.
- Death at frame 140 / sequence 3 matches that target and previous damage,
  one frame apart. The literal direct-laser predicate is false.
- Summaries at frames 164 and 183 / sequences 4 and 5 report one damage event,
  one death, zero direct-ring-source deaths, and zero black/soul-heart inits.
- No diagnostic error or heart init/update occurred in the trace. The base
  observer also records native Dark Ring lasers with drop field 0 and spawner
  player seed 1907838666, through frame 183. These are separate observations,
  not a laser identity carried in the damage callback.

The installed primary enum declaration at `resources/scripts/enums.lua:1059`
is `DAMAGE_LASER = 1<<3`, establishing flags 8 as laser damage. This rules out a
missing damage/death match and explains why a predicate requiring source type 7
did not count this player-source event. It is consistent with owner-attributed
native Maw damage in the controlled ring setup; the raw source alone does not
uniquely identify a laser. Preserve the direct-source counter's literal meaning
and inspect source/flags, native ring observations and fixture conditions
together. Do not silently promote all player-source damage to ring attribution.
This attempt supplies no black-heart-drop or probability result.

Evidence files under the session `evidence` directory:

- `M2-firstkill-20261109T034032473Z.log`: 3,241,570 bytes, SHA-256
  `c5b10b22497e00aef89bca3783cd9c4d85a182567ec64656ea54288f76cbac96`.
- `M2-firstkill-20261109T034032473Z-raw.jsonl`: five exact JSON records, SHA-256
  `f71056ec00236101677dd35519822f33118d6208adcf568a80959038f3c79c48`.
  An auxiliary file without `-raw` contains prefixed log lines and is not a
  JSONL-object dataset; use the named `-raw.jsonl` artifact.
- Both full shared reads matched, with unchanged length and last-write time
  `2026-11-09T03:37:44.4296600Z`. No collection race was observed.

### M2 On sample: incomplete target accounting; retry preparation

The owner confirmed a fresh Normal Isaac baseline with all seven On, actual
continued false, damage 3.5, zero Maw, six red half-hearts and no soul hearts.
The new seed was printed but not transcribed; log collection later recovered it
as 3259019300. After one Maw and a native charge/release, the initial 20-point setup
stopped at its room-boundary assertion before spawning anything. A revised
inside-room-only setup reported 13 requested frozen, one-HP Gapers. The owner
reported summary `6 0 0 0`. After two more seconds without movement/shooting,
the owner reported still six deaths, no remaining enemies and no black hearts.

This sample has unresolved accounting: 13 requests are not 13 verified deaths.
The version-1 observer records damage/death only while NPC type equals Gaper
(10). Type transitions, removals or placement could explain the mismatch; none
is established as the cause. Do not count it as 13 eligible reward trials or a
failed black-heart mechanic. Preserve six as the owner-reported traced deaths,
with full eligible-target reconciliation still pending.

The subsequent stable log capture records 13 distinct type-10 damage attempts
at frame 181, target indices 27–39, all flags 8 and source entity type 1. Six
type-10 death callbacks follow at frame 182. Summaries at frames 231, 305 and
378 retain 13 damage events, six deaths and no black/soul-heart inits. Setup
reports radius 80 and drop field 0.050000000745058. Thus the evidence includes
laser-damage attempts for all requested targets; it does not establish the
unobserved targets' later types or a complete death count. The starting snapshot
records seed 3259019300, difficulty 0, actual continued false, six red half-hearts,
no soul hearts and zero Maw; saved/run settings are all On, corroborating the
owner's aggregate active-gate baseline check.

Under session `evidence`:

- `M2-on-incomplete-20261109T042538477Z-full.log`: 3,284,974 bytes, SHA-256
  `3cc6a77abb54f51c3e1695b68bb8eefe112a543d1a7c9c81e443033a32a85d71`.
- `M2-on-incomplete-20261109T042538477Z-raw.jsonl`: 24 selected records
  (two snapshots, 13 damage attempts, six deaths, three summaries).
- `M2-on-incomplete-20261109T042538477Z-metadata.json`: capture metadata and
  snapshots. Two shared reads matched, with stable length/timestamp. The bounded
  log scan found no matching Lua-error/traceback line; the earlier boundary
  assertion is separately preserved as an owner-reported console error.

Diagnostic version 2 observes all NPC damage/death plus first NPC updates and
records explicit target requests with identity/position. It retains literal
direct-laser attribution rather than treating player-source damage as a proven
ring source. Per-type death counts and first observations help investigate type
changes, but first observations are not a spawn denominator. Room background
NPCs must also be distinguished from requested targets when interpreting totals.

The contract regression failed on version 1 with `non-Gaper NPC damage was
omitted`, then passed after version 2 broadened observation. Coverage includes
player-source laser flags, NPC type changes, requested-target serialization,
always-nil callbacks, diagnostic/logger failure containment and exact cleanup
of all five callbacks. These remain stubbed diagnostic-contract checks, not
engine proof of transformations, native kills or rewards. Version 2 is not yet
staged or engine verified at this preparation checkpoint.

The next smallest retry will use one type-15 Clotty target on an inside-room
point with `GetGridCollisionAtPos == COLLISION_NONE`, checking nearby footprint
points too. Installed enums establish Clotty 15 and collision-none 0; installed
LuaDocs declare `Room:GetGridCollisionAtPos(Vector)`. They do not certify target
transformation behavior or the proposed placement recipe. Verify that smallest
engine case before increasing the sample.

### M2 version-2 staging checkpoint

Both adversarial Sol 6.1/high review axes returned zero actionable findings for
`4e6944b...eec4724716f754d7756ac62e44404f55ef856b85`. The parent verified the
published raw bytes against the local source and a no-overwrite copy. Luna then
staged the exact 8,653-byte file under the new, dormant filename
`mods/open_unnerf_validation_observer/maw-ring-kill-trace-v2.lua`, SHA-256
`23e63c7f9d9e98b9ac47c0daf1b321be446e2ad54299a0865a97e137a51150f3`.
The existing version-1 file remains intact. Frozen observer `main.lua` matched
its recorded SHA-256 before and after. Scratch `maw-trace-v2/staging-manifest.json`
has SHA-256 `c0c4e067a4369cdf23ad642eaa05d121cb50cfa3b2d31eaac67ad27bf87130da`.
Production remains f1c8325. Staging does not execute the diagnostic. The next
owner step stops v1's own callbacks and loads v2, whose five callbacks should
report `M2TRACE READY 5 v2`; engine registration and target checks are pending.

The owner subsequently confirmed `M2TRACE READY 5 v2` and state
`2 true false 4.5 1 3259019300` (fixture version, Maw gate, actual continued,
damage, Maw copies, seed). The new phase is `M2-ring-on-v2`. The owner charged
Maw normally and ran the single-Clotty setup: find a native ring, select its
first clear radial point among 72 candidates, check center and four offsets of
16 units with inside-room margin 0 and grid collision 0, remove loose tears,
spawn type 15/0/0 with one HP and freeze, and record that NPC via `RecordTargets`.
After one second without movement/shooting, the owner reported summary
`1 0 1 0` and visually confirmed a black-heart drop. That is owner-observed
output after one recorded target; raw target/death/heart provenance is being
collected before a stronger attribution or acceptance claim. No drop-rate
estimate follows from this single outcome.

### M2 version-2 one-Clotty engine evidence

The raw records corroborate the owner observation on seed 3259019300, Normal,
MCM v113. All seven active, saved and run settings are On. The phase-start
snapshot at frame 378 records damage 4.5, one Maw, cached count 1, six red
half-hearts, no soul hearts and black mask 0, with actual continued false.

- Requested target: type 15/0/0, index 704, seed 3905726384, position (400,380),
  size 13 and HP 1. First NPC observation at frame 545 records type 15,
  state 4, HP 1 and max HP 15.
- At frame 545, its one observed damage attempt has amount 4.5 and flags
  8388616, source player type 1/index 0/seed 1070000335 at (320,380).
  Native death at frame 546 matches the target and previous damage one frame
  earlier. Per-type death count is `{"15":1}`.
- At frame 546 a black-heart pickup (type 5, variant 10, subtype 6, seed
  3972237172) initializes at (400,380); first update at 547 observes the same
  identity. Spawner type/variant are 0/0; no usable direct spawner identity is
  established. Repeated observations are one pickup, not additional drops.
- Native Dark Ring observations record sprite
  `gfx/007.001.003_Dark Ring.anm2` and drop field 0.050000000745058. Summary is
  one damage event, one death, one black-heart init and no soul-heart inits.

Installed `resources/scripts/enums.lua:1079` defines
`DAMAGE_SPAWN_BLACK_HEART = 1<<23` with the lethal-black-heart meaning. Recorded
flags 8388616 equal that bit (8388608) plus `DAMAGE_LASER` (8). The lethal
damage flags, matching requested target/death, matching pickup position/frame,
native ring observations and owner-visible output support the native Maw
kill/drop path in this controlled setup. This is not a universal source
classifier or an empirical drop-rate estimate. Literal direct-laser attribution
remains false because the callback source is the player; that counter's zero
does not erase the separately recorded native flags and output.

Evidence directory under the session root:
`evidence/M2-v2-clotty-black-20261109T045954147Z/`:

- `log-fullcopy.bin`: 3,310,358 bytes, SHA-256
  `30f6ef68ee8b57c8d280d2a6d43c7a8c5606dfb852d25df1f06e04550e821804`.
- `phase-raw-jsonl.jsonl`: SHA-256
  `5f4ec9a317063d0ded2a4c69bb69d5ac3865e16659ce56029fb6bdd06e60f50d`;
  the 301-record selection includes historical snapshots and v1 cleanup as
  context. Select label `M2-ring-on-v2` and fixture version 2 for native events.
- `exact-raw-jsonl.jsonl` and `verification-metadata-final.json` contain the
  detailed selection/verification. The earlier zero-byte
  `verification-metadata.json` is an invalid artifact from a locked-file hash
  attempt and must not be used.
- Three shared-read captures match the full-copy hash/length, with source mtime
  2026-11-09T04:53:48.3807974Z. No diagnostic error, Lua error or traceback was
  found in the scanned span. Locked-file hashing used the already matching
  shared-read bytes, not an assumed success from `Get-FileHash`.

Before continuing this saved run, stop the native trace so reinitialized room
pickups cannot be counted as new drops. Continue/item-cache checks remain a
separate phase; the black heart is left uncollected at this checkpoint.

### M3 held-Maw Continue and removal (owner observed)

After stopping the native trace, the owner saved to the main menu and continued
the same run. The phase `M3-maw-continue` printed
`true true 4.5 1 1 3259019300`: actual continued true, Maw gate true, damage 4.5,
one Maw, cached count 1 and unchanged seed. The owner then called
`Isaac.GetPlayer(0):RemoveCollectible(399)`, allowed update frames and reported
`M3 REMOVED 3.5 0 0` (damage, copies, cached count). Matching log preservation is
pending. The native kill trace was stopped before Continue, so reconstructed
room pickups are not new reward trials. This records held-item continuation and
removal for this local Normal Isaac; distinct-player and pack-absent checks
remain separate.

M3 log corroboration: snapshot `start` at frame 622 / sequence 12694 records
damage 4.5, copies/cached copies 1/1; `M3-maw-removed` at frame 694 / sequence
12767 records damage 3.5, copies/cached copies 0/0. Both have seed 3259019300,
difficulty 0, observed continued true, MCM 113, six red half-hearts, zero soul
half-hearts and black mask 0. All seven saved run settings are true. A matching
`[Continue, 2]` seed entry and game version J460 appear in the log. The expected
separate automatic `post_game_started` record was not present in the extracted
probes; the snapshots' observed-continued field and native Continue entry are
the available evidence. No bounded Lua error/traceback/diagnostic error was found.

Evidence directory under the session root:
`evidence/M3-continue-remove-20261109T062404Z/`:

- `log-full.txt`: 3,352,642 bytes, SHA-256
  `b997d1f8dfbe099da0b6021b094725481dabeb02c18c9dca988818510a0f1e8b`.
- `M3-probe-payloads.jsonl`: 74 labeled records including both snapshots,
  SHA-256 `d911d46ad419b7cf7d0205add17a9a78ae5bc7ef23e6fe49a0fa9aa2efb09df9`.
- `metadata.json`: shared-read capture details. Both full reads matched length,
  mtime and hash. Evidence stops at the removed snapshot; later actions require
  their own observations.

### M4 two-actor Maw isolation (owner observed, Hard)

The owner initially stopped at the locked Jacob & Esau menu entry without
running the console command. Trying documented `restart 19` directly then
produced two actual players, types 19 and 20. The first grant setup stopped
before granting anything because the run's difficulty was 1 (Hard), whereas the
proposed guard expected Normal. Read-only preflight confirmed difficulty 1,
Maw On, and zero Maw copies for both actors. The isolation check continued in
that observed Hard mode; no difficulty/unlock/save-file edit was performed.

The revised setup recorded each actor's actual damage as `OUPMawBase[0/1]`,
started probe `M4-maw-players` and added one Maw to Jacob using
`Isaac.GetPlayer(0):AddCollectible(399,0,false)`. Each transition allowed one
second of native updates before Snapshot. Owner-reported results:

| Checkpoint | Jacob / Esau damage delta | Maw copies | Cached copies |
| --- | --- | --- | --- |
| baseline | 0 / 0 | 0 / 0 | log corroboration pending |
| M4-jacob-only | 1 / 0 | 1 / 0 | 1 / 0 |
| M4-both | 1 / 1 | 1 / 1 | 1 / 1 |
| M4-esau-only | 0 / 1 | 0 / 1 | 0 / 1 |
| M4-cleared | 0 / 0 | 0 / 0 | 0 / 0 |

The sequence used explicit player-index grants/removals and supports isolation
between these local Jacob & Esau actors. It is not a general network/local
co-op certification. Matching raw log, actor baselines, seed and all gates are
being preserved before another feature is granted. The run remains open with
both Maw copies removed; the numeric baseline helper is diagnostic state only.

M4 raw corroboration: seed 1273441713, difficulty 1, observed continued false,
MCM 113; all seven active/saved/run settings agree and are On. Jacob (index 0,
type 19) has baseline damage 2.75 and health 6 red/0 soul half-hearts. Esau
(index 1, type 20) has baseline damage 3.75 and health 2 red/2 soul half-hearts.
Health and black masks remain unchanged throughout the cache sequence.

| Checkpoint | Sequence / frame | Jacob / Esau damage | Maw / cached counts by actor |
| --- | --- | --- | --- |
| preflight | 12812 / 358 | 2.75 / 3.75 | 0/0 and 0/0 |
| Jacob only | 12814 / 412 | 3.75 / 3.75 | 1/1 and 0/0 |
| both | 12815 / 484 | 3.75 / 4.75 | 1/1 and 1/1 |
| Esau only | 12816 / 523 | 2.75 / 4.75 | 0/0 and 1/1 |
| cleared | 12817 / 562 | 2.75 / 3.75 | 0/0 and 0/0 |

Evidence under `evidence/M4-two-actors-20261109T145514952Z/`:

- `log-full-copy.bin`: 3,383,620 bytes, SHA-256
  `da953d3781021a9323ea7fb3b21fad8e867a6698276bd81bf1ef2999dbbcbb9c`.
- `probe-objects.raw.jsonl`: SHA-256
  `e7359281185e5e288404ed3fbb5bc7578dc412ef88d2f162cd22b12ec11df519`.
  This is the full 12,817-object extraction, with zero exact duplicates; filter
  by the M4 labels and actual seed for the checkpoint subset.
- `metadata.json`: SHA-256
  `775c0bf2d329a07f6aee4c4b45aff957a6e016188726f1c103aae3c3bdaa8c40`.
- Both shared reads matched length, mtime and hash. No bounded Lua error,
  traceback or diagnostic error was found. Automatic `post_game_started`
  sequence 12811/frame 0 retains the prior M3 label but has the new M4 seed,
  Hard difficulty and observed continued false; it is context, not a continued
  M3 result. Historical Maw kill-trace entries are not M4 events.

The owner requested a sensible test budget rather than individual prompts for
every case. Remaining work will reuse this Maw evidence and #3's native gate
comparisons, with short automated engine batches for unresolved high-risk
orbital behavior, Relic cadence and fire stacking/probability. Unexecuted edge
cases remain explicitly unverified rather than becoming manual prerequisites.

## Shared observer protocol (deployed; initial snapshot engine verified)

Source: `tools/compatibility-observer.lua`, adopted unchanged by #3. It is not
loaded by production `main.lua`; the shared validation installation loads these
exact bytes as the separate `open_unnerf_validation_observer/main.lua` mod.
The approved hash and verified installation are recorded above, and C1/M1/O1
exercise its initial snapshot path. No additional staging or `luarun` is needed
for that installation. Do not reload production modules via `luamod`.

The established console protocol below is a reference for future bounded
sessions, not an instruction to run commands or deploy again now. Only the
explicit session owner may issue the next test sequence:

```lua
lua OUPProbe.Start("TEST-LABEL", "ACTUAL_DEPLOYED_SHA", "fresh")
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
| Maw cache/damage and per-player isolation | Single-copy On/Off, two-copy handling, held-item Continue/removal and Hard Jacob/Esau isolation corroborated | Pack-absent comparison remains open; local/network co-op generally is not certified. |
| Maw ring/black-heart drops | Native ring field 0.05 On / 0 Off and one controlled one-Clotty native black-heart output corroborated | Pack-absent comparison remains open; the single output is not an empirical probability estimate. |
| Orbitals/native state | Independent Dagger acquisition and doorway/BFFS/Continue fields; controlled native contact On 30/60 damage attempts versus pack-absent 15/30 without/with BFFS; native Meat variants 44/45 On damage 14 / size 13 versus absent 7 / 8 | Representative field/contact behavior corroborated; fixed DPS, every orbital variant and every native transformation are not certified. See [native batches](native-batches.md). |
| Dark Bum/output/exclusions | Independent gate-Off native pills remained unchanged; On six familiar-attributed native payout chains became soul hearts for Isaac | [Configuration results](configuration-results-1.9.7.17.md) retain exact provenance and Morph identities. Excluded characters, general payout variants and output rates remain unverified; this was a gate-Off control, not pack-absent. |
| Relic timing | Off 0 / On 2 initialization; pack-absent Hard payout observed at seventh clear, absent Normal no payout in six clears; enabled Normal P2 payout at fifth clear, reset 6→2, then three further increments on the same familiar | Representative earlier payout/reset corroborated. Exact universal intervals, second payout cycle, multiple Relics and held-item Continue remain unverified. See [native batches](native-batches.md). |
| Hard/Normal blue/purple fires | Enabled Hard B6, absent Hard V2, absent Normal V3 and enabled Normal P1 each completed 200 eligible trials per variant; six enabled Hard doubles are distinct pickups, no Normal doubles observed | Mode-specific samples and actual stacking are recorded in [native batches](native-batches.md). Exact rates, repeated/nonlethal-hit behavior and universal pickup caps are not certified. |
| Humbling Bundle | Independent gate-Off single penny stayed single; On key, four pennies and bomb converted in native chest contents; half-heart and already-doubled contents distinguished | [Configuration results](configuration-results-1.9.7.17.md) retain the six conversions. Full-red-heart conversion, other reward sources and co-op remain unverified; this was a gate-Off control, not pack-absent. |
| Stomp immunity | Actual Mom/Host Hat independent Off health 6→4 versus On 6→6 on current f1; synthetic engine Pyromaniac crush absent 4→2 versus On 4→6 | Native Mom/Pyromaniac and other stomp sources remain unverified. [Configuration results](configuration-results-1.9.7.17.md) and [native batches](native-batches.md) retain distinct inputs; historical [issue #2](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/2) is not generalized or closed. |

Preparation alone cannot justify a checkbox or issue closure. Actual commands,
observed values, timestamps and log references above justify only the bounded
results identified in the matrix.

Tracker checkpoint after C1/C3/C4 and M1 evidence: the fresh/continued-run
criterion in #1 is checked; all other acceptance boxes remain unchanged and the
issue remains open. Published result:
https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/1#issuecomment-6723715489

The initial results branch was `issue-1-engine-validation`; its evidence and
shared observer were subsequently integrated through PRs #9–#11. Remaining
batch work is on `issue-1-batched-validation`. Production deployment remains
the recorded f1c8325 source despite those later documentation/tooling commits.

## Subsequent bounded batches (release one at a time after M1)

This section preserves historical proposals. Later M2–M4 records and the current
acceptance matrix supersede its pending labels. Do not send the whole list as an
owner sequence. Establish each smallest case in-engine before broader execution.

- **M4 distinct-player Maw cache (prepared, not executed):** after preserving M3,
  the owner reported Jacob & Esau are not unlocked, so this route has no
  validated actor baseline. Whether the console command itself was attempted
  or refused is being clarified; no unlock/progression change is authorized.
  A native temporary-companion alternative is being researched separately.
  The following remains a proposed route, not an engine result:
  a new disposable normal Jacob & Esau run can provide two local actors. Installed
  enums identify Jacob 19 and Esau 20. The primary
  [IsaacDocs console reference](https://wofsauge.github.io/IsaacDocs/rep/tutorials/DebugConsole.html)
  documents `restart` with an optional character number, and its
  [PlayerType enum](https://wofsauge.github.io/IsaacDocs/rep/enums/PlayerType.html)
  corroborates those IDs. This supports proposing `restart 19`, not claiming it
  was executed on the target build. The smallest engine check must verify two
  players, actual types 19/20, Normal difficulty, all gates On, and no Maw copies
  before accessing index 1 or granting anything. If prerequisites differ, stop;
  do not modify unlock/progression data. Record each actor's actual damage
  baseline rather than assuming character stats. The installed player API
  declares `AddCollectible(Type, Charge, AddConsumables)`; use all three arguments
  explicitly, such as `Isaac.GetPlayer(0):AddCollectible(399,0,false)`. Verify the
  count sequence (0,0) → (1,0) → (1,1) → (0,1) → (0,0), with respective damage
  deltas (0,0) → (1,0) → (1,1) → (0,1) → (0,0), after actual update frames. Match
  snapshots/cached counts to each index and type. This tests these local actors;
  it does not certify local/network co-op generally. The native kill trace stays
  stopped throughout this cache-only phase.

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
