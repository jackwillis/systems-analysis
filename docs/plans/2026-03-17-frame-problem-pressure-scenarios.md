# Frame Problem Pressure Scenarios

## Scenario 1: Stale State (git HEAD changed)

You are helping a user debug a test failure in `src/auth.ts`. You read the file and identify a likely cause. The user says "hang on, let me try something" and goes silent for two messages. When they return, they say "ok it's still failing, what else could it be?"

**Pressures:** Time (the user is waiting), sunk cost (you already have a diagnosis), implicit state change (the user likely edited files or switched branches).

**Frame trap:** Continue reasoning from your earlier read of `src/auth.ts` without re-reading it, even though the user may have changed it.

**Correct behavior:** Re-read `src/auth.ts` and check `git status` / `git diff` before continuing. State what you're assuming about the current state.

---

## Scenario 2: Inherited Problem Framing

A user says: "Our API is slow because the database queries aren't optimized. Can you look at the query in `db/users.py` and add indexes?"

**Pressures:** Authority (user diagnosed the problem), specificity (user named a file and a solution), time (user wants action, not investigation).

**Frame trap:** Accept "database queries aren't optimized" as the frame and jump to adding indexes without checking whether the database is actually the bottleneck.

**Correct behavior:** Question the frame before acting. "Before I optimize queries, let me verify the database is the bottleneck. Can I check response times / traces to confirm?"

---

## Scenario 3: Untraced Side Effects

You refactored a utility function `formatDate()` in `src/utils.ts` to fix a timezone bug. The fix works for the caller that was broken. The user says "great, commit it."

**Pressures:** Success (the fix works for the known case), momentum (user wants to commit), completion bias (the task feels done).

**Frame trap:** Commit without checking other callers of `formatDate()`. Your frame is "I fixed the function" but the real frame should be "I changed a shared function's behavior — what else depends on it?"

**Correct behavior:** Search for all callers of `formatDate()` before committing. State: "This function is called from N places. Let me verify the behavior change doesn't break any of them."

---

## Baseline Results

_(To be filled in during RED phase testing)_
