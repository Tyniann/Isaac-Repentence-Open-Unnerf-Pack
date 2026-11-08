# Isaac-Repentence-Open-Unnerf-Pack
A pack of modular balance reverts targeting **The Binding of Isaac: Repentance+ v1.9.7.17**.

Compatibility is under validation: no mod-enabled gameplay or multiplayer mode has
yet been verified on this build. See the [per-feature audit and owner test matrix](docs/testing/repentance-plus-1.9.7.17.md) for evidence and outstanding checks.
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
Deployment there must be coordinated with the owner; it currently contains no
installed copy of this pack. To uninstall, exit and remove the fork directory.
Other builds, Greed modes and multiplayer require separate validation.

# Developer checks

With Lua 5.3 installed, run `lua5.3 tests/compatibility.lua` from the repository
root. Syntax-check Lua files with `luac5.3 -p <file>`. The regression harness uses
test doubles and is not a substitute for the engine checks above.
