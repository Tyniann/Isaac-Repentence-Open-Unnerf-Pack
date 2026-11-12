# Void choice absorption

[Technical documentation](README.md) · [Player feature](../features/void.md)

## Implementation

`Mods/Void Choice Unnerf/main.lua` registers a filtered `MC_PRE_USE_ITEM` for
native Void (477). `config.lua` supplies the independent default-On
`voidChoiceAbsorption` setting through the existing version-1 save-slot choices
and run snapshots. This is separate from Maw of the Void.

The module groups collectible pedestals by actual nonzero `OptionsPickupIndex`.
For a group with at least two free, untouched, nonempty pedestals, retain one
original group marker and temporarily unlink its alternatives before native
use. This leaves a native option marker for room events such as Boss Rush,
while the alternatives cannot be discarded by that marker's choice cleanup.
The callback returns nil, leaving native
eligibility, passive rewards, stored abilities, charge and room events to the
engine. It neither grants a collectible nor calls Void a second time.

Genesis is excluded by `GridRooms.ROOM_GENESIS_IDX`. Death Certificate is excluded
by comparing the native pointer of the current **on-grid** room descriptor with
its dimension-2 descriptor. Off-grid rooms can alias across all dimensions and
must bypass this check. `GetRoomByIdx` can return an empty descriptor; check
`Data` before comparing. The same native room may have different Lua wrappers,
so Lua table/userdata equality is insufficient. This uses vanilla APIs; no
REPENTOGON callback or method is required.

## Temporary state and cleanup

An in-memory list retains each changed pickup reference, native seed, collectible
identity and original group. Multiple Void calls before the next update share
that list. No custom absorbed-item state or reward data is saved.

At the next `MC_POST_UPDATE`, restore survivors whose seed, item and zero group
still match. Removed pickups remain removed; morphs and another mod's nonzero
group are respected. Room change, pre-exit and the configuration run-start
listener also restore and clear this temporary state. Ordinary manual pickup
logic has no callback in this module. Native Void retains responsibility for
serializing absorbed effects on Continue.

The target-build probe showed partial native choice cleanup at `MC_USE_ITEM`;
restoring there would assume a completion order the game did not exhibit.
The free active-pair experiment instead verified unlinking before use and
restoration on the next update, with both stored effects firing once on the
subsequent use. This evidence does not replace production regression coverage.

## Validation

- `lua tests/void_choice_spec.lua`: real callback contract with engine stubs.
- `lua tests/config_spec.lua`: nine independent controls, old-save migration,
  MCM absent/present, new-run settings and Continue snapshots.
- `tools/validation/void-choice-probe.lua`: isolated native baseline and initial
  temporary-unlinking experiment; not loaded by production.
- `tools/validation/void-choice-batch.lua`: explicit disposable-run automated
  pilot/matrix. Loading is inert. The batch restarts runs and changes rooms,
  grants fixture items, and supplies the next-run Void choice before config
  loads. It retains the original saved choices and restores them on completion
  and after the pack's pre-exit save. It never resets native absorbed state by
  guessing item-removal APIs; fresh disposable runs isolate cases.

Start with the smallest pilot before broader execution. The API-driven uses
record flags, native callbacks, charge, rewards and owned counts. Physical-use
charge evidence and induced API use are distinct. Controlled RNG seeding for
passive differential checks is a fixture intervention, not natural RNG evidence.
Compare native unlinked controls rather than reimplementing the stat formula.

`CheckContinue` requires an observed Continue of the prepared Apollyon seed,
an active On snapshot and a saved next-run Off choice. It verifies two native
uses without rewriting settings or restarting. State snapshots include the
engine seed before logging; logging must not supply fields required by a check.
Isaac's sandbox exposes `require` but not `package`. Special-room fixtures find
the actual production callback through `Isaac.GetCallbacks`; they do not reload
the module or expose a production-only testing interface.

### Native photo, mystery-item and hidden-active regressions

`RunEdges(true)` is a one-case Mom reward pilot; `RunEdges(false)` runs the
photo and naturally blind alternate-path cohorts with feature Off, an Off
unlinked control, and feature On. Each case starts Isaac afresh, then uses the
native seed command to select the cohort before generating its target floor.
The diagnostic never morphs or hand-spawns the subjects. The photo fixture
records whatever native option indices Mom assigns, including zero; it does
not assume that the pair uses ordinary choice links.

The alternate-path cohort selects a natural two-passive pair with exactly one
hidden presentation, checking at most eight seeds. Selection and rejected
fixtures are logged. This passive cohort does not claim hidden-active timing.

For hidden-active coverage, call `OUPBatch.RunEdges(pilot, 'active')`. The pilot
uses one native-unlinked control; the full run compares Off, native-unlinked,
and On. It searches at most 256 automatic candidate seeds starting at
`1344027539`, with a hard bound of 36,000 update ticks. The fixture must be an
untouched, naturally linked Treasure Room pair: one naturally hidden
`TypeACTIVE` with a safe room-local observable and one visible passive. The
diagnostic records the original identities and presentation; it does not Morph
or spawn either subject. EID's vanilla `IsAltChoice` sprite observer remains a
test-only dependency.

The active case records matching PRE_USE and POST_USE `USE_VOID` counts. Newly
absorbed actives must not execute immediately. On and unlinked-native must store
one copy. A later native use must produce that item's expected observable
effect, and the stored count must persist through another use. Room and run seed
must remain unchanged. Engine observations are **pending**; this path has no
native result yet. Use a fresh closed-game archive and backup before any new
Windows deployment. The earlier issue #17 cleanup receipt remains valid for
its own session, but is not a restore point for this follow-up.

The diagnostic uses the installed EID `IsAltChoice` sprite observer, whose
vanilla path compares question-mark graphics with `Sprite:GetTexel`. EID's
version and source hashes must be captured; this is a test-only observer
dependency, not a production dependency or a REPENTOGON requirement. Do not
substitute Curse of the Blind for natural hidden presentation.

The controls preserve the same seed, native identity, initial group, hidden
state and starting stats. Only the unlinked control explicitly clears the
subjects' links. Each native Void use receives the recorded controlled Void
RNG seed. On must match unlinked-native rewards and consumption; surviving
On choices must recover their original indices. The
[edge-case ledger](../testing/void-choice-edge-cases-1.9.7.17.md) distinguishes
protocol checks, pending engine observations and eventual acceptance.

See the [Void ledger](../testing/void-choice-1.9.7.17.md) for exact deployed hashes,
capture paths, passing comparisons and unexecuted limits. Follow the
[shared game workflow](game-validation.md) for session ownership, log capture and
final diagnostic removal. The session finished with the diagnostic folder
archived, slot-1 test state/settings restored and the production feature retained.
Future batches still require disposable runs and a fresh ownership handoff.
