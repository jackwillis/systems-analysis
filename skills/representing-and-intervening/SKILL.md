---
name: representing-and-intervening
description: Use when debugging, diagnosing, or investigating system behavior — especially when tempted to jump to fixes, checklists, or tool-assisted reasoning before understanding the system. Triggers on "why is this happening", "what should I try", "help me debug", "let me just try...", unexplained gaps between expected and observed, multiple simultaneous changes with unclear results, reaching for tools before stating a model.
---

# Representing and Intervening

You must model a system before predicting its behavior, and predict before intervening. Source: Ian Hacking, *Representing and Intervening*.

## Five Phases

| Phase | Action | Gate |
|-------|--------|------|
| **Represent** | State the model: components, relationships, assumptions | — |
| **Predict** | What should we observe? Write it down. | No intervention without written prediction |
| **Intervene** | One change. Compare result to prediction. | One variable at a time |
| **Observe** | Record actual vs. predicted | — |
| **Update** | Prediction wrong? → See Update Decision | — |

**Hard gate:** No intervention without stating what you expect and why.

## Two Modes

- **Lightweight (default):** Natural language model and predictions. Always start here.
- **Formal (opt-in):** Tool-assisted. Only after lightweight model exists.

## Bainbridge Rule

Human states model BEFORE tools formalize it. Tools check reasoning — they don't replace it.

## Update Decision

```dot
digraph update {
  node [shape=box fontsize=11];
  edge [fontsize=10];
  "Prediction failed" -> "Was the model structurally wrong?";
  "Was the model structurally wrong?" -> "Revise model\n(return to Represent)" [label="yes — missing\ncomponent or\nrelationship"];
  "Was the model structurally wrong?" -> "Tune parameters\n(stay in Intervene)" [label="no — direction\nwas right,\nmagnitude wrong"];
}
```

Ashby's Law: if the model can't represent the system's variety, no parameter adjustment will fix it.

## Red Flags

Stop and return to Represent if you catch yourself:
- "Let me just try..." (intervening without predicting)
- Reaching for a tool before the human has spoken
- "Close enough" (skipping the observe/update cycle)
- Multiple simultaneous changes (uninterpretable results)
- "It partially worked, let's tune" (may be structural, not parametric)

## Rationalizations

| Thought | Reality |
|---------|---------|
| "Trying IS learning" | Predict first. Without prediction, results are noise. |
| "The tool will figure it out" | No model in → no insight out. |
| "Close enough" | Wrong in a way you haven't identified yet. |
| "The model is implicit" | Implicit models can't be checked or updated. Write it down. |
| "Predicting is overhead" | 30 seconds to predict vs. hours of undirected intervention. |
| "Let me give you a checklist" | Checklist = intervention without representation. Model first. |

## Transition Signals

- **Model reveals a regulation problem** (regulator can't match disturbance variety, "we keep adding rules") → switch to **requisite-variety**.
- **Represent phase needs causal structure from observational data** → switch to **design-causal-study**.
- **Production is down, what broke?** → use **systematic-debugging** (forensic, not epistemic).

R&I is epistemic: *how does this work, and what will happen if I change it?*
