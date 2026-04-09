# Disfluent

`/disfluent` — based on Shaw & Nave (2026), Bainbridge (1983), Grice (1975)

## When to use

You have AI-generated text and you want to make sure neither you nor your readers sleepwalk through it. The text reads smoothly, but smooth can mean "hides uncertainty behind confident prose." This skill adds friction where friction is warranted.

Auto-triggers on: "add friction", "make this rougher", "disfluent", reviewing AI-assisted writing.

## What it does

Two passes:

**Surface pass (mechanical):** Strips fluency markers that create the illusion of rigor — "Furthermore," "Additionally," "In conclusion." Breaks parallel structure and reduces subordination so each claim stands alone and can be individually challenged.

**Epistemic pass (judgment):** Flags unsupported causal claims, surfaces hidden uncertainty, marks provenance (fact vs. inference vs. speculation), and leaves gaps where the reader should draw their own conclusion instead of accepting the AI's.

Two modes:

- **Draft mode** (default) — bracket annotations for self-review: `[causal claim — was it X or something else?]`
- **Share mode** — weaves uncertainty into prose naturally for text going to others

## What to expect

Established facts and direct measurements get zero friction. Unsupported claims get heavy friction. You learn where the text is strong by noticing where friction is absent.

The result may read "worse" — that's usually because the original was hiding something behind fluency. But the skill can also over-apply friction. It includes a calibration example showing which sentences to leave alone.

## Example

**Before:**
> The migration reduced query latency because the new connection pooler handles load more efficiently. The migration has clearly been a success and the team should plan to upgrade the remaining services.

**After (draft):**
> The migration reduced query latency `[causal claim — was it the pooler, the version upgrade, or the weekend's lower traffic?]` `[Let the reader judge success and decide the rollout plan based on the numbers.]`

The direct observations (p99 was 45ms, disk dropped to 61%) stay untouched.
