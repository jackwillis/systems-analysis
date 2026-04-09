# Example: Default Value Propagation

A `fetch_user_profile` function changes its `include_inactive` default from `True` to `False`. The type signature is identical: `def fetch_user_profile(user_id: str, include_inactive: bool = ...) -> UserProfile`.

## Name the Change

Changing `fetch_user_profile`'s `include_inactive` parameter default from `True` to `False`. The signature and return type are unchanged. Callers that pass `include_inactive` explicitly are unaffected. Callers that rely on the default will silently get different behavior.

## Hop One

Grep finds 8 callers. 5 pass `include_inactive` explicitly — structurally and behaviorally compatible.

3 rely on the default:

| Caller | Classification | Reasoning |
|--------|---------------|-----------|
| `render_dashboard` | Behaviorally compatible | Displays active users only. The new default (exclude inactive) matches what it already wants. |
| `export_all_users` | **Breaking** | Exports all users for compliance reporting. Relied on the old default to include inactive users. Will now silently drop them from exports. |
| `sync_to_warehouse` | **Breaking** | Syncs user data to the data warehouse. Relied on the old default. Also passes the result downstream — follow to hop two. |

## Hop Two

`sync_to_warehouse` passes its result downstream. Two consumers:

| Consumer | Classification | Reasoning |
|----------|---------------|-----------|
| `warehouse_dashboard` | Behaviorally compatible | Displays sync stats. Handles any record count. |
| `warehouse_reconciliation_job` | **Breaking** | Compares warehouse records against source. Assumes the sync includes inactive users. With the new default, every inactive user appears as "deleted from source" — the job will trigger bulk removal from the warehouse. |

## Report

8 consumers at hop one (6 compatible, 2 breaking). 2 consumers at hop two (1 compatible, 1 breaking).

Breaking consumers: `export_all_users`, `sync_to_warehouse`, `warehouse_reconciliation_job`.

## What the Trace Caught

The hop-two break is the most dangerous. `warehouse_reconciliation_job` is structurally compatible — it receives the same types, compiles fine, runs without error. It's behaviorally breaking — it interprets missing inactive users as deletions and acts on that interpretation. This would have passed type checks, passed most tests, and silently purged inactive user records from the warehouse.

At hop one, this break is invisible. `sync_to_warehouse` looks like any other caller that needs updating. The damage happens one hop further out, where the reconciliation job acts on the changed data.
