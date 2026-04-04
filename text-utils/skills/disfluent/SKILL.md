---
name: disfluent
description: |
  Introduce strategic disfluency into AI-generated text to prevent cognitive
  surrender. The inverse of humanizer: where humanizer makes AI output pass
  for human writing, disfluent makes it require human engagement. Two passes
  (surface + epistemic) and two modes (draft + share). Use when editing AI
  output before sharing, reviewing your own AI-assisted work, or when you
  want to force deliberative engagement with text. Triggers on "make this
  rougher", "add friction", "disfluent", "I don't want people to just
  accept this", "make me think about this".
---

# Disfluent: Strategic Friction for AI Text

Fluent AI output triggers cognitive surrender — uncritical adoption of AI-generated answers (Shaw & Nave, 2026). This skill introduces deliberate disfluency to reactivate the reader's deliberation. It is not about making text worse. It is about making text honest about what it knows.

> "When System 3's outputs are fast, fluent, and seemingly authoritative, users may bypass effortful reasoning and adopt its answers as their own. Conversely, when outputs introduce disfluency, System 3 can trigger greater deliberation." — Shaw & Nave (2026)

## Your Task

When given text to make disfluent:

1. **Run the surface pass** — strip fluency markers that create false authority
2. **Run the epistemic pass** — find where fluency hides real uncertainty
3. **Apply the appropriate mode** — draft (annotations) or share (rephrased)
4. **Present the result** with a brief summary of changes

## Two Modes

**Draft mode** (default): For self-review. Uses bracket annotations, direct questions, explicit markers like `[unsupported]`, `[how measured?]`, `[your judgment]`. Blunt. The writer sees exactly where the friction is.

**Share mode**: For text going to others. Weaves uncertainty into prose naturally — still disfluent, but professional. Rephrases rather than annotates.

**Mode inference:**
- Default: draft mode
- Explicit: `/disfluent share` or `/disfluent draft`
- Inferred: if the text is addressed to someone ("Hi team," "Dear X") or the user asked for text meant for others, use share mode automatically

---

## PASS 1: SURFACE (MECHANICAL)

Strip fluency markers that create false authority. Fluent delivery triggers cognitive surrender regardless of content quality (Shaw & Nave, 2026).

### 1. Strip False Connectives

**Kill list:** Furthermore, Additionally, Moreover, It's worth noting that, Importantly, It should be noted that, In addition, What's more, Notably, Significantly, Crucially

**Problem:** These words create the illusion of logical flow where there is none. They signal "I have built an argument" when the text is just listing claims. Removing them forces the reader to evaluate whether the claims actually connect.

**Before:**
> Furthermore, the team has improved deployment frequency. Additionally, error rates have dropped. Moreover, customer satisfaction scores are up.

**After:**
> The team has improved deployment frequency. Error rates have dropped. Customer satisfaction scores are up.

The reader now has to decide: are these three facts related, or just adjacent? That decision is the point.

---

### 2. Break False Completeness

**Kill list:** In conclusion, This represents a major step, Overall, Taken together, In summary, This demonstrates that, These findings suggest that, This underscores the importance of

**Problem:** Neat conclusions signal "you can stop thinking now." Cutting them leaves the reader to draw their own inference.

**Before:**
> Response times have improved by 40% since the migration. Error rates are down. In conclusion, the migration to microservices has been a clear success, demonstrating the value of modern architectural patterns.

**After:**
> Response times have improved by 40% since the migration. Error rates are down.

Let the reader conclude. If the evidence is good, they will. If they don't, the evidence wasn't good enough — and you learned something.

---

### 3. Break Parallel Structure

**Problem:** Rule of three, balanced lists, and symmetric phrasing signal "this is complete and considered." They create a false sense of thoroughness. Real analysis is usually uneven — some points matter more, some are uncertain.

**Before:**
> The platform offers improved reliability, enhanced scalability, and better developer experience.

**After:**
> The platform is more reliable. It may scale better, though we haven't load-tested past current traffic. Developers say they prefer it.

Uneven treatment reflects uneven evidence. That's honest.

---

### 4. Reduce Subordination

**Problem:** Complex sentences with multiple dependent clauses read as authoritative and complete. They're hard to argue with because it's hard to isolate which part you disagree with. Shorter sentences are easier to challenge individually.

**Before:**
> By leveraging the new caching layer, which was designed to handle the increased throughput requirements that emerged after the Q3 traffic spike, the team was able to reduce p99 latency by 60%.

**After:**
> The team added a caching layer after the Q3 traffic spike. p99 latency dropped 60%. [Was it the cache, or did traffic also change?]

---

## PASS 2: EPISTEMIC (JUDGMENT)

Find where fluency hides real uncertainty. The human needs to stay engaged with the substance, not just the surface (Bainbridge, 1983).

### 5. Flag Unsupported Claims

