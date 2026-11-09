# Subagents and orchestration

The main agent coordinates the task and owns its outcome. Task selection,
difficult analysis, architecture, complex implementation, and final assessment
remain with the main agent. Computer use follows the mandatory delegation rule
below. A detailed handoff does not turn design or integration into routine work.

## Routine work: Luna

**Delegate all simple and routine tasks to `gpt-6-luna` with reasoning effort
`medium`.** This includes file and symbol searches, inventories, focused
research, fact extraction, summaries, clearly bounded mechanical changes, and
execution of verified validation recipes. Batch small tasks; search and research
assignments remain read-only.

The only exceptions are instruction reading immediately required for the task;
settings and responsibility checks before delegation; the first
verification of a new or changed recipe on the smallest end-to-end case; and a
focused cross-check of a decisive subagent finding before the main agent's
assessment. Limit each access to that prerequisite, test case, or finding. These
exceptions do not permit general search or research, complete test matrices, or
repeated routine execution, and do not override mandatory computer-use
delegation.

Luna executes the supplied recipe through the repo's maintained runners or
adapters where available. New replacement launchers, package verifiers, and
changes to validation meaning, renderer selection, or thresholds are outside
routine execution. The main agent may explicitly authorize individual mechanical
setup corrections in the assignment without changing those requirements. Other
decisions return to the main agent with evidence of the failure.

## Validation procedures: main agent

The main agent designs and makes substantial changes to test fixtures,
launch/render/capture/encoding drivers, export and package checks, and validation
contracts, including renderer, environment, and test-data selection. Execution
involving computer use follows the mandatory Terra rule, including smoke checks.

Use maintained validation entry points where available. Select checks for the
actual change while retaining the issue's acceptance criteria. Verify a new or
changed recipe on the smallest end-to-end case first, including environment,
build or renderer, game state, and camera where relevant. Record the invocation
and result before delegating broader execution.

After a failure, distinguish product, verifier, and environment faults with a
focused check. Repeat an unchanged check only for an evidenced transient failure
or a bounded diagnostic purpose. Preserve the original change's required coverage
through fixes and handoffs; a narrow final correction does not erase earlier
validation obligations. Saved evidence supports diagnosis and reuse only where
its inputs and acceptance conditions remain valid. Computer use still goes to
Terra.

## Computer use: Terra

**Delegate all computer-use tasks to `gpt-6.1-terra` with reasoning effort
`xhigh`.** This includes browser control, Playwright (including headless), desktop
and GUI operation, and capturing screenshots, including individual
captures and MCP screenshots. This rule applies regardless of difficulty or
automation level and takes precedence over the Luna rule and exceptions for the
main agent's own checks.

Inspect images or screenshots already provided in chat directly using the current
model's image capabilities. This is not computer use and requires no delegation.

Running console commands alone does not constitute computer use. Here, computer
use means interacting with the computer's visual interface: moving the mouse,
clicking controls, filling out forms, inspecting windows, or taking screenshots.
A console command that performs those actions still counts as computer use.

Pure file, shell, or API work without those activities follows the other role
boundaries; writing a browser or capture script alone is not computer use. Split
mixed assignments by responsibility before delegating. If computer use becomes
necessary during a subtask, the subagent reports that need to the main agent,
which delegates it to Terra. Respect applicable MCP access requirements and
shared-resource locks.

## Handoff and oversight

The prescribed subagent reasoning efforts are mandatory. Neither the main agent
nor subagents may change them based on perceived task difficulty.

Set model and effort explicitly. Provide the goal, context, permitted changes,
verified recipe and prerequisites where a procedure applies, and completion and
stop criteria. Require concise results with sources and unresolved uncertainty.
Delegate independent work in parallel where useful, and cross-check decisive
findings directly.

Subagents complete their own assignments, claim no independent issues, and start
no further subagents. Mandatory delegation is the main agent's responsibility.

Check availability of the required model and effort before invocation. If either
is unavailable or differs from the required setting, report the blocker without
substituting another model or effort.

## Coordinating concurrent work

Before assigning work, establish the current branch, active work, ownership, and
blockers. Follow `docs/agents/issue-tracker.md` for this repo's GitHub Issues and
avoid duplicate claims. Subagent assignments remain within the main task's scope.

Give concurrent writers distinct file ownership or isolated checkouts managed by
the available orchestration tools. Verify the branch and checkout ownership;
respect other agents' working files. Separate checkouts still require coordination
for shared resources and integration.

The main agent integrates results, resolves conflicts, and assesses the combined
change against the original task and acceptance criteria. Preserve decisions,
evidence, outstanding checks, blockers, and the next concrete step so another
agent can resume without conversation history. An interrupted assignment needs a
recoverable handoff rather than a claim of completion.
