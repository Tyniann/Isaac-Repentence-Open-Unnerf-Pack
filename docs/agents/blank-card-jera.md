# Blank Card + Jera

[Technical documentation](README.md) ·
[Player feature](../features/blank-card-jera.md) ·
[Issue #19 ledger](../testing/blank-card-jera-issue19.md)

## Implementation and entry points

- **Module:** `Mods/Blank Card Jera Unnerf/main.lua`, loaded by root `main.lua`.
- **Callback:** `MC_USE_ITEM`, filtered to Blank Card (286).
- **Configuration:** `blankCardJera`, default On, stored through the existing
  version-1 config and per-run snapshot.
- **Checks:** `tests/blank_card_jera_spec.lua` covers the callback contract;
  `tests/config_spec.lua` covers the independent saved toggle and callback gate.

## How it works

When enabled, the callback requires Jera in the primary card slot and verifies
that Blank Card is the active item in the reported, nonnegative slot. It uses
`UseCard(Card.RUNE_JERA, USE_MIMIC | USE_NOANNOUNCER)` so the engine performs
Jera's effect without consuming the held rune or playing its announcement.
Afterward, if Blank Card remains in that slot, `AddCollectible` updates the
next-use cost to four while passing through the current charge and ownership.
The callback returns nil, leaving native discharge, animation and battery
handling with the game. It does not write charge when the held card changes,
change global Jera or Clear Rune behavior, or share state between players.

The active-slot check prevents an item mimic from replacing a different active
item. Other cards and consumables, the feature-Off path and charge outside this
matching use remain native.

## Data and state

The new setting is a normal Boolean in the existing config schema. Existing
normalization makes it default On in older version-1 saves; no schema, mod
identity or save-directory change is needed. MCM edits apply to a new run, and
Continue retains the run snapshot. The callback uses no additional persistent
or cross-player mutable state.

## Native feasibility and limits

On J460 with REPENTOGON absent, a separate capacity probe used
`AddCollectible(Blank Card, currentCharge, false, usedSlot, 4)` with Blank Card
held and charge 2. The observed ownership count, total collectibles, card,
pedestals, all slot items/charges and battery charge stayed unchanged. A real
battery pickup then filled charge to four, and the verified native smoke used
Blank Card once and discharged to zero. This validates that capacity-update
mechanism in that disposable context; it is not an engine test of this module.

The preceding native transition capture observed Magician's four-charge use,
then Jera consuming the inherited two-charge cost after switching back. The
owner clarified that Jera sets the *next* cost to four, while preserving the
native post-use timing. The capacity probe is exploratory implementation
evidence, not an alternative timing policy.

The production callback has not yet been deployed or tested in Isaac. Four
ordinary room clears after Jera, the callback's actual native timing, full
battery and other consumable combinations, Schoolbag/slot behavior, other
players, Continue, feature Off, and multiplayer remain to be checked. Do not
claim issue acceptance from the callback contract or capacity probe alone.

## Tools and tests

- `lua tests/blank_card_jera_spec.lua`: mocked callback contract; it does not
  simulate native charge behavior.
- `lua tests/config_spec.lua`: configuration persistence and independent gate.
- `tools/validation/blank-card-jera-probe.lua`: passive observer.
- `tools/validation/blank-card-jera-batch.lua`: native input and real battery
  feasibility sequence for a disposable one-player Isaac run.
- `tools/validation/blank-card-jera-capacity.lua`: isolated capacity mechanism
  trial; use only after its recorded preconditions and verified batch.
- `tools/validation/blank-card-jera-on-smoke.lua`: pending production-feature
  smoke using a separate empty-room fixture.
- `tools/validation/stage-source-pack.py` and
  `tests/stage_source_pack_spec.py`: stage a hash-pinned runtime tree from raw
  GitHub files into a new directory outside the game. Supply a pinned manifest,
  its SHA-256 and an output path, for example:
  `python tools/validation/stage-source-pack.py --manifest <manifest.json> --manifest-sha256 <sha256> --output-dir <outside-game-directory>`.
  The helper verifies file paths, sizes, hashes, metadata identity and XML; it
  never installs or launches the package. The existing
  `tools/validation/deploy-test-build.ps1` targets an older test folder and
  observer/MCM contract, so it is not the installer for this candidate. Any
  later installation needs a separate guarded procedure with the game closed,
  a fresh backup and exact installed-byte checks.
- `tests/blank_card_jera_on_smoke_spec.lua`: controller-protocol stubs for
  setup, native-use witness, failures, cleanup and refusing foreign pickups;
  stubs do not establish game behavior.

The On smoke script must run only in a fresh Normal Isaac run with the feature
On, no existing pickups, and a cleared starting room. It supports Isaac's D6 or
an empty active slot, and requires the separate batch mod's
`OUPBlankCardBatch` global to be loaded. Invoke once with
`luarun mods/oup_blank_card_issue19_observer/blank-card-jera-on-smoke.lua` after
the verified package and diagnostic files are staged. The fixture grants
Blank Card and Jera in the disposable run, places a penny, battery and closed
chest away from the actor, and delegates the single use and battery refill to
the native batch. It checks that each pickup is doubled, Jera is dispatched once,
the rune and single Blank Card remain, and charge returns to four. It removes
pickups only under the empty-room precondition. This production On smoke has not
yet run in Isaac; no engine pass is claimed.

See the [issue-specific ledger](../testing/blank-card-jera-issue19.md) for
session provenance, hashes, evidence and remaining acceptance work.

---
*Last updated: 2026-11-14*
