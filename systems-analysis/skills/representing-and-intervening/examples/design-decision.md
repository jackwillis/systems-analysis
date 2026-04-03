# Example: Deferred Email — Queue vs. Database

The team needs to send emails 24 hours after user signup. Two approaches on the table: a job queue with scheduled jobs, or a database column with a polling worker.

## Represent

**Model A (primary):** Job queue (e.g., Sidekiq scheduled jobs). The queue handles timing, retry, and delivery. Trade-off: jobs are opaque — hard to query "which emails are pending?" and hard to recover if the queue is flushed.

**Model B (alternative):** Database column (`send_email_at`) with a polling worker. The database is the source of truth. Trade-off: polling interval adds latency jitter, and the worker needs distributed locking to avoid double-sends at scale.

**Divergence:** Model A fails visibly when the queue loses state. Model B fails visibly when polling load grows or locking breaks. Model A is simpler to implement; Model B is more observable.

**Least confident about:** Whether the team needs to query pending emails (admin dashboard, support tooling). If yes, Model B wins on observability.

## Predict

If the team needs to answer "which emails are pending right now?" more than rarely, Model B will save significant work. If they don't, Model A is simpler to implement and operate.

## Intervene

Ask the product owner whether support or ops needs visibility into pending emails. Check whether the existing stack already has a job queue with scheduled job support.

## Observe

Product confirms support needs a "pending emails" view for troubleshooting. Existing stack has Sidekiq but the team has no pattern for querying scheduled jobs.

## Update

Model B selected — the observability requirement tips the decision. The database-backed approach makes the pending-email query trivial (`WHERE send_email_at > NOW() AND sent_at IS NULL`).
