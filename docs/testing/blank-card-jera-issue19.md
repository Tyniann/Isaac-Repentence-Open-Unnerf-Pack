# Blank Card and Jera — issue #19 validation

[Technical documentation](../agents/README.md) ·
[Issue #19](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/19)

## Status

**Native feasibility is partially observed; implementation and acceptance are
pending.** The production callback is present in source but has not been
deployed or engine-validated; no feature acceptance pass is claimed. The owner
clarified the intended timing: preserve Blank Card's
native post-use charge behavior; using Jera sets the cost of its next activation
to four. Do not set four on card selection or grant free charge. The original
“four charges per activation” criterion is superseded. The first Jera use after
Magician may consume the inherited two-charge cost; the subsequent Jera use
should cost four. Four ordinary room clears after Jera, battery and other native
consumable interactions, item swaps, Continue, disabled behavior, and co-op
remain required checks.

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
This records that the first Jera use after Magician retained the prior
two-charge cost. It does not establish a cost on card selection or implement or
validate the owner's clarified next-use timing.

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
are available as an API mechanism trial, not a final cost-timing proposal. It is
staged at `mods\oup_blank_card_issue19_observer\blank-card-jera-capacity.lua`
(5,818 bytes), SHA-256
`4bf95fe188043b1243027fa45a02e6b9e0caa819df548ca1c1d3dd545e575f68`; the
session's `capacity-staging.json` records the staging. Mocked accessor/grant
and invariant checks pass locally.

The J460 mechanism trial started with Blank Card/Jera and charge 2. The
`AddCollectible` path with next cost 4 left ownership count 1, total collectibles
1, Jera, zero collectible pedestals and all active-slot item/charge/battery
values unchanged. API inspection found no `SetActiveVarData`,
`GetActiveItemDesc`, `GetActiveMaxCharge` or `SecondaryActiveItem`; `NeedsCharge`
was present. A real battery (`4226919018`) filled the item to four, the native
smoke used it once and drained it to zero, and a second battery (`1066954075`)
filled it to four again. This tests the capacity mechanism in that disposable
setup; the production callback and the owner's intended next-use timing remain
unvalidated in the game.

- Capture: `capture-20261114T150500Z`; log 39,352 bytes, SHA-256
  `3946db88a56575778839e6690ff72cce4231c7a6c7d7c7345af516de324aa134`.
- Parsed records: 62, SHA-256
  `d2fbd2cda707d700b33979ea36a9995df331ac72616a7270650f48aedd49efe3`; stable,
  zero malformed records or matching errors. The latest collector verified the
  session download hash; the installed-file hash was not independently checked.

## Production On smoke fixture and source staging

- Pending native fixture:
  [`blank-card-jera-on-smoke.lua`](../../tools/validation/blank-card-jera-on-smoke.lua).
  Source SHA-256 `8e6fb7c87996b5cdf009e46aff5c732fb8f24a54b585a48317cb0941a807a130`.
  Its protocol harness is
  [`blank_card_jera_on_smoke_spec.lua`](../../tests/blank_card_jera_on_smoke_spec.lua);
  local controller stubs cover setup, witness handling, failure cleanup and
  foreign-pickup refusal, not Isaac gameplay.
- The fixture requires a fresh Normal Isaac run, one player, the feature On, a
  cleared starting room with no pickups, and D6 or an empty active slot. The
  separate `OUPBlankCardBatch` diagnostic must already be loaded. It grants
  disposable Blank Card/Jera, positions a penny, battery and closed chest away
  from Isaac, then delegates the native use and battery refill to the batch.
  It checks the native Jera use, each pickup doubling, unchanged Jera/Blank Card
  ownership and a four-charge refill; cleanup removes pickups only after the
  empty-room precondition. The fixture has not run in Isaac; it establishes no
  production On behavior.
- Source stager: [`stage-source-pack.py`](../../tools/validation/stage-source-pack.py),
  SHA-256 `3e90769bf976e4d873f1e588a87a58e8a9d0cc84684c58d6a49d51717af0ea2a`;
  protocol harness:
  [`stage_source_pack_spec.py`](../../tests/stage_source_pack_spec.py). The
  helper stages a manifest-pinned runtime tree from raw GitHub files into a new
  directory outside the game. It verifies its source commit, path allowlist, file
  sizes and hashes, metadata identity and XML. It does not install or launch
  Isaac. Its local smallest-case smoke passed exact-byte, safe-path,
  overwrite-refusal and hash-rejection checks. The 22-file runtime manifest
  [`blank-card-jera-runtime.json`](evidence/blank-card-jera-runtime.json) pins
  source commit `4563fd522e3086817c21fc89f1677f63262fc53c`, SHA-256
  `b7026ac330ca2ebc11c5b741d6b9ebb9ed7e27c33aca3d3a36c5708502afd481`. Local
  staging was verified against exact Git-object bytes. This is candidate staging
  only, not game installation, launch, or an engine implementation pass. The
  existing `deploy-test-build.ps1` has an older test folder and observer/MCM
  contract and is not a direct installer for this candidate. Any later
  deployment needs a separate guarded install with a fresh backup, closed game
  and installed-byte verification.
- Frozen one-session swap recipe:
  [`blank-card-jera-install.py`](evidence/blank-card-jera-install.py),
  SHA-256 `93d073fe8e621fc130d4be7303315c8f679150141a6bbc42499f6665a9a37470`.
  It pins the session backup and runtime manifest hashes, verifies the executable
  and protected mod files, checks that Isaac is closed, then moves the original
  pack aside and swaps in the candidate with hash checks and rollback handling.
  Its synthetic local smoke passed; it does not edit profile or game data or
  launch Isaac. The actual installation remains pending and is not an engine
  implementation pass.

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

For further captures, confirm the observer and MCM are loaded from the game log
and record seed, fresh/Continue state, actor count, difficulty, active item and
settings. The native smoke and transition observations above came from the
recorded run; do not infer behavior from a fixture or `UseActiveItem` calls.
Continue only with the issue's remaining acceptance cases and preserve each
run's conditions and log evidence.

## Native startup — pass

The owner started a new Normal Isaac run on slot 1 and opened the console.
The observer independently recorded `continued=false`, difficulty `0`, one
Isaac (`type=0`), seed `3170816660`, player seed `2828316171`, initial D6
(`105`) at six charges, and no held card or pill. `repentogon=false`.
The startup log reports J460 and MCM v113 loaded. At startup, no Blank Card use
had yet been tested.

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
