# Shared Isaac engine validation

Use this guide to prepare a bounded engine check and collect its evidence.
Feature-specific commands and results stay in the linked ledgers. The main
agent owns test design and acceptance; apply the roles in [subagents.md](subagents.md)
to research, routine execution and all computer use.

## Establish ownership and the build

1. Read the issue's current acceptance criteria and recent validation records.
   Reuse evidence only where source bytes, settings and conditions still apply.
   Issue #1's final assessment accepted isolated feature-Off controls for its
   anti-stacking comparisons; whole-pack removal is not a universal prerequisite.
2. Check linked-environment reachability, active work and the session owner.
   A quiet process list or full-access connection does not transfer ownership.
   Obtain an explicit handoff before deployment, restart, configuration or run
   changes; one thread issues the next game sequence.
3. Record source SHA, per-file deployment hashes, executable hash/build evidence,
   installed/enabled mods, MCM version if available, save slot, seed, difficulty,
   actors and fresh/Continue state. Record active and next-run configuration
   separately. The presence of MCM is not evidence of a particular version.
4. Use a disposable run and retain the original backups. Coordinate changes to
   saves and unrelated mods with the owner. Record the exact intended mutation
   and restoration scope before starting.

Mafia-Server's known game root is
`D:\The.Binding.of.Isaac.Repentance.v4.0.2`. Resolve its current environment link
and provider capabilities rather than copying old provider/session IDs as live
facts. The [configuration ledger](../testing/configuration-results-1.9.7.17.md)
records the initial deployment; the [native batch ledger](../testing/native-batches.md)
records its later cleanup. Neither establishes the current live state.

## Choose maintained tooling

| Entry point | Purpose and limit |
| --- | --- |
| `tools/validation/build_test_package.py` | Builds a runtime-only archive and hash manifest; does not install or execute. Its pack/MCM revisions are pinned in source. It is not a builder for arbitrary current working-tree changes. |
| `tools/validation/deploy-test-build.ps1` | Verifies source bytes, backs up data and installs into absent destinations with the game closed. Stops if destinations already exist; design a coordinated update rather than deleting them to force a rerun. |
| `tools/validation/test-build.manifest.json` | Historical pinned deployment evidence; compare actual installed files, not an operator's SHA label. |
| `tools/compatibility-observer.lua` | Separate read-only observer mod. Records settings, game/player/familiar context and events to the game log. Production does not load it. |
| `tools/validation/compatibility-batch.lua` | Native frame-driven fixture runner for bounded existing compatibility cases. Mutates disposable fixtures and can clear map rooms/alter terrain. It does not test arbitrary future features. |

