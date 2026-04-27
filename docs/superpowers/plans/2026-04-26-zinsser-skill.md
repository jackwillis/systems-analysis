# Zinsser Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `/zinsser` skill to text-utils that applies Zinsser's prose principles in two sequential passes (surface clutter removal, then voice improvement) with before/after output for each pass.

**Architecture:** A single `SKILL.md` file at `text-utils/skills/zinsser/SKILL.md`. No code — the skill is a set of instructions and kill lists that Claude executes at invocation time. One example file demonstrates the expected two-pass output. Plugin version bumps from 0.8.0 to 0.9.0.

**Tech Stack:** Markdown, YAML frontmatter, Claude Code skill conventions.

---

## File Map

| Action | Path | Responsibility |
|---|---|---|
| Create | `text-utils/skills/zinsser/SKILL.md` | The skill itself — all rules, kill lists, output format, edge cases |
| Create | `text-utils/skills/zinsser/examples/technical-postmortem.md` | Demonstrates two-pass output on a realistic prose sample |
| Modify | `text-utils/.claude-plugin/plugin.json` | Bump version to 0.9.0, add zinsser to description and keywords |

---

## Task 1: Write the example file first

Define what good output looks like before writing the skill. This is the acceptance criterion.

**Files:**
- Create: `text-utils/skills/zinsser/examples/technical-postmortem.md`

- [ ] **Step 1: Create the examples directory and write the example file**

Create `text-utils/skills/zinsser/examples/technical-postmortem.md` with this exact content:

```markdown
# Example: Technical Post-mortem Paragraph

## Input

The team made a decision to implement a new caching layer in order to provide assistance with the performance issues that had been quite significant in the previous quarter. Furthermore, the migration was completed successfully and the results were very positive. It should be noted that there were a number of things that could have been handled better, but overall the project can be considered a qualified success.

---

## Expected Output

### Pass 1 — Surface

Before:
The team made a decision to implement a new caching layer in order to provide assistance with the performance issues that had been quite significant in the previous quarter. Furthermore, the migration was completed successfully and the results were very positive. It should be noted that there were a number of things that could have been handled better, but overall the project can be considered a qualified success.

After:
The team decided to add a caching layer to help with the performance issues that had been significant in the previous quarter. The migration completed successfully and the results were positive. There were a number of things that could have been handled better, but overall the project can be considered a qualified success.

Cut: "made a decision to" → "decided", "implement" → "add", "provide assistance with" → "help with", "quite" ×1, "Furthermore" (hollow connective), "very" ×1, "It should be noted that" (hollow connective)

---

### Pass 2 — Voice

Before:
The team decided to add a caching layer to help with the performance issues that had been significant in the previous quarter. The migration completed successfully and the results were positive. There were a number of things that could have been handled better, but overall the project can be considered a qualified success.

After:
The team decided to add a caching layer to help with the performance issues that had been significant in the previous quarter. The migration completed successfully and the results were positive. Several things could have been handled better, but the project succeeded.

Rewrote: "There were a number of things that could have been handled better" → "Several things could have been handled better" (vague noun → specific count, passive → active), "can be considered a qualified success" → "succeeded" (passive hedged construction → direct active verb)

---

Final:
The team decided to add a caching layer to help with the performance issues that had been significant in the previous quarter. The migration completed successfully and the results were positive. Several things could have been handled better, but the project succeeded.
```

- [ ] **Step 2: Confirm the example directory exists**

```bash
ls text-utils/skills/zinsser/examples/
```

Expected: `technical-postmortem.md`

---

## Task 2: Write the SKILL.md

**Files:**
- Create: `text-utils/skills/zinsser/SKILL.md`

- [ ] **Step 1: Create the skill file**

Create `text-utils/skills/zinsser/SKILL.md` with this exact content:

