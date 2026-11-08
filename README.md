# Isaac-Repentence-Open-Unnerf-Pack
A mod for The Binding of Isaac Repentance that combines diffrent unnerf mods into a single mod.
Steam Workshop link: https://steamcommunity.com/sharedfiles/filedetails/?id=2554325871

# Unnerfs Currently Included
- Maw of the Void Unnerf
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
feature). Only the most recent run's snapshot is retained; switching save slots
can therefore lose the older run's snapshot. Avoid changing slots during a
stateful configuration test.

The integration targets **MCM Pure v113**, inspected at revision
[`a4c15349c8ed8c38f31bf45bdf5d2896f4e9d23d`](https://github.com/Zamiell/isaac-mod-config-menu/blob/a4c15349c8ed8c38f31bf45bdf5d2896f4e9d23d/scripts/modconfig.lua).
See [configuration validation](docs/configuration-validation.md) for reproducible
checks and outstanding Repentance+ **1.9.7.17** gameplay validation. Engine support
is a validation target, not a result established by the Lua harness.
