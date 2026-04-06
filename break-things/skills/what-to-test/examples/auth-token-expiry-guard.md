# Example: Auth Token Expiry Guard

An API uses short-lived access tokens (15-minute expiry). A refresh endpoint issues new tokens. A support ticket reported that users get logged out at the expiry boundary even when actively using the app — the client-side refresh fires at 14 minutes but occasionally races with a request that arrives at the server just after expiry.

## Three Questions

**What are you guarding against?** The server rejects a valid refresh attempt that arrives within a small window around the expiry boundary.

**What's the causal claim?** If a refresh request arrives within 30 seconds after the token's stated expiry, the server still honors it (grace period).

**How does it most likely break?** A future developer tightens the expiry check during a security hardening pass — removing the grace window because "expired means expired" looks like the correct fix.

## Tests Written

Three assertions: (1) Token at expiry minus 60s is valid — baseline. (2) Token at expiry plus 10s is refreshable — grace period works. (3) Token at expiry plus 31s is rejected — grace period has a boundary.

The test uses a clock stub rather than real time, which means it tests the logic but not the actual race condition. Known trade-off: the unit test guards the grace-period logic; an integration test with real timing would be needed to guard the race itself.

## Mutate and Verify

**Mutation 1:** Remove the grace period — change the expiry check from `expires_at + GRACE_WINDOW` to `expires_at`.

**Run tests:** Test 1 passes (still valid before expiry). Test 2 fails — refresh at expiry+10s is now rejected. Test 3 passes (still rejected at expiry+31s). Guard confirmed for mutation 1. Revert.

**Mutation 2:** Change the grace window from 30 seconds to 5 minutes.

**Run tests:** Test 1 passes. Test 2 passes (expiry+10s is within 5 minutes). Test 3 fails — expiry+31s is now within the 5-minute grace, so the token is accepted when it should be rejected. Guard confirmed — the boundary test catches an overly generous grace window too. Revert.
