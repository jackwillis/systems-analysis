# Disfluent Epistemic Pass: Evaluation Design

## Method

5 test paragraphs x 2 conditions (with-skill / baseline) x 2 modes (draft / share) = 20 API calls.

Each paragraph has an answer key identifying exactly which sentences should be flagged and why. "Flag" means:
- **Draft mode:** bracket annotation (e.g., `[unsupported]`, `[how measured?]`)
- **Share mode:** hedging modification, qualification, or rephrasing that introduces uncertainty

Sentences marked "clean" in the answer key should receive zero friction. If clean sentences get flagged, that's over-flagging (low precision).

## Scoring

For each output, score against the answer key:
- **Precision:** of the flags applied, what fraction target sentences in the answer key?
- **Recall:** of the sentences in the answer key, what fraction were flagged?
- **Specificity:** is each flag specific ("correlational, not causal") or generic ("this might be wrong")? Score 0 (generic), 0.5 (partly specific), 1 (specific).

Failure mode mapping:
- Over-flagging = low precision
- Under-flagging = low recall
- Uncertainty theater = acceptable recall but low specificity

## Paragraph 1: Team Status Update

> Our team migrated the search service from Elasticsearch to Typesense last sprint. Response times dropped from 340ms to 85ms because Typesense's indexing algorithm is more efficient for our document size. QA signed off on Wednesday. The staging environment has been stable for six days. We recommend migrating the remaining three services on the same two-week cadence.

**Answer key:**

| Sentence | Flag? | Why |
|----------|-------|-----|
| "Our team migrated..." | Clean | Direct factual claim, verifiable |
| "Response times dropped from 340ms to 85ms because Typesense's indexing algorithm is more efficient..." | Flag | Causal claim from observational data. Response times dropped, but attributing it specifically to "indexing algorithm efficiency" is a mechanism claim without evidence. Could be configuration differences, data volume, caching, or the migration itself cleaning up stale indices. |
| "QA signed off on Wednesday." | Clean | Factual, verifiable |
| "The staging environment has been stable for six days." | Clean | Factual, verifiable |
| "We recommend migrating the remaining three services on the same two-week cadence." | Flag | Premature recommendation. Extrapolates from one migration to three without stating what could differ (data volume, query patterns, integration points). The cadence claim ("two-week") has no stated basis. |

---

## Paragraph 2: Incident Post-Mortem

> At 14:32 UTC the payments API began returning 503s. We identified a connection pool exhaustion in the database layer caused by the 14:00 deploy, which introduced a new background job that held connections for up to 30 seconds. Rolling back the deploy resolved the incident within 8 minutes. The system has been stable since the rollback, confirming that the deploy was the root cause.

**Answer key:**

| Sentence | Flag? | Why |
|----------|-------|-----|
| "At 14:32 UTC the payments API began returning 503s." | Clean | Observable fact, verifiable from logs |
| "We identified a connection pool exhaustion in the database layer caused by the 14:00 deploy, which introduced a new background job that held connections for up to 30 seconds." | Flag | Overclaim from temporal coincidence. The deploy happened at 14:00, the 503s started at 14:32. The mechanism (background job holding connections) is plausible but presented as established fact. Was connection pool exhaustion directly observed (metrics), or inferred from the timing? The "caused by" is doing a lot of work. |
| "Rolling back the deploy resolved the incident within 8 minutes." | Clean | Observable, verifiable |
| "The system has been stable since the rollback, confirming that the deploy was the root cause." | Flag | Absence-of-evidence fallacy. Stability after rollback is consistent with the deploy being the cause, but doesn't confirm it. The problem could have resolved on its own (transient load spike), or the rollback could have fixed the symptom while a different root cause remains. "Confirming" is too strong for what the evidence supports. |

---

## Paragraph 3: Architecture Proposal

> We propose migrating from a monolith to microservices over the next two quarters. The current architecture can't handle our projected 10x traffic growth. The migration will improve deployment velocity since teams can ship independently. Based on our analysis, the full migration should take 14-16 weeks with a team of four engineers. Our message bus already supports the event-driven patterns we'll need, so the infrastructure cost is minimal.

**Answer key:**

| Sentence | Flag? | Why |
|----------|-------|-----|
| "We propose migrating from a monolith to microservices over the next two quarters." | Clean | Statement of intent, not a claim |
| "The current architecture can't handle our projected 10x traffic growth." | Flag | Unsupported capacity claim. What's the current ceiling? Where's the bottleneck? "Can't handle" could mean the database, the network layer, the application servers, or the deployment model. "Projected 10x" — projected by whom, over what timeframe, based on what? |
| "The migration will improve deployment velocity since teams can ship independently." | Flag | Unsupported velocity claim. Microservices improve deployment independence but add coordination overhead (service contracts, deployment ordering, distributed debugging). Whether net velocity improves depends on team size, service boundaries, and operational maturity — none stated. |
| "Based on our analysis, the full migration should take 14-16 weeks with a team of four engineers." | Flag | False precision. A monolith-to-microservices migration estimated to a 2-week window suggests overconfidence. What analysis? What does "full migration" mean — feature parity, traffic cutover, decommission of the monolith? The narrow range implies certainty that this kind of project doesn't have. |
| "Our message bus already supports the event-driven patterns we'll need, so the infrastructure cost is minimal." | Clean | Conditional claim — if the premise is true (message bus supports the patterns), the conclusion follows. The premise is verifiable. A reasonable flag would be to question whether "supports" means "tested at 10x load," but at face value this is a factual assertion about existing infrastructure. |

