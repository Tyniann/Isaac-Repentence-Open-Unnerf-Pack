---
name: changelog-rules
description: Use when adding, changing, fixing, deprecating, or removing user-visible behavior; making notable player-facing documentation changes; auditing or editing docs/CHANGELOG.md; or preparing a release.
metadata:
  short-description: Record user-visible changes and release history.
---

# Changelog Management

Maintain `docs/CHANGELOG.md` as the history of notable changes to Open Unnerf
Pack 2. Apply this skill to classify a change, update or audit entries, or prepare
release history. A trigger to assess a change does not mean it needs an entry.

Repository paths in this skill are relative to the project root.

## 1. Changelog Location

The changelog is `docs/CHANGELOG.md`.

## 2. Changelog Format

Follow [Keep a Changelog](https://keepachangelog.com/). Keep pending changes under
`## [Unreleased]`, with applicable categories in the order below. For example:

```markdown
# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- Add independent unnerf toggles through optional Mod Config Menu Pure (#3).

### Fixed

- Fix Mom's foot bypassing stomp immunity (#2).
```

## 3. Categories

Use these categories in order, omitting categories without entries:

| Category | Use for |
| --- | --- |
| **Added** | New mod features, controls, or functionality |
| **Changed** | Changes to existing features, UI, or behavior |
| **Fixed** | Bug fixes and error corrections |
| **Removed** | Removed features or functionality |
| **Security** | Security patches and vulnerability fixes |
| **Deprecated** | Features marked for future removal |

## 4. What to Log

Classify changes by their effect on players or public mod interfaces. The
exclusions below take precedence for development-only or cosmetic changes.

**Always log qualifying:**

- New features, big or small.
- Bug fixes.
- Removed features.
- Security fixes.
- Breaking changes.
- Saved-data schema changes.
- New or changed public mod interfaces or configuration contracts.

**Optionally log, if notable:**

- Performance improvements.
- Refactoring that changes behavior.
- UI/UX improvements.
- Dependency updates, especially major versions.
- Player-facing installation, configuration, or feature documentation improvements.

**Do not log:**

- Internal refactoring without user-visible changes.
- Code style changes.
- Minor typo fixes in code.
- Development-only changes, including internal tools, agent policies, and test
  infrastructure that do not change player-facing behavior or public contracts.

## 5. Entry Format

Write entries in imperative mood: "Add", "Fix", or "Remove", rather than "Added",
"Fixed", or "Removed". Describe the result in terms a player can understand
without reading code, and reference GitHub issues or PRs when applicable.

**Good examples:**

```markdown
### Added

- Add independent unnerf toggles through optional Mod Config Menu Pure (#3).

### Changed

- Apply configuration changes when starting a new run.

### Fixed

- Fix Mom's foot bypassing Host Hat and Pyromaniac protection (#2).
- Preserve continued-run settings when switching Isaac save slots (#5).
```

**Bad examples:**

```markdown
### Added

- unnerf stuff
- fixed the thing
- config.lua changes
```

## 6. Version Numbers

Use Semantic Versioning (`MAJOR.MINOR.PATCH`):

- **MAJOR:** Breaking changes or major redesigns.
- **MINOR:** New features or significant improvements.
- **PATCH:** Bug fixes or minor improvements.

Keep changes under `Unreleased` until preparing an actual release; use that
release's version and date rather than inventing a historical release.

## 7. Workflow

**When assessing a project change:**

1. Check the logging criteria and exclusions above.
2. For a qualifying change, add an entry under `## [Unreleased]` in the appropriate
   category, with a clear description and an issue/PR reference when applicable.
3. For excluded changes, leave the changelog unchanged. Automatic use of this
   skill does not require a placeholder or "no changes" entry.

**When preparing a release:**

1. Change `## [Unreleased]` to `## [X.Y.Z] - YYYY-MM-DD` using the release's version
   and date.
2. Add a new empty `## [Unreleased]` section at the top.
3. Use `chore: release version X.Y.Z` for an authorized release commit.

## 8. Example Workflow

For a user-visible bug fix:

1. Fix the bug and run the smallest relevant check.
2. Add an entry to `docs/CHANGELOG.md`:

   ```markdown
   ## [Unreleased]

   ### Fixed

   - Fix Mom's foot bypassing Host Hat and Pyromaniac protection (#2).
   ```

3. Keep the changelog entry in the same change set as the implementation; create
   a branch, commit, or pull request only when explicitly requested.
