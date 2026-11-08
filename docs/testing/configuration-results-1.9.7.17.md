# Issue #3 engine validation — Repentance+ 1.9.7.17

## Session ownership and provenance

Issue #3 owns the initial shared Mafia-Server installation and first interactive
MCM/persistence batch. Issue #1 may collect files/logs read-only and prepare its
recipes; it receives explicit ownership before any conflicting console or
run-state changes. One owner, one installation, one active sequence.

- Source selected: integrated `f1c83253af3636816c3b83c6ab28d2221ad345ea`
  (includes configuration PR #5, compatibility PR #6, stomp fix PR #7).
- Deployed SHA / package SHA256 / per-file manifest: **not deployed yet**.
- Game target: Repentance+ `1.9.7.17`; previous title screenshot and executable
  string `1.9.7.17.J460` establish version, not mod compatibility.
- Actual MCM implementation/version: **pending current file inspection**.
- Owner confirmed game closed and authorized reversible preparation.
- No engine pass is inferred from the merged implementation or Lua harness.

## Result matrix

Record timestamps, seed/save slot, fresh/Continue, active and next-run choices,
vanilla/modded state, exact commands, log artifact and owner observation per row.
Use `pending`, `pass`, `fail`, or `inconclusive`; never infer a drop-rate result
from one random outcome. Nail and Satanic Bible remain disabled and unexposed.

| Case | Setup and required observation | Result | Evidence |
| --- | --- | --- | --- |
| MCM present | Recorded build + actual MCM Pure version; fresh disposable Isaac run; F10 → Open Unnerf Pack → Unnerfs; exactly seven On controls, no Nail/Bible | pending | |
| Deferred choice | Set Maw Off in MCM; current active run remains On, next-run choice is Off | pending | |
| Relaunch + Continue | Exit to desktop, relaunch, Continue same seed; Maw menu Off but active run still On, no Lua errors | pending | |
| New-run boundary | Fresh Isaac run after saved Maw Off; active Maw Off, other six On | pending | |
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
