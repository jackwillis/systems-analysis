# Verify Causal Claims

`/causal-analysis` — based on Pearl & Mackenzie (2018)

## When to use

Someone (you, a coworker, a report) is claiming that X causes Y. Or you're designing a study to test whether it does. The data looks convincing, but you haven't checked whether it can actually answer a causal question.

Auto-triggers on: "does X cause Y", "should we change X to improve Y", "the data shows...", observational data presented as evidence for intervention.

## What it does

Walks through Pearl's causal framework:

1. **Rung placement** — is this an association (what correlates?), an intervention (what happens if we do X?), or a counterfactual (what would have happened?)? Most claims from observational data are associations dressed up as interventions.
2. **Estimand** — states precisely what you're trying to measure before touching data.
3. **DAG** — draws the causal structure. Identifies confounders, mediators, and colliders.
4. **Identification** — checks whether the causal effect can be estimated from the available data, or whether an experiment is needed.
5. **Threats** — checks for reverse causation, collider bias, SUTVA violations, and other common mistakes.

## What to expect

Claude will push back on causal language that isn't supported by the study design. If the data is observational, it will identify confounders and say whether adjustment can fix them. If not, it will recommend an experiment and sketch the design.

For simple causal structures, it states the estimand and the main threat in a sentence each.

## Examples

**Collider bias in hiring.** A company finds no correlation between degree prestige and job performance among employees. The skill identifies that "Hired" is a collider — by only looking at hired employees, you've induced a spurious negative association. The null finding is exactly what collider bias predicts, even if degrees genuinely matter.

**Rung demotion.** A manager sees that PRs with more review comments have fewer production incidents and proposes requiring 3+ comments on all PRs. The skill identifies PR complexity as a confounder — complex PRs attract both more review and more careful authoring. The policy intervenes on the signal, not the cause.

**Non-identifiable effect.** Mentored employees get promoted at 2x the rate. The skill identifies that mentors select mentees based on unmeasured traits (ambition, visibility) that also drive promotion. The effect isn't identifiable from observational data — recommends a lottery-based assignment when the program is oversubscribed.
