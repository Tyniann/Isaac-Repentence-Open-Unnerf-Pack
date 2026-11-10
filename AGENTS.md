## Agent skills

### Subagents and orchestration

Before computer use or delegating work, read `docs/agents/subagents.md` for mandatory model and reasoning-effort assignments, task boundaries, validation handoffs, and coordination rules.

### Skill workflows

Before choosing a task's workflow, inspect the names and descriptions in `.agents/skills/*/SKILL.md`. Read and apply the skills relevant to the task, loading their referenced material as needed. Discover the current catalog from the files rather than relying on a fixed list.

For skills that allow implicit invocation, treat their descriptions as activation triggers; apply them without waiting for the user to name them.

Skill names in startup instructions or automatically loaded skill text do not constitute a planning-only request. For implementation or backlog work, follow the issue workflow to select and complete runnable work before planning new work. Documentation and changelog requests remain scoped to the requested changes.

The owner's project mandate takes precedence over skill guidance. Skills do not grant exceptions to the fixed mandate or higher-priority runtime instructions.

### Issue tracker

Issues and specs live in GitHub Issues for `Tyniann/Isaac-Repentence-Open-Unnerf-Pack`. Before selecting work, planning the backlog, or operating the tracker, read `docs/agents/issue-tracker.md`.

### Triage labels

Use the five canonical triage labels. Before changing labels, read `docs/agents/triage-labels.md`.

### Domain docs

Single-context: root `GLOSSARY.md` and `docs/adr/`. Before exploring the codebase, read `docs/agents/domain.md`.

### Pull requests

Before creating, updating, taking over, or merging a pull request, read `docs/agents/pull-requests.md` if present. Own the review and fix cycle through integration or an explicit handoff.

### Changelog

Before making user-visible behavior or notable player-facing documentation changes, auditing or editing changelog coverage, or preparing a release, apply the [changelog-rules skill](.agents/skills/changelog-rules/SKILL.md). It determines what belongs in `docs/CHANGELOG.md`; its exclusions apply to development-only, cosmetic, and other non-qualifying changes.

## Documentation

Before implementing feature, tool, or workflow changes, or creating, updating, or reorganizing documentation, apply the [documentation-rules skill](.agents/skills/documentation-rules/SKILL.md). It determines which user and technical pages and indexes need to be created or updated.

Changelog-only edits use the changelog-rules skill and do not require a separate feature or technical documentation page.

### Technical documentation

Technical and agent-facing documentation lives in [docs/agents/](docs/agents/README.md). Use its index for tools, development and validation workflows, and operational guidance. Read the relevant guides before working in those areas.

### User documentation

Player-facing feature documentation lives in [docs/features/](docs/features/README.md), with an index and a separate page for each mod feature. Keep these pages aligned with user-visible behavior and configuration.
