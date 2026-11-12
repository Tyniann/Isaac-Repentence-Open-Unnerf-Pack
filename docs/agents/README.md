# Technical and agent documentation

Start here for tools, development workflows, validation procedures, and project
rules. New technical guides belong in this directory. Existing validation guides
and evidence are linked below at their current paths. Reusable agent workflows
live under `.agents/skills/`; the links below lead to their authoritative files.

For player-facing behavior and configuration, see the [feature
reference](../features/README.md). For installation and the project overview,
see the [project README](../../README.md).

## Project rules and workflows

The root [AGENTS.md](../../AGENTS.md) defines when to consult these guides:

- [Subagents and orchestration](subagents.md)
- [GitHub issue workflow](issue-tracker.md)
- [Triage labels](triage-labels.md)
- [Domain documentation](domain.md)
- [Changelog rules skill](../../.agents/skills/changelog-rules/SKILL.md): entry
  eligibility, formatting, and release history.
- [Documentation rules skill](../../.agents/skills/documentation-rules/SKILL.md): creation/update/removal triggers,
  templates, and indexes for player and technical documentation.

## Tools and validation

- [Releases and Steam Workshop](releasing.md): synchronize/version the source,
  build a pinned archive, tag and publish it, verify downloaded assets, and
  prepare Workshop uploads with the correct ownership and metadata ID.
- [Shared game validation](game-validation.md): maintained tools, owner-guided
  checks, evidence collection, and session handoffs.
- [Native pool rules](pool-rules.md): helper-backed pool adjustments, registration
  contracts, configuration and saved-state behavior.
- [Void choice absorption](void-choice-absorption.md): native pre-use unlinking,
  special-room exclusions, temporary state and disposable batch validation.
- [Configuration validation](../configuration-validation.md): MCM integration
  details and reproducible configuration checks.
- [Repentance+ v1.9.7.17 validation](../testing/repentance-plus-1.9.7.17.md):
  compatibility audit, console setups, and acceptance checks.
- [Native validation batches](../testing/native-batches.md): development test
  helpers, execution guidance, and limits.
- [Tool sources](../../tools/) and [test harnesses](../../tests/): implementations
  used by the validation guides above.

## Evidence and technical reference

- [Compatibility results](../testing/issue-1-engine-results.md)
- [Configuration results](../testing/configuration-results-1.9.7.17.md)
- [Magic Mushroom results](../testing/magic-mushroom-1.9.7.17.md)
- [Void choice absorption validation](../testing/void-choice-1.9.7.17.md): API
  feasibility probe, scoped native matrix, Continue, charge, cleanup and limits.
- [Void choice edge cases](../research/void-choice-edge-cases.md): Polaroid/Negative
  source research and the distinction between alternate-path group coverage and
  an untouched mystery-pedestal test.
- [Installed-game API and balance evidence](../research/repentance-plus-installed-evidence.md)
- [Stomp-immunity diagnosis and validation](../research/issue-2-stomp-validation.txt)
