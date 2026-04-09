# Proposal: Propagation Trace

## The problem

LLMs see files in isolation. They edit a function, confirm it works locally, and miss that three callers now pass the wrong type. They change a default and don't trace the implicit assumptions that depended on the old value.

Staleness-check asks "has the world changed since I last looked?" R&I asks "what's my model of the system?" Neither asks: "if I change X, what else moves?"

## Core mechanism

Before making a change, trace where it propagates:

1. **Name the change.** What are you modifying? A function signature, a default value, a data format, an API contract.
2. **Trace one hop.** Direct consumers — what calls this function, reads this value, depends on this format?
3. **Trace two hops.** What depends on those consumers?
4. **For each:** Is the change compatible or breaking? Compatible = the consumer handles both old and new behavior. Breaking = the consumer assumes the old behavior.
5. **Stop at two hops** unless a breaking change at hop 2 has its own high-value consumers.

## Why two hops

One hop catches direct breakage. Two hops catches the indirect breakage that causes most production incidents — the caller's caller that assumed a return type, the config consumer's consumer that assumed a default.

Three or more hops is usually speculation. The further you trace, the less confident you can be about whether the change actually propagates. Two hops is the sweet spot between useful and bounded.

## Relationship to existing skills

- **Complements staleness-check.** Staleness-check is backward-looking: "has the information I'm acting on changed?" Propagation trace is forward-looking: "what will change because of what I'm about to do?"
- **Uses R&I's model.** If you've already done R&I's Represent phase, you have a model of the system. The propagation trace is "simulate the change through your model."
- **Feeds into what-to-test.** Each breaking consumer from the trace is a candidate for what-to-test's question 1: "what are you guarding against?"

## Design questions

- **Mechanical vs. judgment.** Tracing one hop is mechanical — grep for callers, read them, check compatibility. Tracing two hops requires judgment about which one-hop consumers are worth following. The skill needs a heuristic for when to follow a path vs. stop.
- **Scope.** This is most useful for changes to shared interfaces — function signatures, API contracts, data formats, config values. For changes to internal implementation (refactoring a loop), propagation is zero by definition. The skill should recognize this and fast-exit.
- **Tool support.** In practice, "trace one hop" means grep/find-references. The skill should lean on tooling (LSP, grep, dependency graphs) rather than asking the model to reason about call graphs from memory. This makes it more mechanical.
- **What counts as "compatible"?** A change to a function's return type is obviously breaking. A change to a function's behavior with the same type signature is subtler — the caller may depend on the old behavior without the type system knowing. The skill needs to distinguish structural compatibility (types match) from behavioral compatibility (semantics preserved).

## What would make this skill strong

The bounded hop count. Without it, "trace the propagation" becomes unbounded exploration (R1D1). With it, the skill produces a concrete, reviewable list: "these N consumers are affected, M are compatible, K need changes."

The connection to what-to-test. Every breaking consumer becomes a test target. The trace doesn't just identify risk — it produces actionable next steps.

## What could go wrong

- The model traces propagation through the code it can see but misses consumers in other repos, services, or downstream systems. The trace gives false completeness.
- For highly connected code (a utility function called from 50 places), the one-hop list is too long to be useful. The skill needs a way to prioritize: which consumers are highest-risk?
- The model may not distinguish between "this consumer calls the function" and "this consumer depends on the function's current behavior." The first is mechanical (grep). The second requires understanding what the consumer assumes.