```markdown
---
name: zinsser
description: Use when editing prose for clarity and craft — especially to tighten clutter, cut weak qualifiers, strengthen verbs, and remove passive constructions. Triggers on /zinsser, "Zinsser this", "tighten this", "cut the clutter", "make this leaner".
---

# Zinsser

Apply William Zinsser's prose principles to tighten any piece of writing. Two passes, both shown before/after. Distinct from `disfluent` — this is a craft tool, not an epistemic one.

## Proportionality

**Short text (<3 sentences):** Skip the pass structure. Run a single light edit and deliver the cleaned text with a one-line note.

**Nothing to fix:** Say so — "Pass 1: nothing cut. Pass 2: nothing rewritten." Don't produce identical before/after blocks.

## Pass 1 — Surface (mechanical)

Strip clutter by rule. These are mechanical: apply them without judgment.

### Weak qualifiers — cut without replacement

Kill list: `very`, `really`, `quite`, `rather`, `somewhat`, `fairly`, `a bit`, `sort of`, `kind of`, `in a sense`, `to some extent`, `largely` (when used as a hedge with no content)

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

Note: `disfluent` also cuts these, but for epistemic reasons (they fake logical flow). Both cuts are correct; the rationale differs.

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
- `implement` → `build`, `run`, `write`, or `deploy` — pick from context
- `operationalize` → `run`, `apply`, `put into practice`
- `functionality` → `features` (or the specific feature name)
- `surface` (verb meaning "reveal") → `show`, `expose`, `reveal`

### Vague nouns → specific

Only where the specific referent is inferrable from context:
- `a number of things` → name them, or use a count ("three issues")
- `various factors` → name them
- `some issues` → name them or count them

If you can't infer the referent, leave it alone. Don't invent specifics.

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

**Not a style enforcer.** This skill removes obstacles to the writer's voice; it doesn't impose one.

**Not a grammar checker.** It doesn't fix errors. It cuts clutter.

## Source

Grounded in *On Writing Well* by William Zinsser (25th Anniversary Edition). Key chapters: Simplicity (ch. 2), Clutter (ch. 3), Words (ch. 6), Bits & Pieces (ch. 10). The kill lists operationalize Zinsser's mechanical rules; Pass 2 judgment calls follow his principles but require model discretion.
```

- [ ] **Step 2: Verify file exists and frontmatter is valid**

```bash
head -6 text-utils/skills/zinsser/SKILL.md
```

Expected:
```
---
name: zinsser
description: Use when editing prose for clarity and craft — especially to tighten clutter, cut weak qualifiers, strengthen verbs, and remove passive constructions. Triggers on /zinsser, "Zinsser this", "tighten this", "cut the clutter", "make this leaner".
---
```

---

## Task 3: Smoke-test the skill

Invoke `/zinsser` on the example input and verify the output matches the structure in the example file.

**Files:** None modified in this task.

- [ ] **Step 1: Invoke the skill on the example input**

Run `/zinsser` with this input:

> The team made a decision to implement a new caching layer in order to provide assistance with the performance issues that had been quite significant in the previous quarter. Furthermore, the migration was completed successfully and the results were very positive. It should be noted that there were a number of things that could have been handled better, but overall the project can be considered a qualified success.

- [ ] **Step 2: Verify output structure**

Check that the output contains:
1. `### Pass 1 — Surface` with Before/After blocks and a `Cut:` line
2. `### Pass 2 — Voice` with Before/After blocks and a `Rewrote:` line
3. `Final:` block with clean prose

Check that these specific items were caught:
- Pass 1: `made a decision to` → `decided`, `provide assistance with` → `help with`, `quite`, `very`, `Furthermore`, `It should be noted that`
- Pass 2: passive construction in the final sentence, vague `a number of things`

If the output matches the structure and catches these items, the skill is working. If not, revise `SKILL.md` to make the rules clearer or the kill lists more explicit.

---

## Task 4: Update plugin.json

**Files:**
- Modify: `text-utils/.claude-plugin/plugin.json`

- [ ] **Step 1: Update plugin.json**

Edit `text-utils/.claude-plugin/plugin.json` to:

```json
{
  "name": "text-utils",
  "version": "0.9.0",
  "description": "Efficient text extraction and format conversion: fetch markdown from URLs, render markdown to PDF or EPUB, extract text from PDFs, generate name/phrase variations, introduce strategic disfluency, tighten prose with Zinsser's principles.",
  "author": {
    "name": "Jack Willis",
    "email": "jack@attac.us"
  },
  "license": "MIT",
  "keywords": [
    "markdown",
    "pdf",
    "epub",
    "ebook",
    "text",
    "conversion",
    "fetch",
    "ocr",
    "disfluency",
    "zinsser",
    "prose",
    "writing",
    "editing"
  ]
}
```

- [ ] **Step 2: Verify the version bumped**

```bash
grep '"version"' text-utils/.claude-plugin/plugin.json
```

Expected: `"version": "0.9.0"`

---

## Task 5: Commit

**Files:** All new/modified files.

- [ ] **Step 1: Stage the new files**

```bash
git add text-utils/skills/zinsser/SKILL.md \
        text-utils/skills/zinsser/examples/technical-postmortem.md \
        text-utils/.claude-plugin/plugin.json
```

- [ ] **Step 2: Verify staged files**

```bash
git status
```

Expected: three files staged, no unexpected changes.

- [ ] **Step 3: Commit**

```bash
git commit -m "Add /zinsser skill to text-utils (v0.9.0)

Two-pass prose editor grounded in Zinsser's On Writing Well.
Pass 1 strips mechanical clutter (qualifiers, nominalizations,
prepositional bloat, hollow connectives). Pass 2 strengthens
voice (passive→active, weak verbs, vague nouns). Complementary
to disfluent — craft tool, not epistemic tool."
```

Expected: commit succeeds, one commit in git log with this message.
