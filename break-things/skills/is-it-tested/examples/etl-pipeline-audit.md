# Example: ETL Pipeline Suite Audit

A nightly ETL pipeline pulls vendor CSV files from S3, transforms records, and loads them into a reporting database. The team has 22 tests, all passing. No production incidents yet, but a quarterly audit is due before adding a second vendor source.

## Enumerating the Failure Space

**Boundaries:** S3 bucket (input), CSV parser (input), transformation logic (internal), reporting database (output), cron scheduler (trigger).

**Walk each boundary:**

| Boundary | Wrong | Missing | Late/reordered | Partial |
|----------|-------|---------|----------------|---------|
| S3 file | Wrong schema, encoding mismatch | File not uploaded, empty file | File arrives after pipeline starts | Truncated upload |
| Transform | Mapping error for new column | Missing mapping for added column | — | Row fails mid-batch |
| Database | Constraint violation | Connection unavailable | — | Half-loaded batch |
| Scheduler | — | Cron doesn't fire | Pipeline runs twice (overlap) | — |

**Grouped by consequence:**
1. Silent wrong data in reports (schema drift, mapping error, encoding mismatch)
2. Missing data with no alert (empty file, file not uploaded, cron skip)
3. Duplicate data (pipeline overlap, re-run without idempotency)
4. Partial load leaving database inconsistent (row failure, truncated upload, connection drop mid-load)
5. Pipeline crashes visibly (constraint violation, corrupted CSV parse failure)

**Confidence:** Least confident about mode 1 — schema drift from the vendor won't crash anything. It will just produce wrong numbers in reports.

## Three Questions

**What's the failure space?** Five modes above. Modes 1 and 2 are highest-severity because they corrupt downstream decisions without alerting anyone.

**What does the suite guard?** 18 of 22 tests verify transformation logic on known-good input (happy path for mode 1, but only for the current schema). 2 test database constraint handling (covers mode 5). 2 test the parse step with malformed CSV (partially covers mode 5).

**Where are the gaps?** Modes 2, 3, and 4 are completely unguarded. Mode 1 is guarded only for the current schema — no test verifies behavior when a column is added, removed, or retyped. Mode 5 is partially covered.

## Variety Analysis

D = 5 failure modes. R = 1.5 effectively covered (mode 5 partially, mode 1 for current schema only). The suite tests "does the transform produce correct output given correct input?" — the least dangerous scenario for a pipeline that runs unattended.

**Priority:** Mode 1 first (silent wrong data — worst severity, made worse by adding a second vendor with a different schema). Mode 2 next (silent missing data — no one notices until the monthly report looks wrong). Mode 4 third (partial load — data inconsistency).

## Next Step

For modes 1 and 2, use `what-to-test` to design guards. Mode 1's causal claim: "If the vendor adds a column, the pipeline either processes it correctly or fails loudly." Mode 2's causal claim: "If the S3 file is missing at the scheduled time, an alert fires within one hour."
