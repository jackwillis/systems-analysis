---
name: what-to-test
description: Use when designing tests for a feature, bugfix, or acceptance criterion — especially when asking "what tests do I need?", "how do I test this?", "what should I assert?". Triggers on writing implementation code that needs tests, acceptance criteria that need verification, test design decisions.
---

# What to Test

Predict how the code will break before writing the test. Sources: DeMillo, Lipton & Sayward (1978), Hoare (1969).

## Proportionality

Not every test needs the full sequence. If the guard is obvious, the causal claim is a single assertion, and the failure mode has one plausible shape — answer the three questions in one sentence each and write the test. Run the mutation gate if the test guards something non-trivial. Scale the ceremony to the cost of a missed regression.

## Three Questions

| Question | What it produces | Source |
|----------|-----------------|--------|
| **What are you guarding against?** | The specific regression or acceptance criterion — a thing that could go wrong, not a vague "it should work." | — |
| **What's the causal claim?** | "If [condition], then [behavior]." The test's contract — its reason to exist. | Hoare (1969): precondition, operation, postcondition. |
| **How does it most likely break?** | The predicted failure mode. Determines test placement (unit vs integration), assertion shape, and what negative cases matter. | DeMillo et al. (1978): real faults are small deviations from correct programs (Competent Programmer Hypothesis). |

## Mutate and Verify

After writing the test, verify it guards what you claimed:

1. **State the mutation** in plain English. This is the failure mode from question 3, made concrete: "move the notification call from the elsif branch to the if branch", "delete the nil check", "swap the comparison operator."
2. **Introduce the mutation.** Make the edit.
3. **Run the test.** Show the output.
4. **Confirm failure.** If the test fails: the guard works. Revert and move on. If the test passes: it doesn't guard what you claimed — fix the test or revise your failure prediction.
5. **Revert the mutation.**

Don't reason about whether the test *would* catch the mutation. Introduce it and run the test. Computed results are more reliable than inferred ones.

This is targeted mutation testing (DeMillo et al., 1978): one predicted mutation, one verification. The Coupling Effect suggests tests that catch simple mutations also catch complex ones.

## Red Flags

- **Can't name what breaks.** If you can't state the regression, you can't test for it. Return to question 1.
- **Test mirrors implementation, not behavior.** The causal claim should describe what the user/caller observes, not how the code is structured internally. Implementation-mirroring tests break on refactor and guard nothing.
- **Happy path only.** Question 3 asks how it breaks. If your tests only cover the success path, you skipped the question.
- **Mutation gate skipped.** "I'm sure it works" is not verification. Run it.
- **Test passes with the mutation.** The test doesn't guard what you think. This is the most important signal the skill produces.

## Rationalizations

| Thought | Reality |
|---------|---------|
| "Obviously it needs a test for X" | Obvious tests often test the framework, not the behavior. State the causal claim. |
| "I'll add more tests later" | Later means never, or means after the regression ships. Guard the predicted failure now. |
| "High coverage means it's tested" | Coverage measures execution, not falsification. A test that runs code but asserts nothing has 100% coverage and 0% value. |
| "The mutation gate is overkill" | One edit + one test run. It costs less than debugging the regression it would have caught. |
| "I know this test works" | You know it passes. You don't know it *guards*. Mutate and verify. |

## Honest Limitation

"Testing shows the presence, not the absence of bugs" (Dijkstra). This skill guards against *predicted* failures. The most dangerous bugs are the ones nobody anticipated. For systematic exploration of the failure space beyond prediction, use `is-it-tested`.

## Examples

- [Notification branch guard](examples/notification-branch-guard.md) — predicted branch-move regression, two negative assertions, mutation confirmed

## Arriving From Another Skill

- **From representing-and-intervening:** R&I's Predict phase identified what should happen. The prediction is your causal claim — carry it directly into question 2. The failure mode R&I was least confident about is your priority for question 3.
- **From frame-problem:** A frame audit revealed an assumption that isn't tested. The assumption is your answer to question 1 (what you're guarding against). The frame that could go stale is the failure mode for question 3.

## Transition Signals

- **Need to understand the system before you can predict failures** — suggest **representing-and-intervening** to the user. You need a model before you can predict how it breaks.
- **Want to evaluate the whole suite, not just this change** — suggest **is-it-tested** to the user.
- **Ready to write the test using TDD's red-green cycle** — if **test-driven-development** is available, suggest it. `what-to-test` decides *what*; TDD executes *how*.
- **The predicted failure mode reveals a design problem** — the code is structured in a way that makes the failure likely. Suggest **representing-and-intervening** to the user to model the design before testing around it.

what-to-test is predictive: *what will break, and does the test catch it?*
