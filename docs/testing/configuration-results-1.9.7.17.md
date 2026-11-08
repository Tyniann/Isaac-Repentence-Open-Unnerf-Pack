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
| MCM absent | Close game; reversible MCM-only disable; relaunch/new run; pack uses saved Maw Off without Lua error | pending | |
| MCM restored | Close game; restore same MCM version; saved menu choices remain | pending | |
| Slot isolation | Two disposable save slots retain distinct next-run choices and Continue snapshots without Lua reload; do not overwrite owner progression | pending | |
| Missing/malformed data | Back up pack data only while closed; absent JSON, invalid JSON, unknown schema, invalid individual field; defaults per README; restore backup | pending | |
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