**Problem:** AI text asserts things confidently without evidence. Readers accept confident assertions more readily than hedged ones, even when the confidence is unwarranted.

**Draft mode:**
> The migration improved reliability. `[How measured? Compared to what baseline?]`

**Share mode:**
> The migration improved reliability, though the team hasn't published before/after metrics.

Look for: causal claims without evidence, quantitative claims without sources, evaluative claims ("improved," "better," "successful") without criteria.

---

### 6. Surface Hidden Uncertainty

**Problem:** AI text presents one interpretation as if it's the only one. It says "X causes Y" when the evidence is correlational. It treats complex situations as settled.

**Draft mode:**
> Users who received onboarding emails had 20% higher retention. `[Correlation — engaged users were more likely to both open emails and retain. Not necessarily causal.]`

**Share mode:**
> Users who received onboarding emails had 20% higher retention, though this may reflect engagement differences rather than email effectiveness.

Look for: "causes," "leads to," "results in," "drives" used with observational data. Any time one explanation is given for a phenomenon that has several plausible explanations.

---

### 7. Leave Gaps for Human Judgment

**Problem:** AI text draws conclusions the reader should draw themselves. This is the deepest form of cognitive surrender — the reader outsources the judgment, not just the analysis.

**Draft mode:**
> `[Given these trade-offs, which approach fits your constraints?]`

**Share mode:**
> The trade-offs suggest different answers depending on how you weight reliability against development speed.

Look for: recommendations, "the best approach is," "teams should," "the clear winner." Replace with the evidence and let the reader decide.

---

### 8. Mark Provenance

**Problem:** AI text blends established facts, inferences, and speculation into a single confident voice. The reader can't tell which parts to trust.

**Draft mode:**
> Python 3.12 added `@override`. `[fact]` Early benchmarks show 5-10% performance gains. `[benchmarks exist but sample is small]` This could make Python competitive with Go for CLI tools. `[speculation]`

**Share mode:**
> Python 3.12 added `@override`. Early benchmarks — though limited — show 5-10% performance gains. Whether this makes Python competitive with Go for CLI tools is an open question.

---

## WHAT THIS SKILL IS NOT

**Disfluent is not humanizer.** Humanizer makes AI text pass for human writing. Disfluent makes AI text demand human engagement. Humanizer removes AI patterns; disfluent exposes epistemic gaps. Text can be both humanized and disfluent, or neither.

**Disfluent does not make text worse.** It makes text more honest. If the result reads worse, it's because the original was hiding something behind fluency.

**Disfluent does not apply uniformly.** Established facts get zero friction. Unsupported claims get heavy friction. The contrast is informative — the reader learns where the text is strong by noticing where the friction is absent.

---

## Process

1. Read the input text
2. Determine mode (draft/share) from explicit flag or context
3. Run surface pass: strip connectives, break completeness, break parallels, reduce subordination
4. Run epistemic pass: flag unsupported claims, surface uncertainty, leave gaps, mark provenance
5. Present the result with a brief summary of what changed

## Output Format

Provide:
1. The transformed text
2. A brief summary: what was stripped (surface), what was flagged (epistemic)

---

## Full Example

**Before (fluent AI output):**
> The quarterly security audit revealed several important findings. Furthermore, the team identified three critical vulnerabilities in the authentication system. Additionally, the audit highlighted that the API rate limiting configuration was insufficient for current traffic patterns. Moreover, logging coverage has improved significantly since last quarter. In conclusion, while challenges remain, the security posture has improved substantially, demonstrating the team's commitment to maintaining robust defenses. The team should continue to prioritize security improvements in the coming quarter.

**After (draft mode):**
> The quarterly security audit found three critical vulnerabilities in the authentication system. The API rate limiting configuration doesn't handle current traffic. [What are the three vulns? "Critical" by whose classification?] Logging coverage increased since last quarter. [By how much? Which services?] [The "improved security posture" conclusion doesn't follow — you just said there are three critical auth vulns. Let the reader reconcile these.]

**After (share mode):**
> The quarterly security audit found three critical vulnerabilities in the authentication system and determined that API rate limiting doesn't handle current traffic. Logging coverage increased since last quarter, though the audit doesn't specify by how much. The overall security posture is mixed: logging is better, but the auth vulnerabilities are unresolved.

**Changes:**
- Surface: stripped "Furthermore/Additionally/Moreover/In conclusion," broke the parallel structure, removed "demonstrating the team's commitment" and "prioritize improvements" (false completeness)
- Epistemic: flagged unspecified vulnerabilities, flagged unquantified logging claim, challenged the conclusion that contradicts the evidence

---

## References

- Shaw, S.D. & Nave, G. (2026). "Thinking — Fast, Slow, and Artificial." Working paper, Wharton School.
- Bainbridge, L. (1983). "Ironies of Automation." Automatica, 19(6), 775-779.
- Grice, H.P. (1975). "Logic and Conversation." In Syntax and Semantics 3: Speech Acts.
