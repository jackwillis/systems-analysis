# Example: Do Prestigious Degrees Predict Job Performance?

A company analyzes current employees and finds no correlation between degree prestige and job performance. They conclude prestigious degrees don't matter for hiring.

## Step 1: Pearl's Ladder

"Do prestigious degrees predict job performance?" is Rung 2 (intervention: should we weight degrees in hiring?). The data — performance reviews of current employees — is Rung 1. But the real problem isn't the rung gap. It's that the data was pre-filtered by a collider.

## Step 4: DAG

```
Degree Prestige → Hired (Col)
Interview Performance → Hired (Col)
Degree Prestige → Job Performance (Y)
Interview Performance → Job Performance (Y)
```

"Hired" is a collider: it is caused by both Degree Prestige and Interview Performance. The company only observes employees who were hired — they are implicitly conditioning on Hired = 1.

## Step 5: Backdoor Paths

The direct path Degree → Job Performance (Y) is the effect of interest. No confounders here — the problem isn't an open backdoor path. The problem is collider stratification.

## Step 6: Collider Check

Conditioning on Hired (which the dataset does by construction) opens a spurious path:

Degree → Hired ← Interview Performance → Job Performance

Among hired employees, Degree and Interview Performance become negatively correlated — a candidate with a less prestigious degree was hired because they interviewed exceptionally well, and vice versa. This induced negative association between Degree and Interview Performance biases the estimate of Degree → Job Performance toward zero (or negative), because Interview Performance is a competing predictor of Y.

## Step 7: Adjustment Set

Not identifiable from employee-only data. You have already conditioned on the collider by restricting to hired candidates. Controlling for Interview Performance doesn't fix it — it's part of the same collider structure.

To estimate the effect of Degree on Job Performance, you need one of:
1. **Data on rejected applicants** — break the conditioning on Hired
2. **A hiring period where degrees were ignored** — natural experiment removing one arrow into the collider
3. **An entirely different study design** that doesn't select on hiring outcome

**Key takeaway:** "No correlation among employees" does not mean "no effect." The null finding is exactly what collider bias predicts, even if prestigious degrees genuinely improve performance.
