---
name: zinsser
description: Use when explicitly asked to tighten prose, cut clutter, or apply Zinsser's principles — or when the user invokes /zinsser, "Zinsser this", "tighten this", or "cut the clutter". Not for general editing requests.
---

# Zinsser

Apply William Zinsser's prose principles to tighten any piece of writing. Two passes, both shown before/after. Distinct from `disfluent` — this is a craft tool, not an epistemic one.

## Proportionality

**Short text (<3 sentences):** Skip the pass structure. Run a single light edit and deliver the cleaned text with a one-line note.

**Nothing to fix:** Say so — "Pass 1: nothing cut. Pass 2: nothing rewritten." Don't produce identical before/after blocks.

## Pass 1 — Surface (mechanical)

Strip clutter by rule. These are mechanical: apply them without judgment.

### Weak qualifiers — cut without replacement

Kill list: `very`, `really`, `quite`, `rather`, `somewhat`, `fairly`, `a bit`, `sort of`, `kind of`, `in a sense`, `to some extent`, `largely` (cut only when no exception is stated in the same sentence; "largely successful" with no caveat → "successful", but "largely successful, with one known failure" → leave it)

> "The results were quite significant" → "The results were significant"

### Redundant pairs — keep one word, drop the other

`past history` → `history`, `future plans` → `plans`, `completely eliminate` → `eliminate`, `end result` → `result`, `close proximity` → `proximity`, `basic fundamentals` → `fundamentals`, `advance warning` → `warning`, `true fact` → `fact`, `free gift` → `gift`

### Prepositional bloat — drop the preposition

`order up` → `order`, `divide up` → `divide`, `continue on` → `continue`, `refer back` → `refer`, `meet with` → `meet`, `check on` → `check`, `free up` → `free`

### Adverb duplication — drop the adverb

When the adverb repeats what the verb already means: `whisper quietly` → `whisper`, `smile happily` → `smile`, `shout loudly` → `shout`, `run quickly` → `run` (when speed is already implied by the verb)

### Nominalizations — restore the verb

- `make a decision` → `decide`
- `give consideration to` → `consider`
- `provide assistance` → `help`
- `make an attempt` → `try`
- `reach a conclusion` → `conclude`
- `have a discussion` → `discuss`
- `conduct an investigation` → `investigate`
- `make a recommendation` → `recommend`
- `in order to` → `to`

### Hollow connectives — cut them

`Furthermore`, `Additionally`, `Moreover`, `It's worth noting that`, `Importantly`, `It should be noted that`

## Pass 2 — Voice (judgment)

Apply where a clear improvement exists. Don't rewrite if the rewrite isn't clearly better.

### Passive → active

Rewrite passive constructions when you can identify the active subject:
- "The report was written by the team" → "The team wrote the report"
- "Mistakes were made" — no active subject inferrable; leave it or flag it
- "It was decided that" → who decided? Name them if inferrable; flag if not

### Corporate/weak verbs → specific

- `utilize` → `use`
- `leverage` → `use` (or the specific action: `leverage the cache` → `use the cache`)
- `implement` — replace only if the specific action is unambiguous from context (`implement` + a test suite → `write`); otherwise flag it for the writer rather than guess
- `operationalize` → `run`, `apply`, `put into practice`
- `functionality` → `features` (or the specific feature name)
- `surface` (verb meaning "reveal") → `show`, `expose`, `reveal`

### Vague nouns → specific

Only where the specific referent is inferrable from context:
- `a number of things` → name them, or use a count ("three issues")
- `various factors` → name them
- `some issues` → name them or count them

If you can't infer the referent, leave it alone. Don't invent specifics. If inference requires more than one step from context, leave it alone.

### False impersonal → direct

- `it can be seen that` → state the observation directly
- `one might consider` → `consider`
- `it is worth noting that` → cut it, lead with the note
- `there is a sense in which` → cut it, state the thing

### Sentence rhythm

If every sentence in a paragraph is the same length, flag it:
> *Note: all sentences here are roughly the same length — consider varying.*

Flag, don't rewrite. The writer's ear handles rhythm.

## Output Format

```
### Pass 1 — Surface

Before:
[original prose]

After:
[surface-cleaned prose]

Cut: [terse list — what fired and what changed]

---

### Pass 2 — Voice

Before:
[pass 1 output]

After:
[final prose]

Rewrote: [terse list — what fired and what changed]

---

Final:
[clean prose]
```

If nothing changed in a pass, say so — don't show identical before/after blocks.

## Edge Cases

| Input | Behavior |
|---|---|
| Code blocks | Skip entirely — don't touch code, even if prose surrounds it |
| Bullet lists | Surface pass applies; skip sentence-rhythm check |
| Short text (<3 sentences) | Single light pass, no formal structure, cleaned text + one-line note |
| Nothing to fix | State it: "Pass 1: nothing cut. Pass 2: nothing rewritten." |
| Mixed content (prose + code + bullets) | Edit prose sections independently; mark others `[unchanged]` |

## What This Skill Is Not

**Not `disfluent`.** `disfluent` introduces epistemic friction — flags unsupported claims, surfaces uncertainty, marks provenance. `/zinsser` removes mechanical clutter and strengthens voice. They compose: run `/zinsser` first to tighten craft, then `/disfluent` for epistemic friction.

Both skills cut hollow connectives (`Furthermore`, `Additionally`, etc.) but for different reasons: `/zinsser` cuts them as clutter (words without meaning); `disfluent` cuts them as epistemic fakes (words that imply logical flow where there is none). The cuts are compatible.

**Not a style enforcer.** This skill removes obstacles to the writer's voice; it doesn't impose one.

**Not a grammar checker.** It doesn't fix errors. It cuts clutter.

## Source

Grounded in *On Writing Well* by William Zinsser (25th Anniversary Edition).
