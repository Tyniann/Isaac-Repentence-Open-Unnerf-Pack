---
description: "Rules for maintaining the CHANGELOG.md file when a feature is added, updated, fixed or removed"
---

## Changelog Management

This rule defines how to maintain the changelog for this project. The changelog provides a detailed history of all changes, making it easy to see what changed between versions.

### 1. Changelog Location

The changelog is located at: `docs/CHANGELOG.md`

### 2. Changelog Format

Follow the [Keep a Changelog](https://keepachangelog.com/) format:

```markdown
# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- New features that have been added

### Changed
- Changes to existing functionality

### Fixed
- Bug fixes

### Removed
- Features that have been removed

### Security
- Security-related changes

---

## [1.0.0] - 2025-01-08

### Added
- Initial release
- Feature X
- Feature Y
```

### 3. Categories

Use these categories in order:

| Category | Use For |
|----------|---------|
| **Added** | New features, new screens, new functionality |
| **Changed** | Changes to existing features, UI updates, behavior changes |
| **Fixed** | Bug fixes, error corrections |
| **Removed** | Removed features, deprecated functionality |
| **Security** | Security patches, vulnerability fixes |
| **Deprecated** | Features marked for future removal |

### 4. What to Log

**Always log:**
- New features (big or small)
- Bug fixes
- Removed features
- Security fixes
- Breaking changes
- Database schema changes
- New or changed Edge Function commands or public contracts

**Optionally log (if notable):**
- Performance improvements
- Refactoring that changes behavior
- UI/UX improvements
- Dependency updates (especially major versions)

**Do NOT log:**
- Internal refactoring without user-visible changes
- Code style changes
- Minor typo fixes in code
- Development-only changes

### 5. Entry Format

Each entry should be:
- Written in imperative mood ("Add", "Fix", "Remove", not "Added", "Fixed")
- Clear and understandable without code context
- Reference GitHub Issues or PRs when applicable

**Good examples:**
```markdown
### Added
- Add pair joining to Classroom Sessions (#12)
- Add Teacher review for Formative Summaries

### Fixed
- Fix expired Join Credentials remaining usable (#15)
- Fix session recovery after changing tablets

### Changed
- Improve Classroom Session reconnect performance
- Change Formative Summary retention controls
```

**Bad examples:**
```markdown
### Added
- pdf stuff
- fixed the thing
- UserProfileScreen.dart changes
```

### 6. Version Numbers

Use Semantic Versioning (MAJOR.MINOR.PATCH):

- **MAJOR:** Breaking changes, major redesigns
- **MINOR:** New features, significant improvements
- **PATCH:** Bug fixes, minor improvements

### 7. Workflow

**When making any change:**

1. Add entry under `## [Unreleased]` section
2. Use appropriate category (Added, Changed, Fixed, etc.)
3. Write clear description
4. Include Issue/PR reference if applicable

**When releasing a version:**

1. Change `## [Unreleased]` to `## [X.Y.Z] - YYYY-MM-DD`
2. Add new empty `## [Unreleased]` section at top
3. Commit with message `chore: release version X.Y.Z`

### 8. Example Workflow

Developer fixes a bug:

1. Fix the bug and run the smallest relevant check
2. Add to CHANGELOG:
   ```markdown
   ## [Unreleased]

   ### Fixed
   - Fix expired Join Credentials remaining usable (#15)
   ```
3. Keep the changelog entry in the same change set; create a branch, commit, or pull request only when explicitly requested