The runner's smallest engine smoke precedes a broader batch. Main-agent
verification of a new recipe is required before delegating routine execution.
Syntax and stub tests establish fixture safety/protocol only, not engine behavior.
See the [observer protocol](../testing/issue-1-engine-results.md#shared-observer-protocol-deployed-initial-snapshot-engine-verified)
and [native runner contract](../testing/native-batches.md#current-implementation)
for commands and interpretation.

## Guide the owner one small step at a time

- Put copy/paste Lua commands only in the **final turn summary**. Commentary and
  question-tool prompts contain no Lua commands; the owner may not see them.
- Use multiple-choice questions without code. Include a concrete expected
  observation and an error/unexpected-result choice; free text remains available.
  Ask for the result of the current step before dependent gameplay actions.
- Keep action, observation and interpretation distinct. A screenshot of console
  output is direct evidence of those printed fields; inspect supplied screenshots
  directly under the image rule in `subagents.md`. New GUI interaction or capture
  belongs to Terra at the prescribed effort.
- Give short commands and a small test budget. Automate repetitive work through
  a verified runner and collect logs through shell/file tools. The owner should
  not have to scroll through the log or transcribe long traces.
- Close the console when a frame-driven batch needs the game to advance; reopen
  for its short status/result query. An open console can pause progress. Check
  state and bounded errors before repeating a stalled batch.
- Use a fresh disposable run or Continue according to the test, rather than
  reloading production modules with `luamod`. Reloading may register callbacks
  twice and invalidate the once-only/Continue check.

In issue #1, supported desktop control failed twice at its initial native-pipe
connection, before input or screenshots. The owner then chose manual console
continuation. This was an environment failure, not a gameplay failure. For a new
session check current capabilities and applicable computer-use guidance. Respect
the selected manual mode; do not bypass a failed supported connector through
PowerShell UIA, SendInput or a custom native-pipe client. The failure and owner
choice are recorded in the [engine ledger](../testing/issue-1-engine-results.md#requested-console-only-ui-automation-smoke).

## Collect evidence and finish the session

Record exact command/runner revision, expected result, observed result and
`pass`, `fail`, `inconclusive` or `pending` for each acceptance case. Corroborate
owner feedback using read-only log copies and settings snapshots where available.
Preserve raw evidence, hashes and source metadata; distinguish a stable capture
from one that raced a live write. Observe sensitive save data without publishing
it into the repository.

There is no maintained general log collector or cleanup driver in
`tools/validation/`. Design the smallest read-only capture on the actual remote
environment before delegating it: resolve the real log/data paths, record source
length/mtime/hash before and after the copy, and hash the preserved artifacts.
Extract JSON records by exact prefix and test label/seed; retain malformed payloads
alongside valid records rather than dropping them or replaying gameplay. The base
observer uses `OUP_PROBE`, the runner uses `OUP_ENGINE_BATCH`, and compact terminal
captures in the ledger use `OUP_BATCH_END`. Console print alone may not appear in
the log; use the maintained DebugString instrumentation for durable evidence.

A collector failure is not a gameplay failure. In #1, JSON recovery and sidecar
repair reused captured bytes without rerunning the engine test. Its command
preparation lessons are in [native batches](../testing/native-batches.md).
When JavaScript builds a PowerShell command, keep PowerShell backticks out of JS
template literals and use the verified collection conversion (`.ToArray()` in
that recipe) instead of a generic-list array wrapper. Separate preparation,
provider bootstrap and shell execution errors: machine reachability and catalog
availability do not prove a remote shell started. After bootstrap failures,
preserve the current log and stop unchanged retries; provider database changes
are not a game-test workaround. The [configuration ledger](../testing/configuration-results-1.9.7.17.md#windows-recovery-and-relic-snapshot-corroboration)
shows successful later recovery of the same run without replaying it.

The observer's SHA/run-kind arguments are operator labels. Fresh/Continue is
engine-observed only when instrumentation saw the game-start callback. Pre-damage
events do not prove final damage, and pickup observations need spawn provenance.
Random failure to roll an item proves neither absence nor exact weight. Native
fixtures, forced engine inputs and uninstrumented play are different evidence.

Stop owned diagnostics, confirm their exact cleanup, and retain errors rather
than silently retrying. Some fixtures cannot roll back cleared rooms or terrain.
The base observer's Stop disables logging but leaves callbacks registered until
exit; optional helpers have their own cleanup contracts.

For removal, first confirm the game is closed, inventory and hash the exact
diagnostic files, and preserve protected pack/MCM/data hashes. Issue #1 used a
reversible same-volume move of the observer directory to
`D:\T3ValidationArchives` after a recursive-delete attempt was rejected. Its
archive location and verification are in the [cleanup record](../testing/native-batches.md#owner-selected-cleanup-and-handoff).
Check that record and current paths before any restore; ordinary play needs no
observer restoration. Preserve original backups and record the final state and
the next session owner. Acceptance requires the issue's actual criteria, not
every possible interaction or a fresh repetition of already valid evidence.

## Provenance

Recovered from the completed
[issue #1 thread](t3-thread://v2/ccd2cf93-f077-4c16-85a4-a0db10c6f33d/mcp:launch:f1840b0198b9aa9f5d57e7bc8ab97bebff2741b590b5bd525e90044769d900f5),
especially its final batch, cleanup and acceptance assessment, and the repository
ledgers linked above. This captures reusable knowledge requested in the
configuration ledger; the broader workflow generalization tracked in
[issue #8](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/8)
remains open. Owner instructions in issue #4 added the final-summary-only Lua and
multiple-choice/no-code question format on 2026-11-10.
