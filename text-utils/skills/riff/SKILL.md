---
name: riff
description: Use when the user needs to generate name, title, or phrase variations — especially when stuck on naming, brainstorming alternatives, or wanting to explore options before committing. Triggers on "name ideas", "what should I call", "help me name", "brainstorm names", "alternatives for", or explicit /riff invocation.
---

# Riff

Generate variations on a name, title, phrase, or sentence by running multiple rounds of divergent generation and convergent selection. Prevents settling on the first decent option.

## How to use

The user invokes `/riff` with a seed and optionally a size:

- `/riff "name for a CLI tool that fetches markdown"` — asks for size, then runs
- `/riff "name for a CLI tool that fetches markdown" small` — runs immediately

**Seed** can be either:
- A thing to riff on: `"fetch-markdown"`
- A description of what's needed: `"name for a CLI tool that fetches web pages as markdown"`

**Size** controls how many finalists and how many rounds:
- **small** — 3-5 finalists, 2 diverge/converge cycles
- **medium** — 6-10 finalists, 4 diverge/converge cycles
- **large** — 11-20 finalists, 5+ diverge/converge cycles

If the user doesn't specify a size, ask.

## Running the game

Run the game for the chosen size below. Display every round as you go — the user wants to see the full trace, not just the final list. Annotate each round with its generation letter and step type.

### Output format

```
## [a] — generate 7
1. option-one
2. option-two
...

## [b] — generate 5
1. ...

## [a,b] — select best 4
1. ...

## [c] — generate 3 inspired by picks
1. ...

## Final — 5 finalists from [a,b,c]
1. ...
```

### Small game (3-5 finalists)

1. Generate 7 options `[a]`
2. Generate 5 more `[b]`
3. Select best 4 from `[a,b]`
4. Generate 3 inspired by the picks `[c]`
5. Select final 3-5 from all `[a,b,c]`

### Medium game (6-10 finalists)

1. Generate 11 options `[a]`
2. Generate 5 more `[b]`
3. Generate 6 more `[c]`
4. Select best 4 from `[a,b,c]`
5. Generate 2 more `[d]`
6. Generate 10 more `[e]`
7. Select best from `[d,e]`, then generate 1 inspired by `[e]`
8. Generate 7 more `[f]`
9. Generate 4 more `[g]`
10. Select top 5 from all `[a,b,c,d,e,f,g]`
11. Generate 1 more `[h]`
12. Select final 6-10 from all rounds

### Large game (11-20 finalists)

1. Generate 15 options `[a]`
2. Generate 10 more `[b]`
3. Generate 12 more `[c]`
4. Select best 8 from `[a,b,c]`
5. Generate 6 more `[d]`
6. Generate 10 more `[e]`
7. Select best 5 from `[d,e]`, then generate 2 inspired by picks `[f]`
8. Generate 12 more `[g]`
9. Generate 8 more `[h]`
10. Select top 10 from all `[a,b,c,d,e,f,g,h]`
11. Generate 5 more `[i]`
12. Generate 3 inspired by top 10 `[j]`
13. Select final 11-20 from all rounds

## Principles

Follow these during every game — they are what make the technique work:

- **Multiple generation rounds before any selection.** Do not select after the first round. Generate at least twice before converging.
- **Selection pools mix across generations.** When selecting, draw from all prior rounds, not just the most recent. This prevents recency bias.
- **At least one recombination step.** Generate options "inspired by" previous picks — this creates crossover between good ideas.
- **Vary batch sizes.** Don't generate the same number every round. Varying sizes (7, 5, 3, 11, 6...) breaks formulaic listing patterns.
- **Never stop after the first convergence.** Always generate more after a selection step. The non-obvious ideas come from post-selection generation.
- **Final selection draws from all rounds.** Not just recent ones.

## Red flags

- All options in a round sound the same — you're in a rut. Add a constraint: "now try options that are only one word" or "now try options from a completely different angle."
- Selection keeps picking from the same round — the other rounds may be too similar. Generate with an explicit stylistic shift.
- The seed is too vague to generate meaningful variations — ask the user to clarify before starting.
