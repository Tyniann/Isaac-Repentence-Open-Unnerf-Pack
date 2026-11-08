# Domain docs

## Layout and reading rules

This repo uses a single context:

- `GLOSSARY.md` at the repo root defines domain vocabulary.
- `docs/adr/` holds architecture decision records.

Before exploring the codebase, read the glossary and ADRs relevant
to the area being explored.

If these files do not exist, proceed silently. Domain-modeling
work creates them when terms or decisions are resolved.

## Vocabulary

Use glossary terms in issue titles, proposals, hypotheses, tests,
and other domain-facing output. If a needed concept is missing,
reconsider the term or note the gap for domain modeling.

## Decision conflicts

If a proposal contradicts an existing ADR, identify that ADR and
explain why the decision should be reopened.
