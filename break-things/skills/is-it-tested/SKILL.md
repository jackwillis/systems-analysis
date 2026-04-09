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
| **What's the failure space?** | Enumerate what can go wrong — not lines of code, but failure modes. Group by category: data corruption, auth bypass, silent wrong answer, crash, performance regression. This enumeration is the hardest step and the one most likely to be incomplete — the audit's quality is bounded by it. | Beizer (1990): fault-based analysis. |
| **What does the suite guard?** | Map existing tests to failure modes from question 1. For each test, state the causal claim it embodies. Tests that can't be mapped to a failure mode may not be guarding anything. | — |
| **Where are the gaps?** | Failure modes with no corresponding test. This is the variety analysis: D (failure space) vs R (test suite). Unguarded failure modes are the gaps. | Ashby (1956): requisite variety. |

## Enumerating the Failure Space

The first question — "What's the failure space?" — is where the audit succeeds or fails. A missed failure mode is an invisible gap.

**Step 1: Identify the system's boundaries.** What goes in? What comes out? What external systems does it touch? Each boundary is a source of failure modes.

**Step 2: Walk each boundary with four questions.**

| Question | What it finds |
|----------|--------------|
| What if this input is **wrong**? | Data corruption, injection, type errors |
| What if this input is **missing**? | Null paths, silent defaults, crashes |
| What if this input is **late or reordered**? | Race conditions, stale reads, ordering assumptions |
| What if this operation **partially completes**? | Inconsistent state, dangling references, phantom writes |

**Step 3: Group by consequence, not by cause.** Multiple inputs can cause the same failure (e.g., both a malformed webhook and a missing field cause silent data loss). Group by what goes wrong for the user. This avoids double-counting and surfaces the modes that matter most.

**Step 4: Cross-reference with Beizer's fault categories** — data corruption, auth bypass, silent wrong answer, crash, performance regression. If a category has zero entries, ask whether the system is genuinely immune or whether you missed something.

**Step 5: State your confidence.** The enumeration is never complete. Name what you're least confident about. This bounds the audit's reliability.

## When Enumeration Isn't Enough

If your boundary walk produces failure modes that are parameterized — "malformed input" where the malformations are combinatorial, "unexpected state" where the state space is exponential — you've hit a region that enumeration can't cover. The signal: you find yourself writing failure modes with implicit wildcards rather than concrete scenarios.

The response is not to abandon enumeration but to complement it. Use enumeration to map the *structure* of the failure space (which boundaries matter, which consequence categories dominate), then use generative testing — property-based tests, fuzzing — to explore the regions within that structure that are too large to walk by hand. Enumeration tells you *where* to point the generator. The generator covers what enumeration can't.

**Bound the generator.** A generator without boundaries is R1D1 — exploring everything, guarding nothing. For each parameterized failure mode, state: (1) the property that must hold across all values ("parsed output preserves input length"), (2) the input domain to generate from ("valid UTF-8 strings under 10KB"), and (3) the stopping rule ("1000 cases with no failure, or 5 minutes, whichever comes first"). The property comes from your enumeration. The domain comes from the boundary. The stopping rule is a cost decision — state it explicitly rather than running until you feel done.

> **Example:** Your boundary walk of a webhook handler finds "malformed JSON payload" as a failure mode. You can enumerate a few cases (missing required field, wrong type, extra nesting) but the malformations are combinatorial. Bound the generator:
> 1. **Property:** The handler either processes the payload correctly or returns a 400 with a parseable error — it never crashes, never half-writes to the database, never returns 200 with silently wrong data.
> 2. **Domain:** Valid JSON objects up to 50KB with keys drawn from the schema's field names plus random strings, values drawn from the schema's types plus type mismatches and nulls.
> 3. **Stopping rule:** 5000 generated payloads with no property violation, or 2 minutes wall clock.

## Variety Analysis

This is requisite variety applied to testing:

- **D** — failure space (what can go wrong)
- **R** — test suite (what's guarded)
- **E** — system correctness
- **η** — acceptable defect rate

This is a simplification of Ashby's concept — variety in his sense is about distinguishable response states, not a count of categories. A suite with 3 behavioral tests can have more effective variety than one with 40 structural tests. The count is a useful starting point, but what matters is whether each failure mode has a test that would *fail differently* if that mode occurred.

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

A test suite audit reveals *known unknowns* — failure modes you can name but haven't tested. It cannot reveal *unknown unknowns*. For exploring failure spaces beyond what you can enumerate, consider property-based testing, fuzzing, or chaos engineering. These are generative approaches that complement the predictive approach of `what-to-test` and the evaluative approach of `is-it-tested`.

## Examples

- [Webhook handler suite audit](examples/webhook-suite-audit.md) — 40 tests at 85% coverage guarding 3 of 6 failure modes, variety gap analysis
- [ETL pipeline suite audit](examples/etl-pipeline-audit.md) — nightly batch pipeline, boundary-walk enumeration of 5 failure modes, suite oriented toward the least dangerous mode

## Arriving From Another Skill

- **From what-to-test:** You've written targeted tests for a specific change and want to zoom out. The failure modes you predicted in `what-to-test` are seeds for question 1 — but the failure space is broader than any single change.
- **From requisite-variety:** You've done a variety analysis on a system and identified that the test suite is the regulator. Carry D/R/E/η directly into this skill's framework — they map one-to-one.

## Transition Signals

- **Gaps identified, need to write specific tests** — suggest **what-to-test** to the user for each gap. The gap is the answer to question 1 (what you're guarding against).
- **Suite structure itself is the problem** (tests mirror implementation, no failure-mode orientation) — suggest **representing-and-intervening** to the user. The test architecture needs a model before individual tests can help.
- **Failure space is too large to enumerate** — suggest property-based testing or fuzzing as techniques. This is beyond the skill's scope — it identifies the need, not the generative solution.
- **The variety gap reveals a systemic regulation problem** — the suite's D > R is a symptom of a broader control failure (e.g., the deployment process itself has insufficient variety to prevent defects from reaching the suite). If **requisite-variety** is available, suggest it to the user to analyze the full regulatory chain, not just the test layer.

- **Tests that can't be mapped to a failure mode** — suggest **subtraction-audit** to the user. If a test doesn't guard a named failure mode, the component it covers may not earn its keep.

is-it-tested is evaluative: *does the suite's variety match the failure space?*
