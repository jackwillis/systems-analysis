# Example: Webhook Handler Suite Audit

A payments service handles Stripe webhooks. The team has 40 tests, all passing, 85% line coverage. Production had two incidents last quarter: a duplicate charge from a replayed webhook, and a silent failure when a subscription upgrade webhook arrived out of order.

## Three Questions

**What's the failure space?**
1. Duplicate processing from replayed/retried webhooks
2. Out-of-order webhooks (upgrade arrives before subscription creation)
3. Malformed payloads from Stripe API changes
4. Auth bypass on the webhook endpoint
5. Silent swallowing of unknown event types
6. Partial failure mid-processing (charge succeeds, record not written)

**What does the suite guard?** 35 of 40 tests cover happy-path processing of known event types — none of the 6 failure modes. 3 test payload validation (partially covers #3). 2 test endpoint authentication (covers #4).

**Where are the gaps?** #1 (idempotency), #2 (ordering), #5 (unknown events), and #6 (partial failure) are unguarded. The two production incidents (#1, #2) had no corresponding tests.

## Variety Analysis

D (failure space) = 6 distinct modes. R (test suite) = 3 modes covered. D > R. The suite's variety is half the failure space's variety.

**Priority:** #1 and #2 first (already caused incidents), then #6 (severity — data corruption), then #5 (silent failure).

## Next Step

For each gap, use `what-to-test` to design the guard. The gap is the answer to question 1 (what you're guarding against). The production incident history provides the failure mode for question 3.
