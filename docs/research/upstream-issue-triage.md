# Upstream issue triage, 2026-11-08

The owner requested separate fork issues for Repentance+ compatibility and actionable reports from the original Workshop listing and GitHub repository. No mod code was changed or gameplay performed. The owner explicitly confirmed that **Open Unnerf Pack is not installed in the inspected Windows game installation**; its files provide base-game evidence only.

## Published issues

| Fork issue | Scope | Triage status |
| --- | --- | --- |
| [#1](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/1) | Repentance+ v1.9.7.17 compatibility | ready-for-agent |
| [#2](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/2) | Investigate stomp immunity with Pyromaniac and Host Hat | needs-info: owner gameplay evidence |
| [#3](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/3) | Optional Mod Config Menu toggles | ready-for-agent |
| [#4](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/issues/4) | Magic Mushroom Boss availability and Treasure weighting | ready-for-agent |

The fork initially had Issues disabled; the tracker was enabled to publish the requested work. Missing canonical triage labels were added. All tickets include acceptance criteria, evidence limits, and blocking information; none requires completion of another entire ticket before work can start.

## Source coverage

All three upstream GitHub issues, including their empty comment collections, were read. An all-state listing returned no additional issues:

- [Upstream #1](https://github.com/KeinNiemand/Isaac-Repentence-Open-Unnerf-Pack/issues/1): individual Mod Config Menu toggles. At [inspected revision e2eb46f](https://github.com/Tyniann/Isaac-Repentence-Open-Unnerf-Pack/tree/e2eb46f53ef2d70f7c1a97d173f8c867e1f8ca89), all Lua files were read; there is no menu integration or persisted user configuration. This is a feature gap, not a gameplay bug.
- [Upstream #2](https://github.com/KeinNiemand/Isaac-Repentence-Open-Unnerf-Pack/issues/2): Magic Mushroom pools and an optional standalone wish. The claim that it was removed from Treasure is corrected by the file findings below. Standalone packaging is recorded as optional follow-up rather than required for the pack revert.
- [Upstream #3](https://github.com/KeinNiemand/Isaac-Repentence-Open-Unnerf-Pack/issues/3): stomp immunity reportedly fails; no reproduction details. Combined with the duplicate Workshop report in fork #2.

Terra 6.1 successfully inspected all 12 displayed Workshop comments visually through the shared browser. The one explicit malfunction report concerns stomp immunity. Soy Milk + Libra is only a question; configuration, damage-revert scope, and EID comments are feature requests/questions. No extra bug was inferred from them. See [comment evidence and direct links](workshop-comments.md).

## Version evidence

The owner corrected the requested version from `1.9.17.7` to **1.9.7.17** and supplied a screenshot whose window title reads `Binding of Isaac: Repentance+ v1.9.7.17`.

Windows installation: `D:\The.Binding.of.Isaac.Repentance.v4.0.2`. Executable FileVersion/ProductVersion fields were blank and the changelog started at v1.7.9b, which initially left the version unresolved. A subsequent read-only executable string scan found **1.9.7.17.J460**, corroborating the screenshot. The folder name and changelog must not be used to override this stronger evidence.

## Base-game file findings

The initial filename search found no extracted item-pool/item/entity XML. A second bounded inspection decoded only the targeted XML records from the resource archives into scratch space, using the [Gibbed.Rebirth parser source](https://github.com/gibbed/Gibbed.Rebirth) as the format reference. All eight decoded records passed their archive checksums. Neither inspection ran a game executable or changed the installation, settings, or save data.

In `resources/packed/repentance.a`, record `resources-dlc3/itempools.xml`, Magic Mushroom (collectible 12) has:

| Pool | Weight | DecreaseBy | RemoveOn |
| --- | --- | --- | --- |
| treasure | 0.5 | 0.5 | 0.05 |
| boss | Absent | — | — |
| greedTreasure | 0.5 | 0.5 | 0.05 |
| greedBoss | 0.2 | 0.2 | 0.02 |
| ultraSecret | 1 | 0.4 | 0.1 |

No other pool in this XML contains ID 12. This installation's `afterbirthp.a` has the same ID 12 data; its filename alone does not prove a historical Afterbirth+ baseline. The inspected `config.a` and `afterbirth.a` definitions include Treasure and Boss entries at `(Weight, DecreaseBy, RemoveOn) = (1, 1, 0.1)`.

Windows scratch evidence, scripts, and exact outputs remain under:

`C:\Users\Mario\.t3\scratch\2026-11-08-act-as-the-research-sub-42ddcece\archive-research\`

These static findings justify filing the pool revert without gameplay. They do not demonstrate effective pools with the mod installed. Fork #4 requires checking the implemented change on the target build.

The installed Lua enums define `DAMAGE_CRUSH = 1<<24` (with a comment mentioning Mom's foot), Pyromaniac 223, Host Hat 375, and Broken Shovel 550. Definitions cannot prove the flags delivered during a real player-damage event. Fork #2 therefore awaits owner gameplay evidence and includes a proposed console-assisted setup, explicitly untested. No verified item-access seed is claimed.

## Remaining human check

Install the fork at a recorded revision before attempting its mod-enabled tests. Fork #2 describes vanilla and mod-enabled comparisons for each protective item, health readings, stomp-source identification, and evidence to return. The proposed Broken Shovel setup avoids item hunting if console use is acceptable; a seed-only alternative would need to be found and validated on this build.
