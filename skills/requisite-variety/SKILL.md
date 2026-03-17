---
name: requisite-variety
description: Use when designing, evaluating, or diagnosing control and regulation systems — especially when asking "why can't we control this?", "why does this regulator fail?", "is our defense sufficient?", or when facing a system too large to regulate by brute force. Triggers on regulation failure, alert fatigue, oscillating controllers, defense ceilings, scaling limits, "we keep adding rules/alerts but it's not working", whack-a-mole against adaptive adversaries, reactive controls hitting a ceiling.
---

# Requisite Variety

Three principles for regulation and control. Sources: Ashby (1956), Conant & Ashby (1970).

## Three Principles

| Principle | Statement | Diagnostic question |
|-----------|-----------|-------------------|
| **Requisite Variety** | Only variety absorbs variety. R needs at least as much response variety as D's disturbance variety. | Does R's variety match D's? |
| **Good Regulator** | Every good regulator must model the system it regulates. Variety without structure is brute force. | Does R contain a model — or is it pattern-matching? |
| **Constraints** | When the system is too large for brute force, discovering structure in disturbances is R's only path. | Can you find constraints that reduce D below R? |

Apply in order: first check variety (capacity), then check model (structure), then look for constraints (tractability).

## Error-Controlled Regulation

Feedback regulators are inherently imperfect: success blocks the information channel. Error-controlled R (thermostats, auto-scalers, reactive defenses) reduces variety but never eliminates it. For tighter regulation, shift to anticipatory: get information about D *before* it reaches E.

## Name the Parts

- **D** — disturbance source (what threatens the system)
- **R** — regulator (what you're building or evaluating)
- **T** — environment (the system D acts through)
- **E** — essential variables (what must stay within limits)
- **η** — acceptable range for E

R blocks variety flowing from D to E. Test: can you tell from E what D did? If yes, regulation is failing.

## Red Flags

- Adding responses one-by-one against an adaptive adversary (R can never catch D)
- Regulator has no model of "healthy" (no model → no regulation)
- Tuning an oscillating controller without measuring the oscillation
- "More alerts/rules/checks" without asking: variety bottleneck or structure bottleneck?

## Rationalizations

| Thought | Reality |
|---------|---------|
| "More rules" | Adaptive D outruns enumerated R. Find constraints. |
| "Covers everything" | Coverage ≠ model. What does R *model*? |
| "Tune until stable" | Error-controlled R is inherently imperfect. May need anticipatory. |
| "Too complex to model" | Then too complex to regulate. Find constraints first. |
| "More data helps" | Only if R can act on it. Variety bounds what R can do. |

## Transition Signals

- **Can't name D/R/T/E/η** — you don't have a model yet → start with **representing-and-intervening**.
- **Need a causal link from observational data** before designing the regulator → use **design-causal-study**.
- **Variety is sufficient but system is still failing** — the problem may be epistemic (wrong model), not regulatory → return to **representing-and-intervening**.
