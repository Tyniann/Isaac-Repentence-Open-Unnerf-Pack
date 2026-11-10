# Open Unnerf Pack

Open Unnerf Pack restores selected item and mechanic buffs in **The Binding of
Isaac: Repentance+**. Choose the adjustments you want, or play with all supported
unnerfs enabled by default.

This is the maintained fork of [KeinNiemand's original Open Unnerf
Pack](https://github.com/KeinNiemand/Isaac-Repentence-Open-Unnerf-Pack), continued
by [Tyniann](https://github.com/Tyniann) with compatibility fixes, configurable
unnerfs, and updated documentation.

[Feature index](docs/features/README.md) · [Changelog](docs/CHANGELOG.md) ·
[Report a bug or suggest an adjustment](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues)

## Features

The pack currently includes seven independently configurable adjustments:

- [Maw of the Void](docs/features/maw-of-the-void.md): restore bonus damage and
  black-heart drops from qualifying dark rings.
- [Orbitals](docs/features/orbitals.md): increase contact damage and collision
  size for qualifying orbital familiars.
- [Stomp immunity](docs/features/stomp-immunity.md): restore protection with
  Host Hat and Pyromaniac, including Pyromaniac healing on crush impacts.
- [Humbling Bundle](docs/features/humbling-bundle.md): turn eligible single
  hearts, pennies, keys, and bombs into double packs.
- [Dark Bum](docs/features/dark-bum.md): convert eligible pickup rewards into
  soul hearts, with character exclusions.
- [The Relic](docs/features/the-relic.md): adjust its room-clear counter for
  soul-heart generation.
- [Hard-mode blue and purple fires](docs/features/blue-fires.md): add an extra
  soul-heart chance on eligible explosion-damage events.

The [feature reference](docs/features/README.md) explains each adjustment,
its restrictions, and its tested behavior. The Nail and Satanic Bible helpers
remain unfinished and disabled.

## Compatibility

The current target is **Repentance+ v1.9.7.17**. Compatibility and configuration
have been checked in representative local Normal and Hard runs. See the
[validation results](docs/testing/issue-1-engine-results.md#acceptance-matrix)
for the tested conditions and limits; other game builds, Greed modes, and
multiplayer have separate validation requirements.

## Installation

1. Close the game and download this repository as a ZIP, or clone it.
2. Create an `open unnerf pack` folder inside your active Repentance+
   installation's `mods` directory.
3. Copy the extracted repository contents into that folder. The layout should
   include `mods/open unnerf pack/main.lua`, `metadata.xml`, `config.lua`, and
   `Mods/` directly inside the pack folder. GitHub ZIPs add an outer directory;
   avoid copying that as an extra nested folder.
4. Disable duplicate copies of the original pack or standalone versions of the
   same unnerfs. Launch the game, enable **Open Unnerf Pack** in the Mods menu,
   and start a new run.

For manual updates, close the game and replace the files in the same pack
folder. To uninstall a manual copy, close the game and remove that folder.

## Configuration

All seven supported unnerfs default to **On**. To choose them individually,
install the optional [Mod Config Menu
Pure](https://steamcommunity.com/sharedfiles/filedetails/?id=2681875787) and open
**Open Unnerf Pack → Unnerfs**. The integration has been validated with
**MCM Pure v113**.

Settings save immediately and apply when you **start a new run**. Continuing a
saved run keeps that run's choices, even after restarting the game. Settings are
stored separately for each Isaac save slot. Without MCM, the pack uses saved
choices or its all-On defaults.

See the [configuration guide](docs/features/configuration.md) for menu controls,
Continue behavior, and saved-setting details.

## Bugs, suggestions, and contributions

Use [this fork's issue
tracker](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues) for
bug reports and suggestions. For a bug, include the game version, pack revision,
enabled unnerfs and other mods, reproduction steps, and expected versus actual
behavior. A seed or console setup and relevant Lua errors help make reports
reproducible.

Contributions are welcome. Keep adjustments in their own modules under `Mods/`;
use `main.lua` for loading modules and shared pack behavior. Include appropriate
checks, feature documentation, and a [changelog](docs/CHANGELOG.md) entry for
user-visible changes. The [compatibility test
guide](docs/testing/repentance-plus-1.9.7.17.md) and [configuration validation
guide](docs/configuration-validation.md) describe the existing test setups.

## Credits and license

**KeinNiemand** created the original Open Unnerf Pack. This fork builds on that
work and preserves the original attribution and license.

- [Original source repository](https://github.com/KeinNiemand/Isaac-Repentence-Open-Unnerf-Pack)
- [Original Steam Workshop listing](https://steamcommunity.com/sharedfiles/filedetails/?id=2554325871)
- [Maintained fork](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack)

The Workshop link above belongs to the original project. Development and support
for this fork take place in this repository.

Released under the [MIT License](LICENSE), including the original
`Copyright (c) 2021 KeinNiemand` notice.
