---
name: subtraction-audit
description: Use when evaluating whether code components earn their keep — especially when asking "is this over-engineered?", "what can we remove?", "this feels heavy", when inheriting unfamiliar code, before a major refactor, or after a feature is complete and feels bloated.
---

# Subtraction Audit

Remove each component. See if something breaks. Inverse of DeMillo et al. (1978): mutation testing asks "introduce a fault, does the test catch it?" — subtraction asks "remove the component, does anything notice?"

## Proportionality

If the codebase is small, the components are few, and nothing feels heavy — say so in one sentence and move on. Don't audit a 50-line module. Scale the audit to the complexity you're questioning.

## Scope the Audit

Name what's in scope: one module, one class, one abstraction layer, one feature. Not "the whole codebase." The audit is only meaningful within a bounded scope — if you can't name the boundary, narrow until you can.

**What counts as a component:** A function, a class, a file, an abstraction layer, a dependency — anything that could be removed as a unit. If removing it requires changing 30 callers, it's load-bearing by construction and the delete test is meaningless. Skip it and note why.

## List the Components

Within your scope, name each discrete component. For each, state its purpose in one sentence. If you can't state the purpose, flag it — that's already a finding.

**Stopping condition:** One scope, one pass. Don't recurse into sub-components unless the audit surface demands it.

## The Delete Test

For each component, remove it (or stub it out). What breaks?

Three outcomes:

1. **Something breaks.** The component earns its keep. Note what depends on it and move on.
2. **Nothing breaks.** Go to the tuition check below.
3. **"I'm not sure."** The component's purpose isn't understood well enough to predict the effect of removal. This is a finding whether you remove it or not — a component whose purpose is unclear is a maintenance risk regardless.

**Reversibility.** If you're actually deleting code: use `git stash` or work in a scratch branch. Don't commit the deletion. The delete test is a probe, not an action.

**Test dependency warning.** The delete test is only as good as the test suite. If tests don't cover the component's purpose, "nothing breaks" may be a false signal — the test suite has a gap, not the codebase has dead weight. If you suspect thin coverage, note it. Don't treat absence of failure as proof of absence.

## Tuition Check (Outcome 2 Only)

When nothing breaks, the default conclusion is "dead weight — remove it." But some components are still teaching you something even if tests pass without them.

**Check:** Before acting on outcome 2, state in one sentence what this component taught you.

- If you can state it clearly and name exactly what you'd build instead: the lesson is extracted. The component is **weight** — it can go.
- If you can't articulate what it taught you, or can't name the replacement: the component may still be **tuition**. Investigate before deleting.

**Signal that tuition has become weight:** "The simple replacement has become visible." You can name exactly what you'd build instead, without the component, and it's simpler. If the replacement is obvious, the component has finished teaching.

This is a check on outcome 2, not a gate on every component. The mechanical part (delete, observe) runs first. The judgment call comes only when the result is "nothing breaks."

## Red Flags

- **Everything passes the delete test.** Either the codebase is genuinely over-engineered, or the test suite has gaps. Before celebrating, check whether `is-it-tested` would agree that the suite guards the failure space.
- **Can't remove anything as a unit.** Everything is entangled. This is a design finding — the codebase lacks seams. Note it.
- **Removing one component cascades.** You tried to remove one thing and 15 things broke. The component is load-bearing. But the dependency chain may reveal unnecessary coupling even if the component itself earns its keep.
- **"We might need it later."** Speculative future use is not current purpose. If nothing references it now and nothing breaks without it, it's weight. Version control remembers.

## Rationalizations

| Thought | Reality |
|---------|---------|
| "It might be useful someday" | Version control remembers. Remove it now, restore it if the day comes. Carrying unused code has a cost. |
| "It's only a few lines" | A few lines times many components is accidental complexity. Small weight adds up. |
| "Someone must have added it for a reason" | They did. The question is whether that reason still holds. |
| "Removing it is risky" | Not removing it is also risky — you're carrying code whose purpose you can't state. The delete test makes removal empirical, not speculative. |
| "The tests don't cover this, so I can't tell" | That's a finding. Flag it and move on — don't treat untestable as load-bearing. |

## Honest Limitation

The subtraction audit finds components that aren't earning their keep *given the current test suite and your current understanding.* It cannot find components that are weight but deeply entangled (removing them is impractical), and it gives false confidence when the test suite has gaps. A component that "compiles, passes all tests, ships to production" can still be architectural weight if callers have been built on top — the delete test won't catch this because removing the component breaks the callers, not the purpose. The tuition check ("would this exist if we were building from scratch today?") is the only gate for that case.

## Examples

- [Discovery tax extraction](examples/discovery-tax-extraction.md) — a wrapper that passes the delete test but the tuition check catches it: the simpler replacement isn't visible yet
- [Dead abstraction layer](examples/dead-abstraction-layer.md) — an adapter that looks load-bearing but turns out to be weight: the direct replacement is obvious and simpler

## Arriving From Another Skill

- **From is-it-tested:** The variety analysis found tests that can't be mapped to a failure mode — they may be guarding phantom components. The subtraction audit checks whether those components earn their keep.
- **From representing-and-intervening:** R&I produced a model of the system. Components whose purpose R&I struggled to articulate are your priority for the audit.
- **From what-to-test:** You wrote tests for a feature and the feature feels heavy. The tests you just wrote give you the safety net to try deletions.

## Transition Signals

- **Delete test reveals test suite gaps** — suggest **is-it-tested** to the user. "Nothing broke" may mean the suite doesn't guard this component, not that the component is dead weight.
- **Component's purpose is unclear (outcome 3)** — suggest **representing-and-intervening** to the user. Understand it before deciding whether to keep it.
- **Removed weight and need to verify remaining code still guards its failure modes** — suggest **what-to-test** to the user for the code that absorbed the removal.
- **The audit reveals systemic over-engineering** — multiple components don't earn their keep. This is a design problem, not a component problem. Suggest **representing-and-intervening** to model the system before removing pieces.

subtraction-audit is subtractive: *remove the component — does anything notice?*
