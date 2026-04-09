# Subtraction Audit

`/subtraction-audit` — inverse of mutation testing (DeMillo et al., 1978) · [Full skill](../break-things/skills/subtraction-audit/SKILL.md)

## When to use

Code feels heavy, over-engineered, or inherited from a context that no longer applies. You want to know what can be removed. Or you've just finished building something and suspect it's more complex than it needs to be.

Auto-triggers on: "is this over-engineered?", "what can we remove?", "this feels heavy", inheriting unfamiliar code, before a major refactor, after a feature is complete and feels bloated.

## What it does

Scopes to one module, class, or abstraction layer, then tests each component by removal:

1. **Scope** — name the boundary (one module, one class, one feature)
2. **List components** — name each discrete component and state its purpose in one sentence
3. **Delete test** — for each component, remove it. Three outcomes:
   - **Something breaks** — earns its keep, move on
   - **Nothing breaks** — go to tuition check
   - **"I'm not sure"** — the component's purpose is unclear, which is a finding regardless
4. **Tuition check** — when nothing breaks, ask: has this component finished teaching you? Can you name the simpler replacement? If yes, it's weight. If no, investigate before deleting.

## What to expect

You'll see Claude actually remove or stub each component and observe what happens, not reason about whether removal would be safe. It distinguishes between dead weight (lesson extracted, remove it) and tuition (still teaching, keep it until the replacement is visible).

For small, straightforward codebases: one sentence stating nothing feels heavy, then proceed.

## Example

An API has a `StorageAdapter` interface with one implementation (`PostgresStorage`), introduced for a DynamoDB migration that never happened. 14 callers.

- **Delete test:** Remove the adapter, rename the implementation to `Storage`, update callers. Tests pass. The adapter was a 1:1 pass-through — no logic, no transformation.
- **Tuition check:** The lesson (isolate DB access behind an interface) is well-understood. The replacement (direct calls) is obvious and simpler.
- **Verdict:** Weight. The adapter carries a decision that was never validated. Remove it.

The 14 callers made it look load-bearing — but "load-bearing by callers" is not the same as "earns its keep." Removal required only mechanical find-and-replace, not design changes.
