# Staleness Check

`/staleness-check` — replaces the former frame-problem skill · [Full skill](../systems-analysis/skills/staleness-check/SKILL.md)

## When to use

Claude is about to act on information it read earlier in the conversation, and you've done something since then — edited a file, run a command, deployed, merged.

Auto-triggers on: acting on cached information when the user has sent messages or signaled changes since the last read.

## What it does

Re-reads the specific thing Claude is about to act on. States what and why in one sentence:

*"Re-reading config.yaml — you mentioned editing it since I last read it."*

That's it. One check, one re-read. Not a philosophical audit of all assumptions.

## What to expect

The skill asks Claude to pause before an edit to re-read a file you've touched since it was last read. It shouldn't re-read everything "just to be safe" — it targets the specific file most likely to have changed.

If you haven't mentioned any changes and Claude just read the file, it proceeds without checking.
