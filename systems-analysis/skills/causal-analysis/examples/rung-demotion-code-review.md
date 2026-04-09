# Example: Do Code Review Comments Prevent Production Incidents?

An engineering team observes that PRs with more review comments take longer to merge but have fewer production incidents. A manager proposes requiring all PRs to receive at least 3 review comments before merge: "code review prevents bugs."

## Step 1: Pearl's Ladder

The manager's proposal is Rung 2: "If we mandate ≥3 comments, will incidents decrease?" The evidence is Rung 1: an association between comment count and incident rate. This is a classic case of Rung 1 data dressed up as a Rung 2 claim.

## Step 2: Gather Context

Review comments are not randomly distributed across PRs. Complex, risky, or large changes attract scrutiny — reviewers spend more time and leave more comments on code they find concerning. The same complexity that attracts comments also causes the author to implement more carefully (more tests, smaller increments, extra validation).

## Step 3: Estimand

The ATE of requiring ≥3 review comments on all PRs on production incident rate, compared to the current process (no comment minimum).

## Step 4: DAG

```
PR Complexity (C) → Review Comments (T)
PR Complexity (C) → Careful Implementation → Fewer Incidents (Y)
Review Comments (T) → Fewer Incidents (Y)  [maybe — but weaker than confounded path]
```

PR Complexity is a confounder. It drives both comment volume and implementation care. The observed correlation between comments and fewer incidents is largely (possibly entirely) explained by complexity: risky PRs get both more review AND more careful authoring.

**Rung demotion:** The strongest claim the data supports is "complex PRs that receive review comments have fewer incidents." But this does not entail "mandating comments on simple PRs will reduce incidents." The comments are a *signal* of complexity-driven care, not a *cause* of quality. Mandating 3 comments on a trivial config change tests a completely different causal question than the one the data answers.

**Key takeaway:** The policy intervenes on the signal, not the cause. Expect the mandate to produce pro-forma "LGTM" comments on simple PRs with no effect on incident rates — while adding merge latency across the board.
