# Design: `/zinsser` Skill for text-utils

**Date:** 2026-04-26
**Plugin:** text-utils
**Skill file:** `text-utils/skills/zinsser/SKILL.md`

---

## Summary

A slash command skill that applies Zinsser's prose principles to prose — either passed explicitly or defaulting to the most recent prose Claude produced. Runs two sequential passes and shows before/after for each. Complementary to `disfluent` but distinct: `disfluent` targets epistemic problems (unsupported claims, hidden uncertainty); `/zinsser` targets craft problems (clutter, passive voice, weak verbs).

---

## Trigger

Invoked explicitly as `/zinsser [text]`. If no text argument is provided, applies to the most recent prose Claude produced in the conversation.

Not auto-triggered. The description field should be narrow enough to avoid bleeding context into unrelated tasks.

---

## Architecture

Two sequential passes. Each produces a before/after block. Pass 2 takes Pass 1's output as its input.

### Pass 1 — Surface (mechanical)

Strips clutter Claude can identify by rule. Kill lists:

**Weak qualifiers**
`very`, `really`, `quite`, `rather`, `somewhat`, `fairly`, `a bit`, `sort of`, `kind of`, `in a sense`, `to some extent`, `largely` (when not meaningful)

**Redundant pairs**
`past history`, `future plans`, `completely eliminate`, `end result`, `close proximity`, `basic fundamentals`, `advance warning`, `true fact`, `free gift`

**Prepositional bloat** (verb + unnecessary preposition)
`order up → order`, `divide up → divide`, `continue on → continue`, `refer back → refer`, `meet with → meet`, `check on → check`, `free up → free`

**Adverb duplication** (adverb repeats what the verb already means)
`whisper quietly`, `smile happily`, `shout loudly`, `run quickly` (when the verb already implies the manner)

**Nominalizations** (verb buried in a noun phrase)
`make a decision → decide`, `give consideration to → consider`, `provide assistance → help`, `make an attempt → try`, `reach a conclusion → conclude`, `have a discussion → discuss`, `conduct an investigation → investigate`

**Hollow connectives** (for clutter, not epistemic reasons — distinct from `disfluent`'s rationale for the same words)
`Furthermore`, `Additionally`, `Moreover`, `It's worth noting that`, `Importantly`, `It should be noted that`

### Pass 2 — Voice (judgment)

Improves prose craft where rules alone can't decide:

- **Passive → active** — rewrite passive constructions with an active subject where one can be inferred
- **Corporate/weak verbs → specific** — `utilize → use`, `leverage → use`, `implement → do/build/run` (pick the right one), `functionality → features`, `operationalize → run/apply`
- **Vague nouns → specific** — `a number of things` → name them; `various factors` → name them; only where inferrable from context
- **False first person** — `it can be seen that → I see that`, `one might consider → consider`
- **Sentence rhythm** — flag if all sentences are the same length; note it rather than rewrite

---

## Output Format

Sequential before/after blocks, one per pass. Change summaries are terse lists, not prose.

```
### Pass 1 — Surface

Before:
[original prose]

After:
[surface-cleaned prose]

Cut: "very" ×2, "additionally", "make a decision" → "decide", "refer back" → "refer"

---

### Pass 2 — Voice

Before:
[pass 1 output]

After:
[final prose]

Rewrote: 2 passive constructions, "utilize" → "use", flagged unvaried sentence length

---

Final:
[clean prose — ready to deliver]
```

If nothing changed in a pass, say so explicitly — don't produce identical before/after blocks.

---

## Edge Cases

| Input | Behavior |
|---|---|
| Code blocks | Skip entirely, even if surrounded by edited prose |
| Bullet lists | Surface pass applies; skip sentence-rhythm check |
| Short text (<3 sentences) | Single light pass, no formal structure, cleaned text + one-line note |
| Nothing to fix | State it: "Pass 1: nothing cut. Pass 2: nothing rewritten." |
| Mixed content (prose + code + bullets) | Edit prose sections independently; mark others `[unchanged]` |

---

## Relationship to Existing Skills

| Skill | Problem space | Rationale for same-sounding moves |
|---|---|---|
| `disfluent` | Epistemic — unsupported claims, hidden uncertainty, cognitive surrender | Cuts connectives because they fake logical flow |
| `/zinsser` | Craft — clutter, passive voice, weak verbs | Cuts connectives because they add words without adding meaning |

They compose: run `/zinsser` first to tighten craft, then `/disfluent` for epistemic friction.

---

## Proportionality

Short text (<3 sentences): single light pass, no formal pass structure. The pass headers, before/after blocks, and change log are overhead that doesn't pay off on two sentences.

---

## Source

Grounded in *On Writing Well* by William Zinsser (25th Anniversary Edition). Key chapters: Simplicity (ch. 2), Clutter (ch. 3), Words (ch. 6), Bits & Pieces (ch. 10). The skill operationalizes Zinsser's mechanical rules; the judgment calls in Pass 2 follow his principles but require model discretion.

---

## What This Skill Is Not

- Not a style enforcer — it doesn't impose a voice, it removes obstacles to the writer's voice
- Not `disfluent` — different problem, different rationale, different output
- Not a grammar checker — it doesn't fix errors, it cuts clutter
