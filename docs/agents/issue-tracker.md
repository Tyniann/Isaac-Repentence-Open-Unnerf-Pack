# Issue tracker: GitHub

Issues and specs live in GitHub Issues for
`Tyniann/Isaac-Repentence-Open-Unnerf-Pack`. Use the `gh` CLI
from this clone, or pass
`--repo Tyniann/Isaac-Repentence-Open-Unnerf-Pack` explicitly.

## Operations

- Create: `gh issue create --title "..." --body-file <file>`.
- Read: `gh issue view <number> --comments`; include labels when
  gathering ticket context.
- List: `gh issue list --state open --json number,title,body,labels`;
  fetch comments for relevant issues.
- Comment: `gh issue comment <number> --body-file <file>`.
- Add or remove labels: `gh issue edit <number> --add-label "..."`
  or `--remove-label "..."`.
- Close: `gh issue close <number> --comment "..."`.

For multiline bodies, write the exact text to a temporary file
and pass it with `--body-file`.

When a skill says "publish to the issue tracker", create a GitHub
issue. When it says "fetch the relevant ticket", read the issue
and its comments.

## Pull requests as a triage surface

**PRs as a request surface: no.**

GitHub shares issue and PR numbers. If a reference is ambiguous,
resolve its type before acting.

## Wayfinding operations

- Map: one issue labelled `wayfinder:map`, containing Notes,
  Decisions-so-far, and Fog.
- Child tickets: link as GitHub sub-issues. If unavailable, use a
  task list in the map and `Part of #<map>` in each child.
  Label children `wayfinder:<type>`: research, prototype,
  grilling, or task.
- Blocking: use native GitHub issue dependencies. Add a dependency
  through `repos/<owner>/<repo>/issues/<child>/dependencies/blocked_by`,
  passing the blocker's numeric database ID as `issue_id`.
  If unavailable, record `Blocked by: #<number>` in the child.
- Frontier: choose the first open, unassigned child in map order
  whose blockers are all closed.
- Claim: assign the ticket to the driving developer before work.
- Resolve: comment with the answer, close the ticket, then append
  a summary and link to the map's Decisions-so-far.
