# Example: Dead Abstraction Layer

An API service has a `StorageAdapter` interface with one implementation: `PostgresStorage`. Every database call goes through the adapter. The adapter was introduced two years ago when the team considered migrating to DynamoDB. The migration never happened.

## Scope

One abstraction layer: `StorageAdapter` and its single implementation.

## Components

| Component | Purpose |
|-----------|---------|
| `StorageAdapter` interface | Abstracts database access behind a generic API |
| `PostgresStorage` class | Implements `StorageAdapter` for Postgres |
| Factory function (`get_storage()`) | Returns the single implementation |

## Delete Test

**Remove `StorageAdapter`, rename `PostgresStorage` to `Storage`, delete the factory, update callers to use `Storage` directly.**

Tests pass. The adapter methods were 1:1 wrappers around the Postgres calls — no transformation, no additional logic. The interface added a layer of indirection with no behavioral difference.

## Tuition Check

**What did `StorageAdapter` teach?** It taught the team how to isolate database access behind an interface. That pattern is well-understood — the team applies it instinctively on new projects.

**Can you name the replacement?** Yes: callers use `Storage` (the renamed Postgres class) directly. If a migration becomes real in the future, introduce the abstraction then — when there are two implementations to abstract over, not one. The replacement is simpler and obvious.

**Verdict: Weight.** The lesson is extracted (the team knows the pattern). The simple replacement is visible (direct calls). The original motivation (DynamoDB migration) never materialized. The adapter is carrying a decision that was never validated.

## What the Delete Test Almost Missed

The adapter has 14 callers. At first glance, this makes it look load-bearing — removing it requires touching 14 files. But "load-bearing by callers" is not the same as "earns its keep." The callers depend on the adapter's *interface*, and that interface is a transparent pass-through. The delete test worked because the replacement (calling Postgres directly) required only mechanical find-and-replace, not design changes.

The signal: if removing a component requires only mechanical edits (rename, re-import) and no behavioral changes, the component is indirection, not abstraction. Indirection without multiple implementations is weight.
