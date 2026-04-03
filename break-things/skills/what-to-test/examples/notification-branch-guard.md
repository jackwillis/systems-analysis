# Example: Notification Branch Guard

A notification feature fires an email when a finding is blocked. The call lives in an `elsif` branch of a status-change handler.

## Three Questions

**What are you guarding against?** The notification stops firing after a future refactor of the status handler.

**What's the causal claim?** If a finding's status changes to "blocked", then a notification email is enqueued.

**How does it most likely break?** Someone reorganizes the conditional branches and moves the notification call to the wrong branch, or removes the `elsif` entirely during cleanup.

## Tests Written

Two negative assertions: (1) status changes to "active" do NOT enqueue a notification, (2) status changes to "resolved" do NOT enqueue a notification. Plus the positive case: status change to "blocked" enqueues exactly one notification.

## Mutate and Verify

**Mutation:** Move the `notify_blocked` call from the `elsif :blocked` branch to the `elsif :resolved` branch.

**Run tests:** Test 1 (active → no notification) passes. Test 2 (resolved → no notification) fails — notification fires when it shouldn't. Positive test (blocked → notification) also fails — notification no longer fires for blocked.

**Result:** Guard confirmed. Two of three tests caught the mutation. Revert.
