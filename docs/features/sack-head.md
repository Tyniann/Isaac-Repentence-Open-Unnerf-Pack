# Sack Head

[All features](README.md)

## Overview

Sack Head restores its historical Shop-pool entry and can turn eligible rewards
from a sack into another sack, allowing reward chains. Normal-On and Normal-Off
behavior, natural reward conversion and an actual Greed-mode pool check passed
scoped native checks in Repentance+ v1.9.7.17. The
original test profile was restored and verified. The Greed check covered pools
only; no Greed reward-chain or Greedier run was performed. Implementation and
scoped validation are complete; release publication is separate.

## Behavior

When at least one player holds Sack Head, the implementation applies a 10% roll
to coin rewards from eligible sacks and a 20% roll to bombs, keys, cards, runes
and batteries. Local boundary tests verify these thresholds. Native checks
confirmed natural sack rewards converting and converted sacks producing
further converted sacks; the observed run contained two converted generations
after root sacks. The native sample contained coins, keys, bombs, cards and
batteries, but did not sample troll bomb variants. The check is tied to rewards
spawned by sacks, so other sources retain native behavior. Hearts, pills,
chests, trinkets, collectibles and sacks themselves are ineligible in the
implementation. Having multiple copies or multiple owners does not create
additional rolls for one reward.

With the adjustment enabled, Sack Head is supplied through its historical
normal Shop pool entry (weight 1, `DecreaseBy` 0.5, `RemoveOn` 0.1). Its native
Secret and Greed Secret placements are not retained while enabled. With the
adjustment off, native pool behavior and native sack rewards apply.

## Configuration

- **Status:** Implemented; scoped Normal-On/Off and Greed pool checks passed,
  and original test-profile restoration was verified. Release publication is
  separate.
- **Default:** On.
- **Menu label:** Sack Head.
- **Saved key:** `sackHead`.
- Changes apply to a new run; Continue retains the choices captured for that
  run.

Turn the setting off to use native pool selection and sack rewards. The pack
uses its existing saved settings and optional Mod Config Menu Pure integration.

## Dependencies and validation

The target is Repentance+ v1.9.7.17.J460 with MCM v113; Mod Config Menu Pure is
optional. Native checks verified the six explicit pools in Normal-On, Normal-Off
and actual Greed mode, plus the historical Shop depletion sequence after
clearing the room blacklist between queries. The Normal-Off run also checked
native sack behavior both without Sack Head and while holding the real item.
Normal-On verified real collectible ownership and natural reward conversion
and chain generation. The sample does not estimate the overall conversion rate
or establish general co-op, black-sack or troll-bomb coverage. Greed coverage
was limited to isolated pool availability and depletion; sack-chain behavior
and Greedier remain untested. See the [technical reference](../agents/sack-head.md)
and [issue #20 validation ledger](../testing/sack-head-issue20.md) for evidence
and limits.

---
*Last updated: 2026-11-14*
