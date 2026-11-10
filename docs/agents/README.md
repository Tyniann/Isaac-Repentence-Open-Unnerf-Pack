# Technical and agent documentation

Start here for tools, development workflows, validation procedures, and project
rules. New technical guides belong in this directory. Existing validation guides
and evidence are linked below at their current paths.

For player-facing behavior and configuration, see the [feature
reference](../features/README.md). For installation and the project overview,
see the [project README](../../README.md).

## Project rules and workflows

The root [AGENTS.md](../../AGENTS.md) defines when to consult these guides:

- [Subagents and orchestration](subagents.md)
- [GitHub issue workflow](issue-tracker.md)
- [Triage labels](triage-labels.md)
- [Domain documentation](domain.md)
- [Changelog rules](changelog-rules.md)
- [Documentation rules](documentation-rules.md): creation/update/removal triggers,
  templates, and indexes for player and technical documentation.

## Tools and validation

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
- [Installed-game API and balance evidence](../research/repentance-plus-installed-evidence.md)
- [Stomp-immunity diagnosis and validation](../research/issue-2-stomp-validation.txt)
