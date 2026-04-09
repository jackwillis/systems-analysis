# What to Test

`/what-to-test` — based on DeMillo, Lipton & Sayward (1978), Hoare (1969) · [Full skill](../break-things/skills/what-to-test/SKILL.md)

## When to use

You're about to write tests for a feature or bugfix and need to decide what to guard against. Or you've written a test and want to verify it actually catches the failure it claims to prevent.

Auto-triggers on: "what tests do I need?", "how do I test this?", writing code that needs tests.

## What it does

Three questions, then a verification step:

1. **What are you guarding against?** — name the specific regression or acceptance criterion
2. **What's the causal claim?** — "If [condition], then [behavior]"
3. **How does it most likely break?** — predict the mutation a careless refactor would introduce

Then the **mutation gate**: state the mutation in English, introduce it, run the test, confirm the test fails. If the test passes with the mutation, the test doesn't guard what you think it does.

## What to expect

You'll see Claude focus on one specific failure mode at a time rather than writing a broad test suite. It predicts how the code breaks, writes a test for that break, then verifies the test by actually introducing the predicted mutation and confirming failure.

For obvious tests (null check, basic validation), it scales down — no mutation gate needed for a test that asserts a function exists.

## Example

A status-change handler should send a notification when status becomes "blocked."

- **Guard against:** notification call moved to wrong branch during refactor
- **Mutation:** move `notify_blocked` from the `elsif :blocked` branch to `elsif :resolved`
- **Test:** assert notification sent for "blocked", assert no notification for "active" or "resolved"
- **Verification:** introduce the mutation, run tests — 2 of 3 tests fail. Guard confirmed.
