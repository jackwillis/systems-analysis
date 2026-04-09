# Debug with a Model

`/representing-and-intervening` — based on Hacking (1983), Schon (1983)

## When to use

Something is broken or behaving unexpectedly and you don't know why. You have a guess, but you haven't tested it. Or Claude is about to start changing things without explaining what it thinks is happening.

Auto-triggers on: "why is this happening", unexplained behavior, gaps between expected and observed.

## What it does

Forces a predict-then-observe loop before any fix:

1. **Represent** — state at least two competing models of what's wrong
2. **Predict** — write down what you'd expect to see if each model is correct
3. **Intervene** — pick the cheapest test that distinguishes between models
4. **Observe** — compare prediction to reality
5. **Update** — revise the model or fix the problem

The hard rule: no fix, bypass, or diagnostic action without first stating what you expect and why.

## What to expect

Claude will slow down. Instead of immediately suggesting a fix, it will name two or more possible causes, predict an observable difference between them, and test the cheapest one first. If the first test doesn't distinguish, it picks another.

For simple, obvious problems, the skill scales down — one sentence for the model and prediction, then proceed. It doesn't force ceremony on a typo.

## Example

A test passes locally, fails 30% of the time in CI.

- **Model A:** Missing `ORDER BY` — CI runs tests in parallel, so row order varies
- **Model B:** Race condition in shared test state
- **Distinguishing test:** Check CI config for parallel runner (free, instant)
- **Observation:** Parallel runner confirmed
- **Action:** Add `ORDER BY`, run 50 iterations, all pass

Without the skill, Claude might start adding `sleep` calls for a race condition that doesn't exist.
