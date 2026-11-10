---
name: documentation-rules
description: Read this before making documentation changes
metadata:
  short-description: Maintain player and technical documentation
---

# Automatic Feature Documentation

Define when and how to document Open Unnerf Pack 2 features and technical
workflows. Give each major feature a comprehensive overview, using the
appropriate documentation home for its audience. Write documentation in English
unless the owner requests another language.

## 1. When to Create Documentation

**Documentation is required for:**

- New mod features or independently configurable adjustments under `Mods/`.
- New configuration sections or major player-facing MCM interactions.
- New major gameplay functionality or tools and workflows agents need to operate.
- Significant changes to existing features.
- New integrations with modding APIs, optional mods, or external tools/services.

**These changes do not require a new documentation page by themselves:**

- Bug fixes.
- Adding or modifying individual internal settings or Lua data fields.
- Styling or minor UI tweaks.
- Code refactoring without functional changes.
- Performance optimizations.
- Dependency updates.

Keep existing documentation accurate when any of these changes affects the
behavior, configuration, or instructions it describes.

## 2. Documentation Structure

- **User documentation:** `docs/features/`, indexed by `docs/features/README.md`.
  Explain what each adjustment does, how players configure it, and its limits.
- **Technical documentation:** `docs/agents/`, indexed by `docs/agents/README.md`.
  Explain implementation details, tools, development and validation workflows,
  and operational knowledge agents need.

Existing validation guides and evidence in `docs/testing/`, `docs/research/`,
and `docs/configuration-validation.md` retain their established paths and are
linked from the technical index. Reusable agent workflows are packaged as
`.agents/skills/<skill-name>/SKILL.md` and linked from that index rather than
duplicating their instructions in `docs/agents/`.

Use kebab-case filenames matching the feature or workflow name, for example:

- `docs/features/maw-of-the-void.md`
- `docs/features/humbling-bundle.md`
- `docs/features/blue-fires.md`
- `docs/agents/subagents.md`

Give independently configurable features separate pages even when they share a
source folder. Link to technical details from user pages instead of embedding
developer procedures in the player-facing instructions.

## 3. Documentation Templates

Use the relevant template for a new page. Include applicable sections; omit
sections that do not apply to the feature or workflow.

### User feature page

```markdown
# [Feature name]

[All features](README.md)

## Overview

Describe what the adjustment does and why it exists.

## Behavior

Explain the vanilla behavior and what the mod changes on the supported game
build. Describe significant subfeatures, interactions, and character/mode limits.
Distinguish implemented behavior from observed validation results.

## Configuration

State the feature's status, default, menu label, and relevant player controls.
Explain when changes apply and what happens with a new run or Continue.
Identify unfinished or disabled behavior explicitly.

## Data and state

If relevant, explain player-visible saved choices, persistence, and run state.
Link to technical documentation for schema and implementation details.

## Dependencies

List required or optional game versions, mods, and integrations.

## Related features and technical reference

Link related feature pages and the relevant technical guide or validation record.

---
*Last updated: [YYYY-MM-DD]*
```

### Technical feature or workflow page

```markdown
# [Feature or workflow name]

[Technical documentation](README.md)

## Overview

Describe the purpose and when to use this feature, tool, or workflow.

## Implementation and entry points

- **Implementation:** Relevant modules under Mods/, main.lua, or config.lua.
- **Entry points:** Relevant game callbacks, MCM hooks, or tool commands.
- **Tools and tests:** Relevant files under tools/ and tests/.
- **Other files:** Relevant metadata, configuration, content, or domain documents.

## How it works

Describe significant operations and subfeatures.

## Data and state

If relevant, describe:
- Authoritative game/API data, Lua structures, and saved-setting schemas.
- Relationships, retention, cleanup, and deletion of stored state.
- Ownership of per-player, per-run, and per-save-slot state.
- Validation of callback inputs, saved data, and integration boundaries.

## Operation and interface

Give prerequisites, commands or console setup, expected results, and relevant
MCM interactions in clear English. Link maintained validation procedures and
record the limits of existing evidence.

## Dependencies

List required game/API versions, Lua libraries, optional mods, and external tools.

## Related documentation

Link related technical guides and the player-facing feature page where relevant.

---
*Last updated: [YYYY-MM-DD]*
```

## 4. When to Update Documentation

Update existing documentation when:

- Adding significant new functionality to a feature or workflow.
- Changing how a feature works.
- Modifying its data model or saved-state schema.
- Adding configuration controls or major player-facing interactions.

Update the relevant user and technical pages according to the audience affected.

## 5. When to Remove Documentation

Remove or replace the current documentation when a feature or workflow is
completely removed from the mod or replaced by a different implementation.

1. Delete, update, or replace its page under `docs/features/` or `docs/agents/`.
2. Update the corresponding index and affected cross-links.
3. Record user-visible removals under `Removed` in `docs/CHANGELOG.md`, following
   [changelog rules](../changelog-rules/SKILL.md). Historical validation records remain
   evidence of the versions they describe.

## 6. Documentation Indexes

Maintain `docs/features/README.md` as the index of user-facing features and
`docs/agents/README.md` as the index of technical documentation. Include brief
descriptions and links to the relevant pages.

## 7. Automatic Documentation Workflow

When implementing a feature that requires documentation:

1. Implement the feature.
2. Create or update its user and/or technical documentation using the relevant
   template.
3. Update the corresponding documentation indexes.
4. Apply the [changelog-rules skill](../changelog-rules/SKILL.md) and add a
   `docs/CHANGELOG.md` entry when the change qualifies; development-only changes
   are excluded.
5. Keep implementation and documentation in the same change set; create branches
   or commits only when explicitly requested.
