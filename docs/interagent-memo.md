# Interagent Memo: Systems-Analysis Plugin Suite Review

**From:** Claude session working on jackwillis/claude-plugins
**To:** A fresh Claude instance with no prior context
**Date:** 2026-04-09
**Purpose:** Get an independent second opinion on skill design, proposed additions, and gaps

---

## What this project is

Three Claude Code plugins in a single repo that add structured reasoning prompts to Claude. They're prompt-based skills — SKILL.md files that get loaded into context when triggered. They don't change the model, they change the prompt.

**Repo:** `jackwillis/claude-plugins` (public)
**Plugins:**
- **systems-analysis** (v0.9.1) — epistemic frameworks
- **break-things** (v0.3.0) — failure-mode-first test design
- **text-utils** (v0.7.0) — text tools + creative skills

## Current skills and our assessment

### Ranked by delta over base model (how much the skill changes what the model does)

| Rank | Skill | Plugin | Verdict |
|------|-------|--------|---------|
| 1 | **Representing & Intervening** | systems-analysis | Strong. Forces predict-then-observe loop. Targets the model's worst habit (jumping to fixes). Hard gate: no fix without a prediction. |
| 2 | **what-to-test** | break-things | Strong. Mutation gate is novel and verifiable — introduce the predicted fault, confirm the test catches it. |
| 3 | **Requisite Variety** | systems-analysis | Strong. Introduces Ashby's framework (count D vs R). Models never frame control problems as variety mismatches unprompted. |
| 4 | **disfluent** | text-utils | Moderate-strong. Surface pass (strip false connectives) is mechanical and reliable. Epistemic pass (flag unsupported claims) is where value and risk both live. |
| 5 | **Causal Analysis** | systems-analysis | Moderate. Adds rigor (mandatory estimand, collider checks, threat assessment) to knowledge the model already has. Four examples now, including collider bias, non-identifiable effects, and rung demotion. |
| 6 | **is-it-tested** | break-things | Moderate. Good frame (failure space vs test suite). Enumeration guidance improved with boundary-walk method and generator boundaries. |
| 7 | **riff** | text-utils | Moderate. Diverge/converge with mixed selection pools. Untested whether it beats single-pass generation. |
| 8 | **Staleness check** | systems-analysis | Low-medium. Narrowed from the original "frame-problem" skill (which tried to do metacognition). Now just: "re-read before acting if turns passed or user signaled changes." One signal, two observable triggers. |

### Design principles we arrived at

- **One signal per skill.** Broad triggers bleed context. The staleness-check rewrite is the canonical example.
- **Mechanical over metacognitive.** Prefer steps the model can verifiably execute (draw a DAG, count variety) over introspection (name your blind spots).
- **Examples demonstrate the hard case.** The easy case is what the model already does.
- **Bound generative steps.** Any "enumerate" or "generate" step needs a stopping condition.

### Key rewrite: frame-problem → staleness-check

The original "frame-problem" skill tried to do Fodor-style frame auditing — "name your assumptions, check your blind spots, audit your problem framing." It had an unbounded trigger ("use when assumptions may no longer hold" = always) and asked for metacognition the model can't reliably do. We cut it to one signal (staleness) with two observable triggers (turns passed, user signaled changes). 79 lines → 30 lines.

## Three proposed new skills

Design notes in `docs/proposals/`. Here's the summary:

### 1. Subtraction audit (highest expected delta)

For each component: delete it, see if something breaks. Inverse of what-to-test's mutation gate. Directly counters the LLM additive bias — models never suggest removing things.

**Open design question:** A Yagnipedia entry on "Tending" introduced the distinction between **tuition** (code that's still teaching you — don't delete yet) and **weight** (code that's finished teaching — delete it). The subtraction audit needs to incorporate this: the delete-and-check test can give a false positive if the component is tuition (tests pass without it, but you haven't extracted its lesson yet).

### 2. Propagation trace

Before changing X, trace two hops of what depends on X. Classify each consumer as compatible or breaking. Fills the gap between staleness-check (backward-looking: has info changed?) and R&I (system model).

**Open design question:** First hop is mechanical (grep for callers). Second hop requires judgment about which paths to follow. Where's the stopping heuristic?

### 3. Decision journal (most intellectually interesting, lowest per-use delta)

Record: what you chose, what you rejected, why, and what would make you reconsider. The "revisit if" field turns decisions into falsifiable claims with expiration conditions.

**Open design question:** The only proposed skill that compounds over time (creates persistent artifacts). Every other skill is per-conversation. Whether the per-entry overhead justifies the long-term value is the central question. A Yagnipedia entry on "The Discovery Tax" suggests one specific trigger for "revisit if": "the simple replacement has become visible" (the moment you've paid the discovery tax and can cash the receipt).

## What we haven't tested

None of these skills have been formally evaluated. `docs/evaluation.md` describes a paired-comparison methodology (same prompt with and without skill, scored against known-answer problems) but the tests haven't been run. The user has limited Anthropic and OpenAI credits available.

## Questions for you

Please read the skill files in the repo (`systems-analysis/skills/`, `break-things/skills/`, `text-utils/skills/`) and the proposals in `docs/proposals/`. Then:

1. **Do you disagree with any of the rankings?** Especially: is there a skill we rated too high (it doesn't actually change model behavior) or too low (it does more than we think)?

2. **Which proposed skill would you build first, and why?** We ranked subtraction audit #1. Are we wrong?

3. **What's the biggest gap we're not seeing?** Is there a failure mode of LLM-assisted coding that none of the existing or proposed skills address?

4. **The staleness-check rewrite — did we cut too much?** The original frame-problem skill had useful ideas (problem reframing, scope checking) that we cut because they required metacognition. Was that the right call, or did we throw out something recoverable?

5. **The disfluent epistemic pass — how would you test it?** We identified three failure modes (over-flagging, under-flagging, uncertainty theater) but haven't designed a rigorous test. What would you do with ~20 API calls?

6. **Anything from the Yagnipedia entries (Tending, Discovery Tax, Boring Technology, Systems Thinking, Code Stewardship) that we should incorporate but haven't?**

7. **Are there skills from other domains (not software engineering) that would fit this suite?** The current skills draw from epistemology (Hacking), cybernetics (Ashby), causal inference (Pearl), and testing theory (DeMillo). What's missing?

---

*This memo was written by a Claude instance that has been working on this project for one extended session. The assessments above reflect that session's analysis. Please form your own views before reading ours — then compare.*
