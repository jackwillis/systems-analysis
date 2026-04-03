# Example: Notification Overload

Users complain about receiving 15-20 emails per day. The team proposes per-notification-type rate limits: max 3 of each type per day.

## Name the Parts

- **D** — notification triggers (12 event types: comments, likes, follows, mentions, system alerts, digest, etc.)
- **R** — rate limiter (proposed: per-type cap of 3/day)
- **T** — notification delivery pipeline
- **E** — user attention (inbox noise level)
- **η** — users perceive notifications as useful, not spammy (proxy: unsubscribe rate < 2%)

## Requisite Variety

**Executable verification:** Count D's variety — 12 event types, each independently triggered. Under the proposed per-type cap: worst case is 12 x 3 = 36 emails/day. That's worse than the current problem. R (per-type caps) doesn't constrain the *aggregate* — it constrains each channel independently while the user experiences the sum.

## Good Regulator

The rate limiter models "too many" per type, but the user experiences notifications as a single stream. The regulator has no model of aggregate load. A per-type cap is a regulator of individual channels that doesn't model the system (the user's inbox) it's regulating.

## Constraints

Structure in D that reduces effective variety: notifications cluster by trigger event (a popular post generates comments, likes, and mentions together). These aren't independent — they share a root cause. Constraint: deduplicate by root entity (one notification per source-object per time window) rather than capping per type. This reduces D's effective variety from "all independent events" to "distinct things that happened."

## Recommendation

Replace per-type rate limits with (1) per-user aggregate daily cap, and (2) deduplication by source entity. The aggregate cap directly regulates E (total inbox load). The deduplication exploits the constraint that notifications aren't independent — they cluster around events.