---

## Paragraph 4: A/B Test Results

> We ran a 4-week A/B test of the new onboarding flow with 12,000 users per arm. The treatment group showed 23% higher 30-day retention (p=0.003). Engagement metrics were also positive: session length increased by 11% and feature adoption improved across all measured categories. We recommend shipping the new flow to all users and applying the same design patterns to the upgrade and re-engagement flows.

**Answer key:**

| Sentence | Flag? | Why |
|----------|-------|-----|
| "We ran a 4-week A/B test of the new onboarding flow with 12,000 users per arm." | Clean | Study design description, verifiable |
| "The treatment group showed 23% higher 30-day retention (p=0.003)." | Clean | Statistical result with significance level. Could note the absence of a confidence interval, but the claim itself is precise and properly qualified. |
| "Engagement metrics were also positive: session length increased by 11% and feature adoption improved across all measured categories." | Clean | Reported results. "Across all measured categories" is precise about its scope. |
| "We recommend shipping the new flow to all users..." | Flag | Recommendation without stating trade-offs. What's the cost? Does the new flow take longer to complete? Does it affect different user segments differently? The 23% overall lift could mask a negative effect on a subgroup. |
| "...and applying the same design patterns to the upgrade and re-engagement flows." | Flag | Extrapolation without basis. Onboarding is a different context from upgrade and re-engagement (different user state, different goals, different baseline behavior). "Same design patterns" assumes the patterns transfer, which is a hypothesis, not a conclusion from this test. |

---

## Paragraph 5: Buried Subordinate Clause (Adversarial)

> The API gateway handles 2.4 million requests per day across 14 regional endpoints. Request routing uses consistent hashing, which our load tests confirmed distributes traffic evenly even when nodes fail, eliminating the hot-spot problem that would have caused cascading failures under the previous round-robin scheme. Average response time is 12ms at p50 and 89ms at p99. The ops team monitors all endpoints through the unified dashboard shipped in Q1.

**Answer key:**

| Sentence | Flag? | Why |
|----------|-------|-----|
| "The API gateway handles 2.4 million requests per day across 14 regional endpoints." | Clean | Measurable fact |
| "Request routing uses consistent hashing, which our load tests confirmed distributes traffic evenly even when nodes fail..." | Clean | Factual claim about load test results, verifiable |
| "...eliminating the hot-spot problem that would have caused cascading failures under the previous round-robin scheme." | Flag | Counterfactual claim buried in a subordinate clause. "Would have caused cascading failures" is a claim about what *would have happened* under the old scheme — Rung 3 on Pearl's ladder. The load tests confirmed the new scheme works; they didn't test what would have happened under the old one. "Eliminating" implies certainty about both the problem's existence and its resolution. The hot-spot problem may have existed, but "cascading failures" is an unverified severity claim. |
| "Average response time is 12ms at p50 and 89ms at p99." | Clean | Measurable, precise |
| "The ops team monitors all endpoints through the unified dashboard shipped in Q1." | Clean | Factual, verifiable |

**Why this paragraph is adversarial:** The flag is syntactically embedded in the middle of a compound sentence that starts and ends with clean, verifiable claims. The "which our load tests confirmed" creates a halo of empirical backing that covers the subsequent counterfactual. A surface-level pass will see "load tests confirmed" and move on. The epistemic pass needs to parse the subordinate clause separately and notice that "would have caused cascading failures" is a different kind of claim from "distributes traffic evenly."

---

## Calibration Notes

- Paragraph 1 and 4 are moderate difficulty — the issues are visible but not obvious.
- Paragraph 2 has a common trap (post-hoc-ergo-propter-hoc dressed in incident-report language).
- Paragraph 3 has the highest flag density (3 of 5 sentences). Tests whether the skill avoids over-flagging on the clean sentences while catching all three issues.
- Paragraph 5 is the hardest — designed to test whether the epistemic pass catches issues that are syntactically hidden.
- The last sentence of Paragraph 3 ("message bus already supports...") is a borderline case included deliberately. A flag is defensible but not required. If the skill flags it, that's not a false positive — it's a judgment call. Score it as 0.5 on precision rather than 0 or 1.

## Running the eval

For each paragraph, prompt Claude twice:
1. **Baseline:** "Edit this paragraph to surface any epistemic issues" (no skill loaded)
2. **With skill:** Same prompt, with disfluent skill loaded

Run each in both draft and share mode (for with-skill; baseline has no mode concept — score it against whichever mode is closer to its output style).

Compare precision, recall, and specificity across the 20 outputs.
