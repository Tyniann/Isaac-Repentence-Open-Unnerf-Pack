# Configuration validation — issue #3

## Primary API evidence

Supported implementation: **Mod Config Menu Pure v113**, source revision
`a4c15349c8ed8c38f31bf45bdf5d2896f4e9d23d`.

- [Source](https://github.com/Zamiell/isaac-mod-config-menu/blob/a4c15349c8ed8c38f31bf45bdf5d2896f4e9d23d/scripts/modconfig.lua)
  declares `VERSION = 113`, detects Repentance+, and defines `OptionType.BOOLEAN`,
  `AddSetting`, and `AddText`. Boolean records use `CurrentSetting`, `Display`,
  `OnChange`, and `Info`.
- [Developer guide](https://github.com/Zamiell/isaac-mod-config-menu/blob/a4c15349c8ed8c38f31bf45bdf5d2896f4e9d23d/docs/quick-start.md)
  documents these fields and makes the consuming mod responsible for persistence.
- [README](https://github.com/Zamiell/isaac-mod-config-menu/blob/a4c15349c8ed8c38f31bf45bdf5d2896f4e9d23d/README.md)
  instructs consumers to check the global rather than loading MCM themselves.

The pack checks the global at load and again at game start for late loading.
No bundled or deprecated MCM variant is loaded.

## Automated checks

Requirements: Lua 5.4 and dkjson (`lua5.4` and `lua-dkjson` on Debian/Ubuntu).
The game supplies its own `json`; dkjson is only a test dependency.

```sh
lua tests/config_spec.lua
curl -fsSL https://raw.githubusercontent.com/Zamiell/isaac-mod-config-menu/a4c15349c8ed8c38f31bf45bdf5d2896f4e9d23d/scripts/modconfig.lua -o /tmp/ounp-modconfig.lua
lua tests/config_spec.lua /tmp/ounp-modconfig.lua
find . -name '*.lua' -print0 | xargs -0 -n1 luac -p
```

Both harness modes pass 14 checks. Optional source mode executes the upstream
registration helpers from OptionType through AddText, rather than substituting
those helpers. It does **not** execute MCM's rendering/input loop or Isaac.
The suite also switches save-slot backing data without reloading Lua to check
that one slot cannot overwrite another's choices or Continue snapshot.
Fixtures test all seven callback gates independently; soul-heart helper spies
verify dispatch isolation, not the helpers' engine behavior. Existing gameplay
bugs remain in scope for issue #1/#2, not fixed or certified by these tests.

## Owner gameplay handoff (not yet performed)

The inspected Windows installation is vanilla: **the pack is not installed**.
No mod-enabled gameplay, installation, game control, or settings/save edits were
performed by this thread. Coordinate deployment with the owner first: record
this PR's exact head SHA, back up the target mods directory and pack save data,
install that revision as a separate mod folder with `main.lua` and `metadata.xml`
at its root, enable it and only MCM Pure v113 for the present-case test. Use
Repentance+ **1.9.7.17** and a disposable run. The owner must enable/open the
console if needed; no agent should alter the running game or its settings.

[Console syntax](https://github.com/wofsauge/IsaacDocs/blob/main/docs/tutorials/DebugConsole.md)
and [collectible IDs](https://github.com/wofsauge/IsaacDocs/blob/main/docs/enums/CollectibleType.md)
provide console-assisted item access; no item-access seeds are claimed here.

1. With pack data absent/backed up, start Isaac on Hard. Open MCM with F10.
   Confirm exactly seven On toggles; Nail and Satanic Bible absent. Record logs.
2. Change one toggle Off. Confirm the current run retains its behavior. Exit,
   relaunch, Continue: confirm both the displayed Off choice and the old run's
   On behavior. Start a **new** run: confirm Off behavior. Repeat for each toggle,
   leaving the other six On. Compare against a pack-disabled vanilla run using
   the same item setup; record enabled and disabled outcomes separately.
3. Item setups (one per fresh-run comparison):
   - Maw: `giveitem c399`. Compare damage before/after taking it, and kill enemies
     with the charged ring. Off must add no pack damage or pack black-heart chance.
   - Orbitals: `giveitem c73` (Cube of Meat). Compare contact damage/hitbox across
     separate fresh runs. Off must not double damage/enlarge size. Do not infer
     restoration by toggling during the same run.
   - Stomp immunity: `giveitem c375` (Host Hat), then encounter a stomping enemy
     such as Mom; repeat separately with `giveitem c223` (Pyromaniac). Record the
     actual crush-hit outcome. If enabled immunity fails, report it against #2;
     no root cause or successful immunity is assumed.
   - Humbling Bundle: `giveitem c203`. Clear rooms and inspect naturally selected
     pennies/keys/bombs/full hearts. Do not use forced pickup spawning as proof
     of the pickup-selection callback. Compare a sample against vanilla.
   - Dark Bum: `giveitem c278`, then `spawn 5.10.1` repeatedly for full red hearts
     to feed him (stay at full red health). Observe multiple payouts as Isaac;
     Off must leave payouts unmodified, On dispatches the soul-heart replacement.
   - Relic: `giveitem c98`. Clear successive combat rooms and record payout
     intervals; compare with vanilla. Existing counters are not restored live.
   - Blue fires: on Hard, `spawn 33.2.0`, bomb the fire; repeat across many fires.
     Compare soul-heart payouts with vanilla. This is probabilistic: a single
     missing/present drop proves nothing. Log any Lua error separately from rates.
4. Save at least one Off choice, exit, disable MCM, relaunch and start a new run.
   Confirm pack loads without errors, retains choices and the corresponding
   disabled mechanic; re-enable MCM and confirm its controls reflect the choices.
5. On backed-up disposable pack save data only, test invalid JSON, missing file,
   wrong schema version and individual malformed fields per README fallback.
   Relaunch and confirm defaults; retain logs. Restore the original data after.
6. Save different choices and continued runs in two disposable save slots.
   Switch between them without restarting the game; confirm each slot retains
   its menu choices and run snapshot, then starts new runs with its own choices.
   The harness covers both equal and different seeds, with MCM present/absent.

Outstanding acceptance: real MCM UI/input, engine callback ordering (particularly
initial cache/familiar updates), exit/relaunch/Continue in-engine, absent MCM
loading, and seven independent vanilla comparisons on 1.9.7.17. Do not close #3
or merge claiming these are complete until evidence is recorded. Compare the
parallel issue-1 compatibility branch/PR before integration; both edit modules.
