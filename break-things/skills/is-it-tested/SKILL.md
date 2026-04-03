---
name: is-it-tested
description: Use when evaluating whether an existing test suite adequately guards a system. Triggers on "is this well-tested?", "are we testing the right things?", "our tests pass but production breaks", "what's missing from our test coverage?", after a refactor, before a major release, when inheriting an unfamiliar codebase.
---

# Is It Tested

Evaluate whether a test suite's variety matches the failure space it guards. Sources: Ashby (1956), Beizer (1990).

## Proportionality

Not every suite needs a full audit. If the codebase is small, the failure space is obvious, and you can state "the tests cover X, Y, Z and miss nothing critical" in a sentence — do that. Scale the audit to the cost of an undetected failure reaching production.

## Three Questions

| Question | What it produces | Source |
|----------|-----------------|--------|
| **What's the failure space?** | Enumerate what can go wrong — not lines of code, but failure modes. Group by category: data corruption, auth bypass, silent wrong answer, crash, performance regression. | Beizer (1990): fault-based analysis. |
| **What does the suite guard?** | Map existing tests to failure modes from question 1. For each test, state the causal claim it embodies. Tests that can't be mapped to a failure mode may not be guarding anything. | — |
| **Where are the gaps?** | Failure modes with no corresponding test. This is the variety analysis: D (failure space) vs R (test suite). Unguarded failure modes are the gaps. | Ashby (1956): requisite variety. |

## Variety Analysis

This is requisite variety applied to testing:

- **D** — failure space (what can go wrong)
- **R** — test suite (what's guarded)
- **E** — system correctness
- **η** — acceptable defect rate

If D > R, the suite has gaps. The question is whether the unguarded failure modes matter. Prioritize by: (1) severity of the failure, (2) likelihood given anticipated changes, (3) cost to add the guard.

## Red Flags

- **High coverage, low falsification.** Tests execute code but assert nothing meaningful. Coverage measures presence, not power.
- **Tests mirror implementation structure.** One test file per source file, testing internal methods. Refactors break every test without catching any bug.
- **All tests are happy path.** The failure space is dominated by edge cases, error paths, and unexpected inputs. If the suite only tests success, it's guarding the least likely failure mode.
- **Tests pass with mutations.** If you can delete a conditional branch and no test fails, that branch is unguarded. This is systematic mutation testing — the generalization of `what-to-test`'s targeted gate.
- **"We have integration tests."** Integration tests cover interaction paths but often miss specific failure modes. They're necessary but not sufficient.

## Rationalizations

| Thought | Reality |
|---------|---------|
| "We have good coverage" | Coverage measures execution, not falsification. 90% coverage with weak assertions is 90% false confidence. |
| "The tests pass" | Passing tests prove the tests pass. They don't prove the system is correct. |
| "We'd catch it in code review" | Code review catches what reviewers think to look for. Tests catch what you predicted once and encoded permanently. |
| "Property-based testing is overkill" | For failure spaces too large to enumerate, generative testing is the only way to reach adequate variety. It's not overkill — it's requisite. |
| "We'll add tests when something breaks" | Reactive testing means every bug ships once. Predictive testing means it doesn't. |

## Honest Limitation

A test suite audit reveals *known unknowns* — failure modes you can name but haven't tested. It cannot reveal *unknown unknowns*. For exploring failure spaces beyond what you can enumerate, consider property-based testing (Claessen & Hughes, 2000), fuzzing, or chaos engineering. These are generative approaches that complement the predictive approach of `what-to-test` and the evaluative approach of `is-it-tested`.

## Examples

- [Webhook handler suite audit](examples/webhook-suite-audit.md) — 40 tests at 85% coverage guarding 3 of 6 failure modes, variety gap analysis

## Arriving From Another Skill

- **From what-to-test:** You've written targeted tests for a specific change and want to zoom out. The failure modes you predicted in `what-to-test` are seeds for question 1 — but the failure space is broader than any single change.
- **From requisite-variety:** You've done a variety analysis on a system and identified that the test suite is the regulator. Carry D/R/E/η directly into this skill's framework — they map one-to-one.

## Transition Signals

- **Gaps identified, need to write specific tests** — suggest **what-to-test** to the user for each gap. The gap is the answer to question 1 (what you're guarding against).
- **Suite structure itself is the problem** (tests mirror implementation, no failure-mode orientation) — suggest **representing-and-intervening** to the user. The test architecture needs a model before individual tests can help.
- **Failure space is too large to enumerate** — suggest property-based testing or fuzzing as techniques. This is beyond the skill's scope — it identifies the need, not the generative solution.

is-it-tested is evaluative: *does the suite's variety match the failure space?*
