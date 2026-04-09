---
name: propagation-trace
description: Use when about to change a shared interface — function signature, return type, default value, data format, API contract, config value — and haven't traced what depends on it. Triggers on editing function signatures, changing defaults, modifying API contracts, altering data formats.
---

# Propagation Trace

Before changing a shared interface, trace where the change propagates. Two hops, no more. Source: bounded impact analysis.

## Proportionality

If the change is internal — refactoring a loop body, renaming a local variable, extracting a private helper — it doesn't cross a module boundary and nothing depends on it. State why in one sentence and proceed. The same applies to changes behind a stable interface that absorbs the difference: same signature, same behavior, nothing to trace.

## What Counts as Shared Interface

The trigger fires for changes that cross a boundary other code depends on: function signatures, return types, default values, data formats, API contracts, config values, environment variables, database schemas.

It does NOT fire for: internal variable renames, loop refactors, comment changes, formatting, or implementation changes behind a stable interface.

The boundary test: does the change affect something in a different file or module that other code reads, calls, or assumes?

## The Trace

### Step 1: Name the Change

State what you're modifying and how. Be specific: "changing `process_order`'s return type from `Order` to `Optional[Order]`", not "updating process_order."

### Step 2: Hop One (Mechanical)

Find every direct consumer. **Use grep or find-references. Do not trace callers from memory.**

For each consumer, classify:

| Classification | Meaning | Action |
|---|---|---|
| **Structurally compatible** | Types match, no compile/parse error | Check behavioral compatibility (next row) |
| **Behaviorally compatible** | Consumer handles both old and new semantics correctly | Note and move on |
| **Breaking** | Consumer assumes the old behavior | Flag for change |

The dangerous category is **structurally compatible but behaviorally breaking** — it compiles, passes type checks, and produces wrong results. A function that changes from "returns empty list on failure" to "returns None on failure" with the same `Optional[List]` type: callers that iterate the result without a None check will break silently.

### Step 3: Hop Two (Judgment-Guided)

You cannot trace two hops from every hop-one consumer. Prioritize:

- **Follow** consumers that (a) use the part of the interface that's changing, and (b) pass the result downstream rather than consuming it terminally.
- **Skip** consumers that only use unchanged parts of the interface, or that are leaf nodes with no downstream dependents.

For each hop-two consumer, classify using the same table. If a hop-two consumer is breaking and has its own high-value dependents, **do not extend to hop three.** Start a new trace from that consumer instead.

### Step 4: Report

State the result: "N consumers at hop one (M compatible, K breaking), P consumers at hop two (Q compatible, R breaking)." List the breaking consumers by name. Each breaking consumer is a change target or a what-to-test target.

## Red Flags

- **"I know what calls this."** You don't. Grep. The caller you forgot is the one that breaks in production.
- **"It's the same type, so it's fine."** Structural compatibility is not behavioral compatibility. Check what the consumer *assumes*, not just what it *accepts*.
- **"I'll just trace one more hop."** Two hops is the bound. If hop two reveals something alarming, start a new trace — don't extend this one. Unbounded traces become speculation.
- **"Nothing calls this."** Verify. Zero callers means the change is safe — or it means your search missed something. Check for dynamic dispatch, reflection, config-driven lookups, and cross-repo consumers.
- **"The tests will catch it."** Tests catch what they test. A structurally compatible, behaviorally breaking change is exactly what passes tests that check types but not semantics.

## Rationalizations

| Thought | Reality |
|---------|---------|
| "I checked the immediate callers" | One hop. Did you check their callers? |
| "The type signature didn't change" | Behavioral breaks hide behind stable signatures. That's the whole point. |
| "It's a small change" | Small changes to shared interfaces propagate to every consumer. Size of the diff != size of the blast radius. |
| "I'll fix consumers as they break" | Reactive: each consumer breaks in production once. Proactive: trace now, fix before shipping. |
| "There are too many callers to trace" | Prioritize. Follow consumers that use the changing part and pass the result downstream. Skip leaf nodes and unchanged-part users. |

## Honest Limitation

The trace covers what you can see — the current repo, the current codebase. It cannot trace consumers in other repositories, downstream services, or external clients that depend on your API. For changes to public APIs, the trace identifies internal impact; external impact requires versioning, deprecation, and changelogs — not hop-tracing.

## Examples

- [Default value propagation](examples/default-value-propagation.md) — behavioral break behind a stable type signature, hop-two consumer assumes the old default
- [Internal refactor fast exit](examples/internal-refactor-fast-exit.md) — change doesn't cross a module boundary, trace correctly stops

## Arriving From Another Skill

- **From representing-and-intervening:** R&I's Represent phase gave you a model of the system. The propagation trace simulates a change through that model — "if I change X, what else moves?" The model's components and relationships are your hop-one search targets.
- **From staleness-check:** A re-read revealed that something changed. If *you* are about to make a change (not just reacting to one), the propagation trace is the forward-looking complement: staleness-check asks "has the world changed?", propagation trace asks "what will change because of what I'm about to do?"

## Transition Signals

- **Breaking consumers identified, need to write tests for them** — suggest **what-to-test** to the user. Each breaking consumer is the answer to question 1 (what you're guarding against). The behavioral break is the predicted failure mode (question 3).
- **Trace reveals the system model is wrong or incomplete** — suggest **representing-and-intervening** to the user. You need a better model before you can trace through it.
- **Too many consumers to trace manually** — the interface has high fan-out. Consider whether the interface itself needs redesign (narrower contracts, fewer dependents) rather than tracing through all of them.
- **Change affects a regulatory boundary** (config that controls system behavior, a rate limit, a feature flag) — suggest **requisite-variety** to the user. The propagation may affect the system's ability to regulate itself.

propagation-trace is predictive: *what moves when I change this?*
