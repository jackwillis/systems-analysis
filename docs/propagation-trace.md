# Trace Change Propagation

`/propagation-trace` — bounded impact analysis for shared interface changes · [Full skill](../systems-analysis/skills/propagation-trace/SKILL.md)

## When to use

You're about to change a function signature, a default value, a data format, an API contract, or a config value — anything that other code depends on. You want to know what breaks before you ship, not after.

Auto-triggers on: editing function signatures, changing default values, modifying API contracts, altering data formats, changing config values or environment variables.

## What it does

Traces the change two hops through the codebase:

1. **Name the change** — state exactly what's being modified and how
2. **Hop one (mechanical)** — grep or find-references for every direct consumer, classify each as compatible or breaking
3. **Hop two (judgment-guided)** — follow hop-one consumers that use the changing part and pass the result downstream; classify their consumers
4. **Report** — list breaking consumers by name

The key classification: **structurally compatible but behaviorally breaking** — it compiles, the types match, but the consumer assumes the old behavior and produces wrong results silently.

## What to expect

You'll see Claude use tooling (grep, find-references) for hop one rather than reasoning from memory. Hop two requires judgment about which paths to follow — it prioritizes consumers that use the changing part of the interface and pass the result downstream over leaf nodes.

For internal changes (refactoring a loop, extracting a private helper), the skill fast-exits: the public interface absorbs the difference, nothing to trace.

Hard limit: two hops. If hop two reveals something alarming, start a new trace from that point rather than extending to hop three.

## Example

A function's `include_inactive` default changes from `True` to `False`. The type signature is identical.

- **Hop one:** 8 callers. 5 pass the parameter explicitly (compatible). 3 rely on the default — one is compatible (wanted active-only anyway), two are breaking.
- **Hop two:** One breaking caller syncs data downstream. Its consumer — a reconciliation job — interprets the missing inactive records as deletions and triggers bulk removal.
- **Report:** 2 breaking at hop one, 1 breaking at hop two. The hop-two break is the most dangerous: invisible at hop one, structurally compatible, silently destructive.

Without the trace, the default-value change looks safe — same types, no compile errors. The damage surfaces two hops out.
