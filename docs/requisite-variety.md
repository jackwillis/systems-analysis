# Check Your Controls

`/requisite-variety` — based on Ashby (1956), Conant & Ashby (1970) · [Full skill](../systems-analysis/skills/requisite-variety/SKILL.md)

## When to use

A control system is failing — alerts are noisy, rate limiting isn't working, validation rules keep getting bypassed. The instinct is to add more rules. This skill asks whether more rules can even help.

Auto-triggers on: regulation failure, alert fatigue, "why can't we control this?"

## What it does

Names the parts of the regulation system and checks three things:

1. **Requisite variety** — does the controller have at least as many responses as there are disturbances? If your alert system has 50 alert types but only 3 actions (page, email, ignore), it's structurally overwhelmed.
2. **Good regulator** — does the controller model how the system actually works? A rate limiter that counts requests per IP doesn't model distributed botnets.
3. **Constraints** — is there structure in the problem you can exploit? Instead of matching all variety, reduce the variety you need to handle.

## What to expect

You'll see Claude name the parts: what can go wrong (the disturbance space), what you have to respond with (the regulator), the system being regulated, and what counts as acceptable — then count the distinct states on each side. If there are more ways things can go wrong than ways you can respond, the output is direct: "this controller cannot succeed regardless of tuning."

For simple cases (one obvious bottleneck), it states the gap in a sentence and moves on.

## Example

An alert routing system has 47 distinct alert types, 15 routing rules, and 3 escalation paths. The team keeps adding rules but alert fatigue persists.

The skill counts: D = 47, R = 15 effective responses. The gap is structural. Recommendation: either constrain D (deduplicate alerts by root entity) or expand R (more escalation tiers), rather than tuning the existing rules.
