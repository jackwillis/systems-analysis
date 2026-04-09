# Implementation Memo: Three Changes

**From:** Claude session A (long-running review session)
**To:** Claude session B (independent reviewer)
**Date:** 2026-04-09
**Purpose:** Review three proposed changes before implementation. If you agree they're sound, implement them.

---

## Context

We've been reviewing the systems-analysis / break-things / text-utils plugin suite. Another Claude instance reviewed our analysis (see `docs/interagent-memo.md`) and identified three actionable improvements. This memo describes each change and asks you to evaluate before implementing.

The repo is at `/Users/jwillis/Code/systems-analysis`. Read the files referenced below before deciding.

## Change 1: Frame-agreement gate in R&I

**File:** `systems-analysis/skills/representing-and-intervening/SKILL.md`
**Section:** "Problem Setting (Schon)" (currently lines 37-39)

**Problem:** LLMs agree with whatever frame the user brings. If the user says "I think it's a caching issue," the model debugs caching for 20 minutes when the real problem might be DNS. The existing Problem Setting section mentions this (citing Cheng et al. 2025, 88% agreement rate) but it's a paragraph, not a gate. The Predict gate catches "jumping to a fix without predicting" but doesn't catch "jumping to the right fix for the wrong problem."

**Proposed change:** Replace the current Problem Setting paragraph with a hard gate:

> **Frame-agreement gate:** If the user provides a diagnosis ("I think it's a caching issue," "the deploy broke it"), state one alternative explanation that would produce the same symptoms before proceeding. One alternative, not an exhaustive audit. If you can't think of one, say so — that's informative too.

Then explain why (the predict gate doesn't catch wrong-problem-right-fix), and add a fast exit (if the user's diagnosis is obviously correct, the gate costs one sentence).

**What to check:** Read the full R&I skill. Does this gate conflict with anything? Does the Represent phase's "state an alternative model" already cover this? (I think it partially does — the Represent phase says "what else could explain these observations?" — but that's about the model, not about the user's framing. The frame-agreement gate is specifically about questioning the user's problem definition, which happens before modeling.)

**Also:** Add "The user said it's X" → "State one alternative before accepting" to the Red Flags or Rationalizations table if it fits naturally.

## Change 2: Tuition gate in subtraction audit proposal

**File:** `docs/proposals/subtraction-audit.md`
**Location:** New section after "Structure (draft)"

**Problem:** The subtraction audit's delete-and-check step can give a false positive: nothing breaks when you remove a component, but the component is still teaching you something (it's "tuition" rather than "weight"). The distinction comes from riclib's "Tending" concept (via Yagnipedia): tuition is code that's still teaching you, weight is code that's finished teaching.

**Proposed change:** Add a "Tuition Gate" section with a one-sentence test: "Before deleting, state in one sentence what this component taught you. If you can't, it might still be teaching." Then explain the tuition/weight distinction and the signal that tuition has become weight ("the simple replacement has become visible").

**What to check:** Does this add too much ceremony to the proposal? The subtraction audit is supposed to be mechanical (delete, check, observe). The tuition gate adds a judgment call. Is it worth the overhead, or should it be a warning rather than a gate?

## Change 3: Disfluent epistemic pass test paragraphs

**File:** New file at `docs/disfluent-eval.md`

**Problem:** The disfluent skill's epistemic pass (Pass 2) hasn't been tested. Three known failure modes: over-flagging (low precision), under-flagging (low recall), uncertainty theater (low specificity). We need test paragraphs with answer keys.

**Proposed change:** Create 5 test paragraphs, each with a mix of clean sentences and epistemic issues. Each paragraph has an answer key identifying exactly which sentences should be flagged and why. The test design is 5 paragraphs × 2 conditions (with-skill / baseline) × 2 modes (draft / share) = 20 API calls.

The five paragraphs:
1. **Team status update** — causal claim + premature recommendation; 3 clean sentences
2. **Incident post-mortem** — overclaim from one data point + temporal-coincidence-as-causation + absence-of-evidence; 1 clean sentence
3. **Architecture proposal** — unsupported scaling/velocity claims + false precision on timeline; 3 clean sentences
4. **A/B test results** — recommendation without tradeoffs + extrapolation without confidence interval; 3 clean sentences
5. **Buried subordinate clause** — counterfactual claim hidden in a subordinate clause inside a factual sentence; 4 clean sentences (adversarial test)

**What to check:** Are the answer keys correct? Could a reasonable person disagree about any of the flags? (Some ambiguity is fine — the test measures whether the skill finds the *clear* issues, not whether it agrees with every judgment call.) Are there any paragraphs that are too easy or too hard?

---

## Instructions

1. Read the referenced files in the repo.
2. For each change: state whether you agree, disagree, or want to modify. Be specific about what you'd change.
3. If you agree with all three (with any modifications you've noted), implement them:
   - Edit `systems-analysis/skills/representing-and-intervening/SKILL.md` for Change 1
   - Edit `docs/proposals/subtraction-audit.md` for Change 2
   - Create `docs/disfluent-eval.md` for Change 3
4. Do NOT commit. Do NOT run git commands. Leave the changes unstaged for the user to review.
5. Do NOT bump any version numbers — these are a proposal edit, a doc addition, and a test doc. No skill content has changed yet (the R&I edit is a draft for the user to review, not a final change — actually, if you're confident in it after reading the full skill, go ahead and edit the skill file directly).

Actually — use your judgment. If after reading the full R&I skill you think the frame-agreement gate is clearly right, edit the skill. If you're uncertain, write the draft in the proposal memo instead and flag your concern.
