# Proposal: Subtraction Audit

## The problem

Every LLM is additive. They suggest features, add abstractions, create files. The existing skill suite reinforces this — every skill adds structure. Nothing asks "what should we remove?"

"Is this over-engineered?" is currently a judgment call. A subtraction audit makes it empirical: delete the thing, see if something breaks.

## Core mechanism

For each component/abstraction/feature in scope: what happens if we delete it? Does the system still meet its requirements?

Three outcomes:
1. **Something breaks.** The component earns its keep. Move on.
2. **Nothing breaks.** The component is dead weight. Remove it.
3. **"I'm not sure."** The component's purpose isn't understood — which is a problem whether you remove it or not.

Outcome 3 is the most interesting. It surfaces components that exist for forgotten reasons — the code equivalent of "we've always done it this way."

## Relationship to existing skills

- **Inverse of what-to-test's mutation gate.** what-to-test says: "introduce a fault, confirm the test catches it." Subtraction audit says: "remove the component, confirm something breaks." Same mechanism, opposite direction.
- **Operationalizes CLAUDE.md's Critic Mode.** The user's global instructions say "assume the question is 'is this over-engineered?'" This skill gives that question a procedure.
- **Connects to is-it-tested.** If nothing breaks when you remove a component, either the component is dead weight OR the test suite has a gap (is-it-tested's concern). The subtraction audit can't tell you which without adequate test coverage.

## Structure (draft)

1. **Scope the audit.** What's in scope — a module, a class, an abstraction layer, a feature? Don't audit the whole codebase.
2. **List the components.** Name each discrete component within scope.
3. **For each component:** state its purpose in one sentence. If you can't, flag it.
4. **Delete test.** Remove it (or stub it out). Run the tests. What breaks?
5. **Verdict.** Earns its keep / dead weight / purpose unclear.

## Tuition check (on outcome 2)

When nothing breaks, the natural conclusion is "dead weight — remove it." But some components are still teaching you something even if the tests pass without them. The distinction comes from riclib's "Tending" concept: **tuition** is code that's still teaching you (a pattern you haven't internalized, a constraint you haven't understood), **weight** is code that's finished teaching (you've extracted the lesson, the code is now just carrying it).

The delete-and-check test can't distinguish tuition from weight. Tests passing means the system's *current behavior* doesn't need the component. It doesn't mean you've understood *why* the component existed.

**Check:** Before acting on outcome 2, state in one sentence what this component taught you. If you can state it clearly, the lesson is extracted — the component is weight and can go. If you can't, the component may still be teaching. Investigate before deleting.

**Signal that tuition has become weight:** "The simple replacement has become visible" — you can name exactly what you'd do instead, without the component. If the replacement is obvious, the component has finished teaching.

This is a check on outcome 2, not a gate on every deletion. The mechanical part (delete, observe) runs first. The judgment call comes only when the result is "nothing breaks."

## Design questions

- **Granularity.** What counts as a "component"? A function? A file? A class? An abstraction layer? The skill needs guidance on scoping, or it becomes either too coarse (remove a whole module) or too fine (remove each line).
- **Test dependency.** The audit is only as good as the test suite. If the tests don't cover the component's purpose, "nothing breaks" is a false signal. Should the skill require an is-it-tested check first? That adds ceremony. Maybe just a warning.
- **Reversibility.** The "delete and see what happens" step needs to be reversible. In practice this means git stash / git checkout, but the skill should state this explicitly — don't actually commit the deletion.
- **Proportionality.** Not every codebase needs a subtraction audit. When is it worth doing? After a feature is "done" and feels heavy? When inheriting code? Before a major refactor? The trigger needs to be specific.

## What would make this skill strong

The mutation gate from what-to-test is what makes that skill verifiable. The subtraction audit has the same property — you can actually run the deletion and check the result. This makes it mechanical rather than metacognitive, which puts it in the same tier as R&I and Requisite Variety (skills the model can verifiably execute).

## What could go wrong

- The model removes something, tests pass, but the thing was needed for a production edge case the tests don't cover. The audit gives false confidence.
- The model can't easily "remove" something that's deeply entangled — removing a function that 30 callers use isn't a meaningful test. The skill needs to distinguish between "this component is independent enough to test removal" and "this component is load-bearing by construction."
- Over-application: the model starts suggesting removal of things that are genuinely needed but whose purpose isn't immediately obvious (error handling, defensive checks, compatibility shims).
