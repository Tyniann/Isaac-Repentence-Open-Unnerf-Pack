# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [2.1.0] - 2026-11-11

### Added

- Restore absorption of eligible items in ordinary linked choice groups for
  Void, with an independent default-On toggle while retaining Repentance+'s
  four-room charge (#16).

## [2.0.0] - 2026-11-11

### Added

- Provide an installable release ZIP with an `Open Unnerf Pack 2` folder, also
  usable as the Steam Workshop upload payload.
- Restore Magic Mushroom's normal Boss availability and full Treasure weight
  with an independent default-On toggle through optional MCM, using native
  helper-backed pool rules without changing its item effects
  ([#4](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/4),
  [#14](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/pull/14)).
- Add seven independent unnerf toggles through optional Mod Config Menu Pure
  v113, with all supported adjustments enabled by default
  ([#3](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/3),
  [#5](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/pull/5)).
- Save feature choices separately for each Isaac save slot, apply changes to new
  runs, and preserve each continued run's choices across relaunches. Keep saved
  choices usable without MCM and use safe defaults for missing or invalid data
  ([#5](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/pull/5)).
- Add a player feature index and separate references for all supported gameplay
  adjustments, optional configuration, and unfinished disabled helpers
  ([#15](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/pull/15)).

### Changed

- Clear the inherited Workshop publishing ID so this fork can receive its own
  listing while preserving existing saved settings.
- Document verified Repentance+ v1.9.7.17 local Normal/Hard behavior and MCM Pure
  v113 configuration, including the tested conditions and remaining limits
  ([#10](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/pull/10),
  [#13](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/pull/13)).
- Rename the displayed pack and configuration menu to Open Unnerf Pack 2 while
  preserving existing saved settings and internal identifiers
  ([#15](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/pull/15)).
- Rewrite the project README for the maintained fork with original-author
  attribution, installation and configuration guidance, optional-menu screenshot
  and F10 instructions, and feature/changelog links
  ([#15](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/pull/15)).

### Fixed

- Fix Mom's boss-foot stomp bypassing Host Hat and Pyromaniac immunity. Preserve
  one full red heart of Pyromaniac healing per crush impact without granting
  extra healing for the foot's additional contact damage
  ([#2](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/2),
  [#7](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/pull/7)).
- Restore the extra soul-heart roll for explosion damage to blue and purple
  fires in Hard mode, and avoid treating unrelated entities as eligible fires
  ([#6](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/pull/6)).
- Fix Humbling Bundle skipping the first player's inventory when converting
  pickups; check every local player's inventory
  ([#6](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/pull/6)).
- Keep Maw of the Void damage updates independent for each player and refresh
  its bonus when new-run or Continue settings are loaded
  ([#5](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/pull/5),
  [#6](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/pull/6)).
- Prevent Dark Bum and The Relic reward processing from erroring when a familiar
  spawner or owner is missing
  ([#6](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/pull/6)).
