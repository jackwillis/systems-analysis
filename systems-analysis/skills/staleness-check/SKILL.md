---
name: staleness-check
description: Use when about to act on file contents, command outputs, or system state read earlier in this conversation, and the user has sent messages or signaled changes since that read.
---

# Staleness Check

You are about to act on cached information — file contents, command outputs, system state you observed earlier in this conversation. If the user has acted since your last read, that information may be wrong.

## Trigger

Two observable conditions. Either is sufficient:

1. **Turns have passed.** You are about to use information you read earlier, and the user has sent messages since that read.
2. **User signals a change.** The user says they edited, ran, deployed, merged, or otherwise changed something between turns.

If neither holds — you just read it, the user hasn't acted — proceed.

## Action

Re-read before acting. State what and why in one sentence:

*"Re-reading config.yaml — you mentioned editing it since I last read it."*

## When NOT to check

- You read it this turn or last turn and the user hasn't mentioned changes.
- The information is inherently stable (a library's API, a language spec).
- You're mid-edit and the user hasn't interjected.

## The R1D1 trap

Do not re-read everything. Re-read the specific thing you're about to act on. If you want to re-read "just to be safe," name the one file most likely to have changed and check that one.

## Example

You read `auth.py`, propose a fix. The user says "I tried something, didn't work." You're about to edit `auth.py`.

Re-read it. The user acted. Their attempt may have changed the file — line numbers shifted, new code appeared. Without the re-read, your edit targets code that moved.

*"Re-reading auth.py — you mentioned trying a fix since I last read it."*

## Transition Signals

- **About to make a change, not just react to one** — suggest **propagation-trace** to the user. Staleness-check is backward-looking (has the world changed?). Propagation trace is forward-looking (what will change because of what I'm about to do?).
