# Isaac-Repentence-Open-Unnerf-Pack
A pack of modular balance reverts targeting **The Binding of Isaac: Repentance+ v1.9.7.17**.

Compatibility is under validation. Fresh local Normal loading, relaunch/Continue,
single-copy Maw damage/removal, and bounded Sacrificial Dagger field checks have
been observed on this build. Full feature compatibility, combat/RNG behavior,
other modes and multiplayer remain unverified. See the
[per-feature audit and owner test matrix](docs/testing/repentance-plus-1.9.7.17.md)
and [engine results ledger](docs/testing/issue-1-engine-results.md) for the exact
conditions, evidence and outstanding checks.
The optional MCM configuration has also been exercised with Pure v113 on this
build: persistence, fallback, Continue/save-slot behavior, operation without MCM,
and seven independent gate effects. See the [configuration results](docs/testing/configuration-results-1.9.7.17.md)
for the tested scenarios and their limits.
Steam Workshop link: https://steamcommunity.com/sharedfiles/filedetails/?id=2554325871

# Unnerfs Currently Included
- Maw of the Void Unnerf
- Humbling Bundle Unnerf
- Orbital Unnerf
- Stomp Immunity Unnerf
- Soul Hearth Generator Unnerf
  - Dark Bum Unnerf
  - Relic Unnerf
  - Blue Fires (hard mode) Unnerf
  - (disabled in code) Nail Unnerf
  - (disabled in code) Satanic Bible Unnerf 

# What this mods tries to do
This mod tries to unnerf things(items, mechanics, ...) that have been nerfed in the Binding of Isaac Repentence and make them work like before they got nerfed. It does so by loading other mods included in this mod.

# Suggestions/Bug Reports
If you want to suggest new unnerfs, improvements or report bugs please create an Issue.

# How this mod is structured/works
Individual lua mods/unnerfs are located in a sub folder in the Mods folder, they are then loaded in main.lua using require().
main.lua should only be used for loading individual mods or handling stuff that affects all mods like config.
Non lua mods should be where they have to be.

# Contributing
If you want contribute to this unnerf pack by adding more unnerfs, fixing bugs or improving this mod in any other mods feel free to create pull requsts. Please follow the struce above. Do not add your unnerf directly into main.lua it should instead be added to a new folder inside the Mods folder then loading in main.lua using require().

# Configuration
Install [Mod Config Menu Pure](https://steamcommunity.com/sharedfiles/filedetails/?id=2681875787)
(optional), then open **Open Unnerf Pack → Unnerfs** in its menu (default key: L or F10).
All seven supported unnerfs default to On, including Humbling Bundle. The Nail and
Satanic Bible remain disabled and have no controls.

Changes save immediately but apply only when you **start a new run**. Continue
keeps that run's choices, even after exiting and relaunching. This preserves
already-mutated orbital damage/size and Relic counters rather than attempting
to undo them live. Maw damage is re-evaluated at run start. The menu shows choices
for the next new run, which may differ from the current run.

Without MCM, the pack uses saved choices or all-On defaults. Data is stored via
the pack's own Isaac `SaveData`, not in MCM. Missing/invalid JSON or an unknown
schema version defaults all seven to On. Within version 1, missing/non-boolean
fields default individually to On; unknown fields are ignored. Continue without
a matching saved run seed uses saved choices (including runs predating this
feature). Settings and the latest run snapshot are stored separately for each Isaac save
slot and reloaded at game start, including when switching slots without
relaunching the game.

The integration targets **MCM Pure v113**, inspected at revision
[`a4c15349c8ed8c38f31bf45bdf5d2896f4e9d23d`](https://github.com/Zamiell/isaac-mod-config-menu/blob/a4c15349c8ed8c38f31bf45bdf5d2896f4e9d23d/scripts/modconfig.lua).
See [configuration validation](docs/configuration-validation.md) for reproducible
checks and [owner/engine results](docs/testing/configuration-results-1.9.7.17.md)
for the executed Repentance+ **1.9.7.17** configuration cases. Broader combat,
drop-rate, character and mode compatibility remains tracked separately in #1.

# Install for local validation

1. Exit the game. Record the fork commit SHA being tested; download/extract that
   revision (GitHub archives add an outer directory).
2. Copy the directory containing `main.lua`, `metadata.xml` and `Mods/` into the
   active Repentance+ installation's `mods/open unnerf pack/` directory. Avoid an
   extra nested directory: `mods/open unnerf pack/main.lua` must exist.
3. Disable the original Workshop pack and any duplicate standalone unnerfs so
   callbacks are not registered twice. Enable this pack in the game's Mods menu.
4. Start a disposable local run, then test quit/Continue. Record any console or
   log errors and follow the linked matrix for Normal/Hard vanilla comparisons.

For the owner's inspected installation the intended destination is
`D:\The.Binding.of.Isaac.Repentance.v4.0.2\mods\open unnerf pack\`.
The coordinated validation deployment is recorded in the engine results ledger;
further changes there must be coordinated with the active session owner. To
uninstall a normal local copy, exit and remove the fork directory. For the shared
validation installation, use its recorded backup/restore plan.
Other builds, Greed modes and multiplayer require separate validation.

# Developer checks

With Lua 5.3 installed, run `lua5.3 tests/compatibility.lua` from the repository
root. Syntax-check Lua files with `luac5.3 -p <file>`. The regression harness uses
test doubles and is not a substitute for the engine checks above.
