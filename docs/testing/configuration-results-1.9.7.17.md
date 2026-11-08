# Issue #3 engine validation — Repentance+ 1.9.7.17

## Session ownership and provenance

Issue #3 owns the initial shared Mafia-Server installation and first interactive
MCM/persistence batch. Issue #1 may collect files/logs read-only and prepare its
recipes; it receives explicit ownership before any conflicting console or
run-state changes. One owner, one installation, one active sequence.

- Source selected: integrated `f1c83253af3636816c3b83c6ab28d2221ad345ea`
  (includes configuration PR #5, compatibility PR #6, stomp fix PR #7).
- Deployed production SHA: `f1c83253af3636816c3b83c6ab28d2221ad345ea`;
  setup-input commit: `98ac21c31e4cbc00c3d9b2e1ea13ed9960e76cfe`.
  All 38 installed file hashes independently match the prepared manifest.
- Game target: Repentance+ `1.9.7.17`; previous title screenshot and executable
  string `1.9.7.17.J460` establish version, not mod compatibility.
- Actual installed MCM: Pure v113, source
  `a4c15349c8ed8c38f31bf45bdf5d2896f4e9d23d`; installed script declares
  `local VERSION = 113` and `ModConfigMenu.Version = VERSION`.
  UI/input still pending owner observation.
- Owner confirmed game closed and authorized reversible preparation.
- No engine pass is inferred from the merged implementation or Lua harness.

## Result matrix

Record timestamps, seed/save slot, fresh/Continue, active and next-run choices,
vanilla/modded state, exact commands, log artifact and owner observation per row.
Use `pending`, `pass`, `fail`, or `inconclusive`; never infer a drop-rate result
from one random outcome. Nail and Satanic Bible remain disabled and unexposed.

| Case | Setup and required observation | Result | Evidence |
| --- | --- | --- | --- |
| MCM present | Recorded build + actual MCM Pure version; fresh disposable Isaac run; F10 → Open Unnerf Pack → Unnerfs; exactly seven On controls, no Nail/Bible | pass (UI/defaults only) | Owner confirmed all seven On and new-run notice; fresh C1 log loads v113 |
| Deferred choice | Set Maw Off in MCM; current active run remains On, next-run choice is Off | pass for deferral and persisted pre-relaunch state | Owner reports `Maw active: true` after setting only Maw Off |
| Relaunch + Continue | Exit to desktop, relaunch, Continue same seed; Maw menu Off but active run still On | pass (owner + log corroboration) | Owner confirms Maw Off and `C3 true true` after relaunch/Continue slot 2 |
| New-run boundary | Fresh Isaac run after saved Maw Off; active Maw Off, other six On | pass (owner + saved-file/log corroboration) | Owner reports `C4 false false` in new Normal Isaac run |
| MCM absent | Close game; reversible MCM-only disable; relaunch/new run; pack uses saved Maw Off | pass (owner + fresh log/save corroboration) | Owner reports `C5 true false false`; no MCM Lua-script execution/errors; saved choice retained |
| MCM restored | Close game; restore same MCM version; controls available | pass for restore, defaults from deliberate malformed fixture | C7 MCM v113 + seven-On UI; original valid config restored separately before C8 |
| Slot isolation | Two disposable save slots retain distinct next-run choices and Continue snapshots without Lua reload | pass, distinct-seed engine case | C8 owner outputs + one-process log + separate save2/save3 JSON |
| Missing/malformed data | Missing/truncated JSON in-engine; unknown schema/invalid field harness coverage | pass for exercised fallback cases; no exhaustive engine claim | C6/C7 owner queries, UI, exact fixtures, generated valid data, no Lua errors |
| Maw disabled independently | Fresh Isaac, only Maw Off; `giveitem c399`; baseline damage stays 3.5, remove restores 3.5; no pack ring drop chance; compare On and pack-disabled control | pending | |
| Orbitals disabled independently | Fresh run only orbitals Off; `giveitem c73`; record actual size/damage and stable updates against pack-disabled control; six other gates On | pending | |
| Stomp disabled independently | Fresh run only stomp Off; `giveitem c375` then separate `giveitem c223` setup; real stomp compared with vanilla; six other gates On | pending | |
| Bundle disabled independently | Fresh run only Bundle Off; `giveitem c203`; naturally selected pickups compared with vanilla (forced pickup spawning is not selection evidence) | pending | |
| Dark Bum disabled independently | Fresh Isaac only Dark Bum Off; `giveitem c278`, repeated `spawn 5.10.1` at full red health; payouts compared with vanilla | pending | |
| Relic disabled independently | Fresh run only Relic Off; `giveitem c98`; record initial/count/payout behavior and compare vanilla | pending | |
| Hard blue fires disabled independently | Hard fresh run only fires Off; blue/purple fires bombed; no pack-added spawn path; compare controlled engine evidence and sufficient vanilla sample | pending | |

The disabled-feature rows require evidence of the affected mechanic and enabled
controls, not merely a saved boolean or a harness return. Common Maw/fresh/Continue
results may be reused by issue #1 only at the same deployment and settings.

## First owner sequence (deployment prerequisite pending)

After the exact package, backups and actual MCM version are recorded, ask the
owner to launch normally, choose a disposable fresh Isaac run, press F10 and open
Open Unnerf Pack → Unnerfs. Ask only whether all seven controls appear On and the
new-run notice is visible. If missing/error, stop and collect the game log rather
than asking the owner to reinstall or hunt items. Do not reset an active run
without coordinating the transition.

## Cleanup

Deployment must record backups before changing the pack, MCM, diagnostic mod or
relevant options. Preserve unrelated mods and progression. Restore each original
file/absence from its backup manifest when validation ends; remove only the
session-created diagnostic/staging deployment, not an owner's existing mod.

## Preparation evidence (2026-11-08)

Read-only Windows inventory found no installed pack or MCM at this session's
start; the only mod directories were `external item descriptions` and
`Visible Tinted Rocks with yellow mark`, both with `disable.it`. Isaac was closed.
`EnableMods=1` and `EnableDebugConsole=1`; the setup does not change them.

The main Sol agent exercised `tools/validation/build_test_package.py` end-to-end
on Linux using the shared observer from issue #1:

```sh
python3 tools/validation/build_test_package.py \
  --observer ../issue-1-repentance-plus-compatibility/tools/compatibility-observer.lua \
  --output /tmp/ounp-validation-f1c8325.zip
```

- 38 runtime files; every packaged byte matched the pinned source archive or
  reviewed observer input. This checks packaging, not Isaac loading or gameplay.
- Pack archive SHA256: `2dc39b6a1c40949e717370659abf379967364e6cd505ac1207fbc02a311f804b`.
- MCM archive SHA256: `ca11293b13f7f8ff1bc2229a6796631005fa7fcc0141d59963d2469633cc808e`.
- Package SHA256: `971aacb895cae5f1c08107ab07b4e33820c68ed21a7407c2d3ddf99653d0a471`.
- Observer SHA256: `aea0ac0b0098c29aeb8c5bbe1a73447ee0fd721c085baa2dcd99cd539ec2a7db`.
  It is a separate optional mod; it reads settings/entities and logs observations,
  never grants items, changes stats/config, suppresses damage, or writes mod data.
  The SHA label supplied to `OUPProbe.Start` is operator provenance, not runtime
  cryptographic attestation. Installation hashes provide the byte evidence.

The parent-authored Windows deployment recipe is
`tools/validation/deploy-test-build.ps1`. It rejects a running game and existing
session destination folders, verifies archives and all runtime bytes before any
game mutation, backs up the user-data and existing mod-data directories, and
copies only three new mod folders. Actual execution/result is recorded below
when received. Existing mods/markers and options are left untouched.


## Windows installation result — 2026-11-08 15:22Z

The verified recipe completed successfully using local Windows PowerShell.
Luna independently counted 38 manifest entries and rechecked all 38 installed
hashes; observer hash matches the immutable input. Isaac remained closed.
This is an installed-source check, **not** an engine pass.

Session root:
`C:\Users\Mario\.t3\scratch\ounp-issue3-validation-f1c8325-20261108`.
The `installed-manifest.json` records the exact runtime file map. Backups are
`backup/repentance-plus-user-data`, `backup/game-mod-data`, and `backup/before.json`.
The existing two disabled mod markers retained their zero size and timestamps.
No options or original save files were edited by deployment.

Transport attempts using a cross-environment encoded payload did not execute:
the Windows runner rejected `functions.exec` as unsupported. No game files
changed during those attempts. The successful path downloads the same exact
inputs by commit-pinned GitHub raw URLs and executes the parent-authored recipe.

First interactive prompt issued: launch a disposable fresh Isaac run, F10 →
Open Unnerf Pack → Unnerfs, report seven On controls/new-run notice. No setting
change or gameplay result has yet been received. Do not reuse the predeployment
log mentioning old `issue2_baseline`/`issue2_candidate` paths as this run's evidence.

## C1 screenshot observation — owner F10 screen

Owner supplied attachment
`mcp-launch-2545dcca6e3f89e10f10418b60b03bf4e2c9385f1c81f5299e71595404d8b356-6d679ce3-db26-412d-88c3-c5d3bcdc209a.png`.
Terra (`gpt-6.1-terra`, xhigh) inspected it under the repo's visual delegation
rule. It shows MCM's category picker: General selected, Mod Config Menu second,
Open Unnerf Pack third. No error text is visible. The pack's seven controls and
new-run notice are not on the currently selected General screen; neither their
presence nor absence is established by this image.

Assessment: MCM renders and the pack category is registered in-engine. The
full controls/defaults criterion remains pending. Next owner instruction:
Down twice, Enter, select Unnerfs if presented, leave controls unchanged and
report all seven states plus the new-run notice. No setting has been changed by
an agent; no persistence or gameplay pass is inferred.


## C1 initial UI/defaults — engine observation

Owner navigated into Open Unnerf Pack → Unnerfs and explicitly confirmed:
"Yes—all seven On and the notice is visible." This establishes the first-install
UI/defaults on this deployed build. It does not establish change application,
relaunch persistence, disabled mechanics, or MCM-absent behavior.

The fresh log copied at 2026-11-08 15:25:15Z is
`evidence/C1-initial-log.txt` under the Windows session root, 16,547 bytes,
SHA256 `6672ae5357afcd230f51b8f930fda1c2799d1cf5d4663d9cdd19dd56be64e8d7`.
It records all three deployed mod scripts and MCM v113 loaded, followed by
`RNG Start Seed: AHF4 DXT0 (237297203) [New, 2]`. No Lua error, exception or stack
trace appears in the copied log. The prior-run mod-state refusal messages precede
the new run and are not a Continue result for this deployment.

Pack data now exists at
`D:\The.Binding.of.Isaac.Repentance.v4.0.2\data\open unnerf pack\save2.dat`
(312 bytes). Slot 2 is therefore the observed pack save target. No pack data
contents have yet been assessed. First parent-designed observer smoke command
issued to the owner:

```lua
lua OUPProbe.Start('C1-initial','f1c83253af3636816c3b83c6ab28d2221ad345ea','fresh')
```

Expected signal is an OUP_PROBE snapshot. This tests the actual observer API path
on the smallest case; result is pending. No toggle/item manipulation precedes it.

## C1 observer smoke — pass for the read-only snapshot path

The owner could not read the console because the snapshot exceeded the screen.
Read-only log collection recovered exactly one C1-initial record (914 bytes),
not a stream of repeated errors. There were zero subsequent C1 probe lines and
no error/exception/stack-trace lines after it in the captured log.

- Snapshot: frame 4212, seed 237297203, difficulty 0 (Normal).
- Actual observed run-start callback: `runStartObserved=true`,
  `continuedObserved=false`; independent of the operator's `fresh` label.
- Player: type 0 (Isaac), damage 3.5, zero Maw copies, six red half-hearts,
  zero soul half-hearts, black-heart mask 0; no familiars.
- Runtime MCM: `present=true`, `Version=113`.
- Active gates, saved next-run settings and saved run settings: all seven true.
- Saved schema version 1; snapshot seed matches current seed 237297203.

Artifacts under the Windows session's evidence directory:
`C1-observer-start.jsonl`, `C1-observer-start-log.txt` (17,916 bytes,
SHA256 `ed5ffc72353620f90a0bd5019ddb4055287e982aae31ea1b9ea018f47946282f`),
and `C1-pack-save2.dat` (312 bytes,
SHA256 `c994073bfb9002db42ecaf836667160a68fc181f2619610049853a09afbcc2b1`).

Assessment: first smallest observer API path works in-engine. It establishes a
fresh-run/default baseline and source for later comparisons, not any unnerfed
item behavior. Future owner steps need not read verbose JSON; the agent collects
it from the game log. A short current-state query was issued after instructing
the owner to change only Maw's next-run choice Off:

```lua
lua print('Maw active:',openUnnerfPack.Config.IsEnabled('mawOfTheVoid'))
```

Expected true in the existing run; outcome pending. Other six choices stay On.


## C2 deferred Maw choice — owner observation

After setting only Maw of the Void Off in MCM and leaving the other six On,
the owner reported the short query printed `Maw active: true` in the same run.
Assessment: current-run deferral is observed in-engine. Saved next-run choice
and continued-run preservation will be cross-checked against the pack data and
relaunch; no disabled-Maw gameplay claim follows from this query.

Owner instructed to save and exit completely, then stop before relaunch so the
pre-relaunch log/config can be preserved without a log-overwrite race. This is
an intentional transition of the disposable slot-2 test run, not an agent-driven
reset of an unrelated run. Continued seed expected: 237297203.


## C2 closed-game persistence checkpoint — confirmed state

Owner confirmed normal save and exit to desktop. Luna verified no Isaac process
and preserved separate C2 artifacts before the next launch. Actual save2 schema1:
next-run Maw=false, run-snapshot Maw=true, all other six=true in both, seed237297203.
This demonstrates persisted active-vs-next-run separation after exit. It does not
yet prove reloading/Continue.

`C2-pack-save2.dat`: 313 bytes, source/copy mtime 2026-11-08 15:33:13.549Z,
SHA256 `750958afa7e06901adf8faba6c005f7cb08600a7e70aaffd6821dc7d746fbea5`.
`C2-before-relaunch-log.txt`: 30,142 bytes, mtime 15:33:16.034Z,
SHA256 `ccf38bb33afb328eb77f97bb3ab4823b696060a7238c0c5adc1dfad91c5aba85`.
No Lua error/exception/stack-trace matches after the C1 snapshot. The short print
was observed directly by the owner; it is not present in the copied log.

Next instruction: relaunch, select slot2, Continue, check menu retains MawOff,
then run the following read-only short query (expected `C3 true true`):

```lua
lua print('C3',openUnnerfPack.Config.IsEnabled('mawOfTheVoid'),OUPProbe.continuedObserved)
```

No source/mod deployment changes occur across this transition. Outcome pending.

## C3 relaunch + Continue — owner-observed pass

Owner relaunched, selected Continue in slot2, and explicitly reported:
"Yes—Maw Off in menu, C3 true true." The first true is the current Maw gate;
the second is the observer's actual continued flag. The Off preference survived
relaunch while the matching continued-run snapshot retained MawOn. Current
launch log/seed and absence of errors will be corroborated in the next collection;
this observation alone is not a generic gameplay compatibility pass.

Next transition is within the same process (preserving the current log): return
to main menu and start a new Normal Isaac run in slot2. Keep only MawOff. No
item grants or other gameplay changes precede the fresh-run boundary query:

```lua
lua print('C4',openUnnerfPack.Config.IsEnabled('mawOfTheVoid'),OUPProbe.continuedObserved)
```

Expected false,false; current outcome pending. Owner asked to leave the fresh
run open and item-free for the shared compatibility handoff.


## C4 fresh-run boundary — owner-observed pass

Owner returned to the main menu and started a new Normal Isaac run in slot2,
then reported `C4 false false`. The current Maw gate is false and the observer
saw a fresh-run callback (continued=false). No items have been taken. Other six
choices were left On throughout the sequence. A read-only combined C3/C4 log and
pack save capture is underway to record the new seed, persisted snapshot and
errors before handing session ownership to issue #1.

Assessment: new-run application is observed, completing the initial present-MCM
UI/defaults → deferred choice → save/exit/relaunch/Continue → new-run sequence.
Maw-disabled item behavior, MCM absence, slot switching, malformed data and the
remaining six disabled mechanics are still pending; no issue closure follows.

## Deferred owner request — reusable validation workflow

The owner explicitly liked this interactive workflow, including the question
tool, and requested a durable context note for making it a repo workflow later.
Generalization is deferred; the active engine validation remains the priority.
Capture the small-step/result-choice pattern, exact console commands, automatic
log extraction (no owner scrolling), immutable build/manifest, backups, read-only
observer, evidence matrix, current mandatory agent roles and explicit shared
session handoffs. Preserve the distinction between observed engine facts and
unmet gameplay criteria. A separate deferred tracker note records the current
proof-of-concept paths, provenance and Windows transport lessons.


## C3/C4 corroboration and explicit session handoff

The captured relaunch log records seed237297203 (`AHF4 DXT0`) `[Continue, 2]`,
then seed3112725348 (`03XT KGK9`) `[New, 2]`. It loads the same three deployed
mods and MCM v113. No Lua error/exception/stack-trace lines were found. Four
informational mod-state refusal notices reference the unrelated slot-3 rerun
state before the valid slot-2 Continue; they are not a failure of this Continue.
The short C3/C4 prints are owner observations, not present in the log.

Current saved schema1: next-run Maw=false and fresh-run snapshot Maw=false;
other six=true in both; new seed3112725348. Combined with the owner's C3 true,true
and C4 false,false, this corroborates the initial MCM/persistence/boundary batch.
It does not prove affected item behavior or remaining acceptance criteria.

Artifacts under the session evidence directory:

- `C4-continue-and-newrun-log.txt`, 27,869 bytes, mtime2026-11-08 15:37:18.068Z,
  SHA256 `4240614951110764275bf25b0571d04a7fe948d42928a5388406b436970e886c`.
- `C4-pack-save2.dat`, 315 bytes, mtime15:37:01.662Z,
  SHA256 `7739b8a81112f997bcdc673856198f7b95aba95d7102cfc469d589d43fc9890d`.
- Installed-manifest SHA256
  `2610e74bda40aa237d00a066f9b722e3693a34c6e0daefe7fbda7d8489c1b475`;
  source/package/MCM/observer fingerprints remain unchanged.

Explicit ownership transfer: issue #3 → issue #1 for the next bounded Maw
acquire/remove comparison batch. Current owner state: fresh Normal Isaac,
slot2, seed3112725348, MawOff active/next-run, other six On, no items taken;
run remains open. Issue #3 will issue no competing game prompts or shared-file
mutations while #1 holds ownership. #1 must return ownership explicitly before
#3 performs MCM-absence, fallback or slot-switching tests. Backups remain intact.

Deferred workflow reuse is recorded in
[issue #8](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/8).
This records the owner's request; no generalization work is started during the
active validation session.

## Shared M1 Maw-Off damage comparison — issue #1 owns session

Issue #1 reports owner observations corroborated by corrected log extraction:
Normal Isaac damage/Maw copies `3.5/0 → 3.5/1 → 3.5/0` across acquisition/removal.
Active, saved next-run and saved run Maw gates are false; the other six gates
are true. The three snapshots share actual observed seed1299135721.

This seed differs from the C4 handoff seed3112725348. Treat M1 as a distinct
observed run; do not attribute the change to a product defect, invent its cause,
or claim C4 and M1 are the same run. The three matched M1 snapshots still support
the narrow conclusion that the pack adds no Maw damage while its gate is Off.
Black-heart ring behavior, vanilla control and other enabled mechanics are not
established by this stat comparison.

Artifacts under the same Windows session evidence directory:
`M1-off-log.txt`, SHA256
`a7d5634cf0de9949eb0a462757f4abdc5bd1c543380b736f8500c9145a79d373`;
corrected M1 JSONL, SHA256
`4a21fa22d8541a1a2de14fe9b9e4c76593443076b1c13303f0f74b817b983ba0`.
The initial extraction used an incorrect label/regex; issue #1 corrected it
against preserved log bytes without game changes. This was an extractor fault,
not engine evidence of a product failure.

Issue #1 retains ownership through the bounded On comparison: set MawOn while
leaving the other six On (all seven On), start a new Normal Isaac run, acquire
and remove Maw, capture matched observations, then explicitly return ownership.
No deployment changes or competing issue #3 owner prompts are authorized while
that batch runs.

## Shared M1 Maw-On comparison and session return

Issue #1 explicitly returned session ownership after preserving final evidence.
Valid fresh On snapshots (sequence6/7/8) share seed2406764967:
damage/Maw copies `3.5/0 → 4.5/1 → 3.5/0`, cached copies0/1/0. Combined with the
matched Off run's `3.5/0 → 3.5/1 → 3.5/0`, the engine comparison demonstrates
independent Maw damage gating and correct acquire/remove stat reevaluation.
Ring/drop behavior and a pack-disabled vanilla control remain outstanding.

Excluded evidence: M1-on start sequence4 was labeled before the new run, on
old Off seed1299135721, with activeMaw=false but next-runMaw=true. It is a valid
boundary observation but NOT an On gameplay snapshot. Use only actual active
On sequence6/7/8 for the On comparison; no product defect is inferred from a
premature operator label.

Final artifacts under Windows session evidence:
`M1-final-log.txt`, SHA256
`978dbbaf40710f9dafde95808e71914f648c65ebc37c44ceaf45ab714fe2d9f2`;
`M1-final-snapshots.jsonl`, SHA256
`e1cdcf96892a41754ff669406863d2e7028e1e1dc20f04f87ab7c4504ca6077b`.
Seven unique records were preserved with no source race or bounded Lua-error/
traceback matches. Observer/package/source remained unchanged.

Returned current state: fresh Normal Isaac slot2, seed2406764967, all7 active/
saved/runOn, damage3.5, Maw count0, redhalf6, soul0, blackmask0, no familiars or
items. Observer active labelM1-on, latest checkpointM1-on-removed sequence8/frame132.
Issue #3 now owns the next MCM-absence/fallback/slot-isolation batch; #1 has no
competing prompts or shared mutations. Concrete next transition: owner sets
MawOff only (six others stay On), saves/exits and waits. Only then may the MCM
folder's reversible disable marker be changed and recorded before a fresh run.

## C5 MCM-absence protocol — setup in progress

Owner set MawOff only, left the other six On, saved and fully closed Isaac.
Issue #3 instructed Luna/medium to preserve separate C5 preabsence log/save2
copies, verify the closed process, and create ONLY a zero-byte
`mods/mod_config_menu_pure/disable.it` marker after asserting original absence.
The marker's path, prior absence, timestamp and unchanged pack-save hash must be
recorded in C5-mcm-disable-marker.json before asking for a new launch.

The pack and observer remain enabled; no source, options or progression data is
changed. The saved current run remains the preceding MawOn run; the saved
next-run preference should be MawOff. Actual values will be recorded from the
closed-game checkpoint, not assumed.

After marker confirmation, owner will launch a NEW Normal Isaac run in slot2,
not Continue across the intentional mod-set change. The planned short query is:

```lua
lua print('C5',ModConfigMenu==nil,openUnnerfPack.Config.IsEnabled('mawOfTheVoid'),OUPProbe.continuedObserved)
```

Expected true,false,false: MCM global absent, saved nondefault MawOff choice
applied, new-run callback observed. Confirm the other six gates and error status
from pack-only saved data plus fresh log. A marker/source inspection alone does
not pass MCM absence. Restoration later removes ONLY the marker created by this
session while the game is closed; no unrelated mod markers are touched.

## C5 preabsence checkpoint and reversible marker — confirmed files

Luna verified Isaac closed and preserved C5-preabsence-log.txt (71,055 bytes,
SHA256 `5d8778b3871afaddd4b3f76c6609abed42e2339d3506234d5987379b51d5c569`)
and C5-preabsence-save2.dat (314 bytes,
SHA256 `a3fd3688d6abd5ed1e70bc28044092d1e388a5e8068e06b087ab1e3141597cf8`).
Actual schema1 has next-runMaw=false, runMaw=true on seed2406764967, six others
true in both. Pack save hash was identical before and after the marker change.

MCM-only marker created at2026-11-08 16:06:44.242Z:
`D:\\The.Binding.of.Isaac.Repentance.v4.0.2\\mods\\mod_config_menu_pure\\disable.it`,
zero bytes, verified previously absent. Evidence C5-mcm-disable-marker.json
records session ownership and original absence. Original other-mod markers
retained their baseline timestamps; pack/observer have no disable markers;
options and pack data were not changed. Game remained closed after setup.

Owner will now launch a NEW Normal Isaac run in slot2 and issue the planned
C5 short query. Actual MCM-global absence and saved-choice loading remain
pending; file disabling alone is not acceptance evidence.


## C5 MCM absent — owner observation

Owner launched a NEW Normal Isaac run in slot2 with only the MCM disable marker
changed and reported `C5 true false false`: ModConfigMenu is nil, the pack's
current Maw gate is false, and the observer recorded continued=false. This
shows that the pack's nondefault saved choice applies without MCM in-engine.
Fresh-log/error and complete saved-state corroboration will be captured after
normal save/exit before the next launch. No item-behavior claim follows.

Next planned fallback cases are concrete pack-config fixtures, not progression
edits: preserve C5 log and pack data; while closed move aside only pack save2.dat,
then start a fresh run to check defaults with missing data; preserve that result,
close, restore MCM and stage malformed JSON for the pack only; check safe default
loading, then restore the preserved valid pack configuration. Every fixture and
restoration must have before/after hashes and explicit run-boundary evidence.
No file fixture is applied while Isaac runs. Existing full user-data backups
and unrelated mods remain unchanged. Outcomes remain pending.


## C5 corroborated; C6 missing-file fixture ready

C5 absent-MCM fresh run was seed766725541 (`EKQD E0AR`) `[New, 2]`.
Saved schema1 has Maw=false in choices and run snapshot, six others=true. Its log
shows pack/observer Lua scripts running but no MCM main-script execution and no
Lua error/stack trace. The MCM *content directory* still appears in loaded-mod
content entries; that is not script/global presence. The owner's C5 query
independently observed ModConfigMenu==nil.

C5-absent-log.txt: 26,667 bytes, mtime2026-11-08 16:13:23.470Z,
SHA256 `a613f7a087a7eda298178d651a7972318d539791a406ea073d685916381b4a98`.
C5-absent-save2.dat: 314 bytes, mtime16:13:21.317Z,
SHA256 `f72c90a3fee80d67bd172c6067770c3e84900eb747afe1378a3834ddb1b91cf5`.
Unrelated slot3 rerun mod-state notices remain informational, not this new-run
failure. Assessment: pack loads without MCM and uses the nondefault saved choice.

For C6, while closed, only pack save2.dat was moved to session
`fixtures/C6-original-save2.dat`; its hash matches that C5 baseline exactly and
its former live path is verified absent. C6-missing-fixture.json records the
paths/hash, sourceAbsent=true and mcmDisabled=true. This immutable valid file
is the restoration baseline after fallback tests. No replacement was created;
no options/progression/source changes occurred. MCM remains disabled.

An unnecessary initial collector comparison to the *pre-C5* marker record's
pack-save hash stopped before the move. That hash naturally changed when C5
saved a new seed/snapshot; the collector instead verified the live source
against the newly captured C5 copy before moving, as the recipe required. This
was a collection-precondition correction, not a product failure.

C6 planned command is the C5 read-only query with labelC6. Expected true,true,
false: absent MCM, default MawOn after missing data, fresh run. Full seven-field
defaults and the fresh log will be checked from the generated pack data afterward.
## C6 missing-config fallback — owner observation

With pack save2.dat verified absent before launch and MCM still disabled, owner
started a new Normal Isaac run in slot2 and reported `C6 true true false`:
MCM absent, active Maw=true (default), actual continued=false. This is the
expected transition from C5's saved MawOff to the missing-file default MawOn.
Complete generated settings/run JSON, fresh seed and error status will be
corroborated from the log and new pack data after normal save/exit.

Owner was asked to close before the next fixture. Planned C7 setup: preserve
C6 artifacts and generated default file, safely remove only this session's MCM
disable marker, and write exact truncated JSON to the pack-only save2.dat while
closed. The immutable C5 valid configuration remains in fixtures/C6-original-
save2.dat for later restoration. No original progression/options/unrelated mod
is modified. C7 must show MCM restored and safe On defaults without Lua errors;
this remains pending, not implied by the harness.

## C6 corroborated; C7 malformed fixture ready

C6 fresh seed2172981496 (`T3ZG 8BRJ`) `[New, 2]` generated schema1 with all seven
choices and run-snapshot fields true. No MCM main script ran, pack/observer
scripts ran, and no Lua errors were logged. Combined with the owner's
C6 true,true,false, this establishes missing-file defaults with MCM absent.
C6-generated-save2.dat: 313 bytes, SHA256
`5a8121e312d3bbb0932320da5495a0b64aae7a2f14e7be9a85113761ab8b253f`.
C6-missing-log.txt: 26,811 bytes, SHA256
`063c6f37c9c0cee97a7b26c336f3ef8393dce89b9e171201b5f33a8958cb18d7`.

After preserving C6, the recorded session-owned MCM marker was safely removed;
C7-mcm-restoration.json records that reversal. While closed, the pack-only
save2.dat was replaced with exact truncated JSON `{"version":1,"settings":`
(24 UTF-8 bytes, no BOM), verified SHA256
`ee5edd0fe2861e725c89e7255122181f83b426e25f8f978d96c8187fa30b3cdb`.
C7-malformed-fixture.json records the paths/hash, sourceSHA and restored-MCM
state. The valid immutable C5 baseline still hashes to
`f72c90a3fee80d67bd172c6067770c3e84900eb747afe1378a3834ddb1b91cf5`.

The initial setup attempt used unsupported SHA256.HashData on Windows .NET and
stopped before any file change. The parent explicitly authorized the compatible
SHA256.Create().ComputeHash/Get-FileHash correction; the same recipe then
completed. This was an environment/setup API fault, not a mod error or fallback
result. C7 engine outcome remains pending.

## C7 malformed-config fallback — owner observation

Starting a new Normal Isaac run in slot2 from the exact verified truncated JSON,
with MCM restored, the owner confirmed all seven controls On and
`C7 false true false`: MCM present, active default MawOn, actual fresh run.
This is the expected safe fallback. The generated valid file, actual seed,
MCM runtime version and errors will be corroborated after normal save/exit.
No label-only/harness result is substituted for this engine observation.

Next transition: owner saves/exits; preserve C7 artifacts and generated defaults,
then restore ONLY the original valid C5 pack file from its immutable baseline
while closed. The game will next start a new run, not Continue a mismatched
fixture snapshot. Before slot-isolation testing the owner is asked which other
slot (1 or3) is available for a disposable run; no automatic slot switch or
progression mutation is authorized. Existing original pack data in that second
slot must be backed up or its absence recorded before starting the test.

## C8 slot-isolation plan — owner selected disposable slot3

Owner confirmed Isaac saved/closed and explicitly selected slot3 as available
for a disposable new run. Before testing, C7 log/generated defaults must be
preserved, then slot2 restored from the immutable C5 valid settings (MawOff,
other sixOn). Existing pack save3.dat, if any, must be backed up unchanged; its
absence must be recorded otherwise. Slot3 receives a known valid schema1
fixture with all seven choices On and no run snapshot, for a NEW run only.
Exact slot3 fixture:150 UTF-8 bytes, SHA256
`38f8f3f0d0cc428fac25d5934eb3dedc939f56fc17efadb701f341dcc905d7db`.
No slot1 or progression/options/source file is edited by the fixture setup.

The intended engine sequence keeps one Isaac process alive: new slot2 A(MawOff),
new slot3 B(MawOn), Continue slot2 A(Off), Continue slot3 B(On), with no item
acquisition. Capture owner short-query outputs, all RNG transitions in the same
launch log, actual distinct seeds and both pack files. This exercises the real
save-slot overwrite regression rather than emulating storage switching in a
harness. Do not claim same-seed engine coverage; equal-seed isolation remains a
harness case unless actually executed. Current fixture execution is pending.

## C7 corroboration and C8 prepared slots

C7 fresh seed3634808873 generated valid schema1 with all seven choices and run
fields true. The log shows MCM v113, pack and observer script execution, and no
Lua errors. Together with the owner's seven-On UI and C7 false,true,false,
this corroborates safe recovery from the exact truncated-JSON fixture.
C7-malformed-fallback-log.txt:28,384 bytes, mtime2026-11-08 16:42:17.351Z,
SHA256 `17b39108f8c1a0385e2c486ab3549f550a83177cad83415f55c54bbb70e5916f`.
C7-generated-save2.dat:313 bytes, mtime16:42:15.393Z,
SHA256 `891aefde1a8be7cf37c35d56b64e869413d3307519d2ddd2af19a2205b2b696d`.
Missing and truncated JSON are now engine-tested; wrong schema/individual
malformed field cases retain harness coverage, not claimed as separate engine
executions.

While closed, slot2 was restored byte-for-byte from the immutable C5 baseline
SHAf72c90...; Maw=false in choices/run, other six=true, old snapshot seed766725541.
The next action MUST be a new run, not Continue this old snapshot. Slot3 pack
data was previously absent (recorded), so no invented original backup exists.
Its new settings-only all-On fixture is150 bytes with verified SHA38f8f3... .
C8-slot-fixtures.json records both source paths, prior absence, hashes and
MCM-enabled state. No progression/options/source changes were made by setup.

First C8 owner step: launch NEW Normal Isaac slot2, leave settings unchanged,
then query current Maw gate and actually observed continued flag with labelC8A.
Expected false,false; keep this Isaac process running for every subsequent slot
transition. Result pending.

## C8A slot2 fresh Off — owner observation

Owner started a new Normal Isaac run in slot2 and reported `C8A false false`:
MawOff active, actual fresh run. Isaac remains running; no item grants or setting
changes are part of this case. Next transition is save back to menu, select
slot3 and start a NEW Normal Isaac run without restarting the process. Slot3's
known next-run fixture is allOn. Expected C8B true,false; outcome pending.

## C8B slot3 fresh On — owner observation

Within the same running Isaac process, owner saved slot2, switched to slot3,
started a new Normal Isaac run and reported `C8B true false`: MawOn active,
actual fresh run. This is consistent with loading the separate known slot3
fixture after slot2's Off configuration. Full isolation still needs returning
Continue checks and preserved file/log corroboration. Next: save back to menu,
select slot2 and Continue, expected C8A2 false,true; do not restart the process.

## C8A2 slot2 Continue Off — owner observation

Owner saved slot3, returned to slot2 and chose Continue without restarting Isaac.
Reported `C8A2 false true`: MawOff retained and actual continued flag true.
This supports that visiting/saving slot3 On did not overwrite slot2's Off state.
Final transition: save to menu, slot3 Continue, expected C8B2 true,true; leave
that run open and item-free for file/log preservation and later coordination.

## C8B2 slot3 Continue On — owner observation

Owner saved slot2, switched to slot3 and chose Continue in the same running
Isaac process, then reported `C8B2 true true`: MawOn retained and actual continued
flag true. All four intended outputs now match:
A new Off(false,false), B new On(true,false), A Continue Off(false,true),
B Continue On(true,true). No item grants/toggle changes occurred during C8.

Final read-only collection of the same-process log and both pack files is
underway to record actual seeds, separate snapshots/preferences and errors.
The slot3 continued run remains open and item-free. No config fixture is restored
or removed while Isaac runs. A handoff may follow only after this capture.


## C8 slot isolation corroborated — pass for the executed distinct-seed case

One Isaac process (PID2272, start2026-11-08 16:47:57.941Z) recorded exactly the
intended transitions in the captured launch log:

1. Slot2 NEW, seed1371597772 (`M213 JNQA`), owner C8A false,false.
2. Slot3 NEW, seed4201988032 (`80PE ARNB`), owner C8B true,false.
3. Slot2 Continue, same seed1371597772, owner C8A2 false,true.
4. Slot3 Continue, same seed4201988032, owner C8B2 true,true.

Saved schema1 in slot2 retains Maw=false in choices/run; slot3 retains Maw=true
in choices/run. Other six fields are true in both slots/settings objects. Both
snapshots retain their respective actual seeds. MCM v113, pack and observer
scripts loaded, no Lua errors were found, known source/observer/manifest
fingerprints match, MCM disable marker is absent and unrelated mod markers are
unchanged. No same-seed engine claim is made (that remains a harness case).

C8-slot-isolation-log.txt:54,166 bytes, mtime2026-11-08 16:52:54.038Z,
SHA256 `d7f11ebd0258fdbc79b1cc4d30ac24dec7f711bba255b09d5c8406f6296c4ad8`.
C8-save2.dat:315 bytes, mtime16:52:33.755Z,
SHA256 `5545628e500a407a58f7182b9067aca2651d40a73e3e1a8b081e3468ccf880de`.
C8-save3.dat:313 bytes, mtime16:52:37.655Z,
SHA256 `68aaeaaa2378670fa5b1faf5041093e8b8b81b9d09aabec5866ca7881132654d`.
The game locked the live log during an unnecessary final rehash attempt; the
prior copied artifact and its hash were obtained successfully. No retry or
game mutation followed. This is a capture-access limitation, not a mod fault.

Assessment: the original save-slot overwrite regression is not reproduced in
the actual distinct-seed slot switches; preferences and Continue snapshots
remain isolated. Configuration UI, representative persisted choice, new/Continue
boundary, optional MCM absence, missing/truncated fallback and actual slot
switching are now supported by recorded engine evidence. Independent disabled
mechanic gameplay comparisons remain incomplete; issue #3 stays open.

## Explicit second session handoff — issue #3 → issue #1

Current slot3 run is the continued seed4201988032, all seven choices/run gates On,
actual continued=true by owner query. No items were acquired during C8; current
health/stats/familiars were not snapshotted, so #1 must establish a fresh read-only
baseline before gameplay assertions rather than infer them from earlier slot2.
Pack sourcef1c8325, MCMv113, immutable observer and installation are unchanged.

Issue #1 receives ownership for a bounded orbital On/Off comparison and optional
Maw ring-field/kill observations. For independent configuration acceptance, each
Off control must have only that component Off and the other six On; do not
combine multiple Off gates and claim isolated coverage. #1 must record exact
active/next-run/continued/seed state, preserve artifacts, and return ownership
explicitly. No #3 competing game prompts or shared-state mutations while held.
MCM/fallback fixture cleanup provenance remains preserved; slot3 pack data was
originally absent and must not be silently removed while the game runs.
