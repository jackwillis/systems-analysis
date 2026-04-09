# Example: Internal Refactor Fast Exit

A `calculate_shipping_cost` function is refactored: the discount logic is extracted into a private helper `_apply_discount`. The public signature (`def calculate_shipping_cost(order: Order) -> Decimal`), return type, and behavior are unchanged.

## Name the Change

Extracting `_apply_discount` from `calculate_shipping_cost`. Internal refactor — the public interface is unchanged.

## Fast Exit

The change is internal to one module. `calculate_shipping_cost` has the same signature, same return type, and same behavior. The new helper is private (prefixed with `_`) and not exported. Callers of `calculate_shipping_cost` see no difference.

"Extracting `_apply_discount` from `calculate_shipping_cost` — internal refactor, public interface absorbs the change. No propagation."

## Why This Isn't a Trace

The boundary test: does the change affect something in a different file or module that other code reads, calls, or assumes? No. The change is entirely within one module's implementation. The interface absorbs the difference.

A trace here would be ceremony without value — grep would confirm that no external code references `_apply_discount` (it didn't exist before), and every caller of `calculate_shipping_cost` is structurally and behaviorally compatible because nothing changed from their perspective.

## When This Fast Exit Would Be Wrong

If the refactor *also* changed behavior — say, `_apply_discount` rounds differently than the inline code it replaced — the fast exit doesn't apply. The change looks internal but the interface's behavior changed. The boundary test catches this: the return value of `calculate_shipping_cost` is now different for some inputs, which means the change *does* affect code that depends on the output. Trace it.

The fast exit is for changes where the interface genuinely absorbs the difference, not for changes where it appears to.
