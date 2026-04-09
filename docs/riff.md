# Riff

`/riff` — invoke explicitly · [Full skill](../text-utils/skills/riff/SKILL.md)

## When to use

You're naming something, exploring phrasings, or generating title options and you don't want to settle on the first decent option.

Not auto-triggered. Invoke with `/riff "seed phrase"` and optionally a size.

## What it does

Runs interleaved diverge/converge rounds: generate options, generate more, select the best, generate new options inspired by the picks, select again from all rounds. The key discipline is delaying selection — never pick after the first round — and mixing across all rounds to prevent recency bias.

Three sizes:
- **small** — 3-5 finalists, 2 diverge/converge cycles
- **medium** — 6-10 finalists, 4 cycles
- **large** — 11-20 finalists, 5+ cycles

## What to expect

Claude shows the full trace: every generation round, every selection, every recombination step. The final picks draw from all rounds, not just the last one. The non-obvious options tend to come from post-selection generation — after the first good ideas are identified and recombined.
