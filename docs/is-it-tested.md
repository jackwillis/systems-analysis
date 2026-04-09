# Is It Tested

`/is-it-tested` — based on Ashby (1956), Beizer (1990) · [Full skill](../break-things/skills/is-it-tested/SKILL.md)

## When to use

You want to know whether an existing test suite actually guards the system, not just covers the code. Useful after a refactor, before a release, when inheriting an unfamiliar codebase, or when tests pass but production keeps breaking.

Auto-triggers on: "is this well-tested?", "are we testing the right things?", "our tests pass but production breaks."

## What it does

Compares two things: the failure space (everything that can go wrong) and the test suite (what the tests actually catch).

1. **Enumerate the failure space** — walk the boundaries of the system and list failure modes by category
2. **Map the suite** — for each test, identify which failure mode it guards against
3. **Find the gaps** — failure modes with no corresponding test

When the failure space is too large to enumerate (combinatorial inputs, exponential state), the skill identifies this and recommends complementing enumeration with generative testing (property-based tests, fuzzing) — but scoped by the enumeration, not unbounded.

## What to expect

The skill asks Claude to produce a table mapping failure modes to tests and highlight the gaps — naming specific failure categories (idempotency, ordering, partial failure) rather than reporting coverage percentages.

## Example

A webhook handler has 40 tests at 85% coverage. The skill enumerates 6 failure categories: replayed webhooks, out-of-order events, malformed payloads, auth bypass, unknown event types, partial failure. The suite guards 3 of 6. Two recent production incidents were in the unguarded categories.

85% coverage, 50% of failure modes guarded.
