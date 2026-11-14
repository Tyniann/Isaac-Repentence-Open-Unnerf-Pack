# Blank Card and Jera — issue #19 validation

[Technical documentation](../agents/README.md) ·
[Issue #19](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/19)

## Status

**Feasibility and native validation are pending.** No production implementation
has been made and no gameplay pass is claimed. The current work prepares a
separate, read-only observer for a backed-up disposable run. Acceptance remains
the complete issue #19 checklist, including the charge display and recharge,
battery interactions, other consumables, item swaps, Continue, disabled
behavior, and co-op.

## Observer and contract check

- Observer: [`blank-card-jera-probe.lua`](../../tools/validation/blank-card-jera-probe.lua),
  SHA-256 `618b4dc011c56befffcf5329dd1b8d776785f78463598b3773f86d7a945c1c1a`.
- Harness: [`blank_card_jera_probe_spec.lua`](../../tests/blank_card_jera_probe_spec.lua).
- `lua tests/blank_card_jera_probe_spec.lua` passes locally. This establishes
  the observer contract only, not native Blank Card behavior.
- Collector: [`collect-blank-card-profile.py`](../../tools/validation/collect-blank-card-profile.py).
  It preserves the raw log, exact-prefix JSON records and malformed payloads,
  with source metadata and two-read hashes. A raced capture is diagnostic only.
  Its smallest local smoke passed raw-byte preservation, JSON extraction,
  malformed retention and error reporting. The first native capture passed
  stable-copy and parser checks below.
- It loads as a separate diagnostic mod and starts observing automatically.
  `OUPBlankCardProbe.Snapshot(label)` emits a labeled snapshot;
  `OUPBlankCardProbe.Stop()` removes its exact callbacks.
- Log records use the `OUP_BLANK_CARD` prefix. They include per-player
  collectible/card/pill/slot state and native use callback arguments. The
  `MC_USE_ITEM` observer is filtered to Blank Card (286) and returns nil, so
  native effect and discharge handling remain with the game.
- It does not grant items or cards, write charge, change configuration or
  persistence, or create a gameplay fixture. The harness tests only loading,
  snapshot/use logging, state-change deduplication and exact cleanup. It does
  not simulate native charge behavior or establish game evidence.
- There is no native maximum-charge API in this observer; it records charge,
  battery charge and `VarData` at use as observations, not as a complete native
  charge model.

## Bounded native feasibility batch

- Batch: [`blank-card-jera-batch.lua`](../../tools/validation/blank-card-jera-batch.lua),
  SHA-256 `febcb67b030d00bc8556c423b01509c7a8e36f766104371a30a9c95c5c30f794`.
- Contract harness: [`blank_card_jera_batch_spec.lua`](../../tests/blank_card_jera_batch_spec.lua).
  The local protocol checks use mocked input and battery collection; they are
  not evidence of native input, charge or recharge behavior.
- Staged at `mods\oup_blank_card_issue19_observer\blank-card-jera-batch.lua`;
  staged bytes match the source SHA above. Load it once with
  `luarun mods/oup_blank_card_issue19_observer/blank-card-jera-batch.lua`.
  Then use `OUPBlankCardBatch.Run()` for the smoke, `Status()` to inspect its
  result, and `Stop()` for owner-directed cleanup. Run the `transitions` mode
  only after the one-use smoke is accepted.
- The batch is restricted to one Isaac in a cleared disposable room, Blank Card
  in the primary slot, and no Car Battery. It applies Jera in the disposable
  run, requests the native item action through a scoped input callback, and
  refills with a real spawned battery pickup. It does not call `UseActiveItem`
  or write charge. The transition mode switches to Magician and back to Jera.
  It may leave the disposable run's card, items, runes and effects changed.
- The batch requires exactly one observed native use for each requested action.
  Native input polling may invoke the input callback repeatedly; this strict
  use-count expectation was checked in the engine for the captures below.

## Native feasibility captures

The single-use smoke passed in the one-player Normal Isaac run, seed
`3170816660`, player seed `2828316171`, frames 383–450. With Blank Card (286)
held, Jera (33) produced exactly one native use at frame 389; charge went from
4 to 0, flags were 4 and `VarData` was 0. A real battery pickup
(`2578582492`) restored charge to 4. No Jera `MC_USE_CARD` event was observed.
The main agent cross-checked the raw capture before accepting this bounded
fixture result.

- Capture: `capture-20261114T145101990Z` (session-relative); log 23,845 bytes,
  SHA-256 `c8a6fb6f7a8f2371cb42f0f212d7e155e818e0695a03ad586caa8b35ac038f67`.
- Parsed records: 17, SHA-256
  `dfad0f49cde4c2d7f9e037064627d5c616c7f1ff3b569bdfd75d4215146607d5`; stable
  two-read capture, zero malformed records or matching errors.

The transition batch on the same actor and seed continued through frame 883.
Magician (2) used at frame 756 and reduced charge 4→0; a real battery pickup
(`909118380`) restored 2. After switching back to Jera, its use at frame 822
also reduced charge 2→0; battery `1642800875` restored charge to 2. The batch
completed with three observed uses total, one Blank Card, and no Lua errors.
This shows native use retained the prior two-charge cost after the card switch;
it does not implement or validate a fix.

- Capture: `capture-20261114T135331Z`; log 33,681 bytes, SHA-256
  `b8a6f1eda55b31560ccdbe9b005d550913b0dee5d3adfa388814b40a4e13e56e`.
- Parsed records: 46, SHA-256
  `8b3dbebb265a719e3e82f395288174e7f2e9f3b13163176d5ed5daa892ed8ed2`; stable
  capture, no malformed records or matching errors. Installed batch and probe
  hashes matched their sources. A failed first collector attempt was recovered
  by capture without replaying the game sequence.

The use callback's `VarData` was 0 in these observations and is not a native
current-maximum-charge getter. A separate capacity probe,
[`blank-card-jera-capacity.lua`](../../tools/validation/blank-card-jera-capacity.lua),
and its protocol harness
[`blank_card_jera_capacity_spec.lua`](../../tests/blank_card_jera_capacity_spec.lua)
are available for further investigation. Its mocked accessor/grant and
invariant checks pass locally, but it has not been staged or run in Isaac; no
native capacity result or production-ready implementation is established.

## Session and setup

The owner explicitly handed this issue session to the validation thread for
backed-up disposable runs, restarts and co-op. Session:
`D:\T3ValidationSessions\issue19-20261114T132550Z-e0063e`.

- Game root: `D:\The.Binding.of.Isaac.Repentance.v4.0.2`.
- Profile, saves and log: `C:\Users\Mario\Documents\My Games\Binding of Isaac Repentance+`.
- Pre-test backups: `backup-user` (189 profile files), `backup-data` (8 game
  data files), and `backup-mods` (287 mod files). `before.json` is the snapshot
  manifest, SHA-256 `4af7acc70e3c153672d44c74f4ed1b58190b74fd3129483207d8f91c722b14a7`.
- Executable SHA-256:
  `e5faf6f513c6de9cc9ff1c335ef9c541e2b33fc623aa3b8ffbd2e6a6c0027bb0`.
  The fresh observer session log identifies Repentance+ `1.9.7.17.J460`.
- Observer staging path: `mods\oup_blank_card_issue19_observer\main.lua`,
  with separate metadata. Production mod files are unchanged.
- The only existing configuration mutation is `DebugConsoleEnabled=1` in
  `options.ini`, recorded in the snapshot. Before SHA-256
  `a86c6288bf3175b26142836b8a0560dde5c4db8cee40bf65bf39108d43945e05`;
  after SHA-256
  `35e408664993b2ae21a52efd4e4372f5ac7f9c8938f64426fbbb8dcc65420cdd`.

Start a fresh Normal Isaac run on save slot 1 after confirming the candidate
observer and MCM are loaded from the game log. Record the seed, fresh/Continue
state, actor count, difficulty, active item and settings. First observe a native
Blank Card use with Jera as the baseline; do not infer charge behavior from a
fixture or from `UseActiveItem` calls. Continue only with the issue's remaining
acceptance cases and preserve each run's conditions and log evidence.

## Native startup — pass

The owner started a new Normal Isaac run on slot 1 and opened the console.
The observer independently recorded `continued=false`, difficulty `0`, one
Isaac (`type=0`), seed `3170816660`, player seed `2828316171`, initial D6
(`105`) at six charges, and no held card or pill. `repentogon=false`.
The startup log reports J460 and MCM v113 loaded. No Blank Card use has been
tested yet.

Capture: session-relative `capture-20261114T133120828848Z`. Source length
19,026 bytes, identical before/after metadata and two-read SHA-256
`52ee774f6c73040a1df5c5ff83e4a898c0c0e5972c324566fc14fbfd543a5a43`.
Four parsed records, zero malformed records, no matching Lua errors.
`records.jsonl` SHA-256
`8886bc1c843b67d706234ce027c4d4e08ac5e51900cb32731a86e9ee7dc11af1`;
collector SHA-256
`a79301d74730bb63e9fb8a14a909e90d630fd814e4b46cbe62e73c48a08a4a3b`.
The first collection wrapper failed during command parsing; the corrected
wrapper captured the same session without replaying gameplay.

## Cleanup handoff

After the final owner run, close Isaac, preserve its logs and runtime data, and
archive the diagnostic observer. Restore profile, game data and `options.ini`
against `before.json`, preserving unrelated mods. Retain the original backups;
record post-cleanup hashes and confirm the game is closed. Until that cleanup is
verified, the issue session remains owned by the validation thread.
