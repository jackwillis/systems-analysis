# Example: Discovery Tax Extraction

A data pipeline has a `TransformRouter` class that dispatches incoming records to format-specific transform functions based on a type field. The router was built when the team supported 12 input formats. After a migration, only 2 formats remain. The router now dispatches between two functions.

## Scope

One class: `TransformRouter`. It wraps a `match` statement, a registry dict, and a fallback error path.

## Components

| Component | Purpose |
|-----------|---------|
| `TransformRouter` class | Dispatches records to format-specific transforms |
| Registry dict (`_handlers`) | Maps format strings to transform functions |
| Fallback error path | Raises on unknown format type |

## Delete Test

**Remove `TransformRouter` and call the two transform functions directly.**

Tests pass. The router added no behavior beyond dispatch — callers can check the type field themselves and call the right function. Nothing broke.

## Tuition Check

**What did `TransformRouter` teach?** It was built to handle 12 formats without a chain of if/elif branches. It taught the team that dispatch-by-type is cleaner than conditionals when the format count is high.

**Can you name the replacement?** Two callers, two formats. Each caller checks the type field and calls the right function directly. But — the team is evaluating adding 3 new input formats next quarter. If that happens, the naive replacement (if/elif in each caller) is worse than the router.

**Verdict: Tuition.** The lesson (dispatch scales better than conditionals) hasn't been fully extracted because the input about future formats hasn't resolved. The simple replacement is visible *for the current state* but may not hold. Investigate the roadmap before deleting.

## What Changed

Without the tuition check, the mechanical result ("nothing breaks, remove it") would have been the recommendation. The check surfaced a context-dependent reason to wait — not because the code is currently needed, but because the replacement's simplicity depends on an assumption (format count stays at 2) that may not hold.

If the team confirms no new formats are coming, the verdict flips to weight. The tuition check doesn't block deletion — it blocks *premature* deletion.
