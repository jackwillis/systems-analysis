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

Fluent AI output may trigger what Shaw & Nave (2026) call cognitive surrender — uncritical adoption of AI-generated answers. That's one working paper, not settled science. But the mechanism is plausible: smooth text feels authoritative, and readers stop questioning it.

This skill introduces deliberate disfluency to reactivate deliberation. It won't make text worse. Whether it makes text more honest depends on how well you use it — the technique exposes gaps, but only if you're looking at the right text.

> "When System 3's outputs are fast, fluent, and seemingly authoritative, users may bypass effortful reasoning and adopt its answers as their own. Conversely, [...] when outputs introduce disfluency, System 3 can trigger greater deliberation[...]." — Shaw & Nave (2026)

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

Strip fluency markers that create false authority. Shaw & Nave's argument is that fluent delivery triggers cognitive surrender regardless of content quality. If they're right, surface-level edits do real work.

### 1. Strip False Connectives

**Kill list:** Furthermore, Additionally, Moreover, It's worth noting that, Importantly, It should be noted that, In addition, What's more, Notably, Significantly, Crucially

These words create the illusion of logical flow where there is none. They signal "I have built an argument" when the text is just listing claims. Grice's cooperative principle (1975) explains why this isn't cosmetic: readers assume connectives are *meaningful* — that "furthermore" signals a logical relationship the writer intends. Stripping it removes a false pragmatic inference, not just a word.

**Before:**
> Furthermore, the team has improved deployment frequency. Additionally, error rates have dropped. Moreover, customer satisfaction scores are up.

**After:**
> The team has improved deployment frequency. Error rates have dropped. Customer satisfaction scores are up.

Now the reader has to decide whether these three facts are related or just adjacent. But note: the same cooperative principle means readers will try to find coherence in whatever you replace it with, including the absence of connectives. There's no neutral voice — just different signals.

---

### 2. Break False Completeness

**Kill list:** In conclusion, This represents a major step, Overall, Taken together, In summary, This demonstrates that, These findings suggest that, This underscores the importance of

Neat conclusions signal "you can stop thinking now." Cut them. If the evidence is good, the reader will draw the conclusion themselves. If they don't, the evidence wasn't strong enough.

**Before:**
> Response times have improved by 40% since the migration. Error rates are down. In conclusion, the migration to microservices has been a clear success, demonstrating the value of modern architectural patterns.

**After:**
> Response times have improved by 40% since the migration. Error rates are down.

---

### 3. Break Parallel Structure

Rule of three, balanced lists, symmetric phrasing — these signal "this is complete and considered." Real analysis is usually uneven. Some points matter more. Some are uncertain. The structure should reflect that.

**Before:**
> The platform offers improved reliability, enhanced scalability, and better developer experience.

**After:**
> The platform is more reliable. It may scale better, though we haven't load-tested past current traffic. Developers say they prefer it.

---

### 4. Reduce Subordination

Complex sentences with multiple dependent clauses are hard to argue with — not because they're right, but because it's hard to isolate which part you disagree with.

**Before:**
> By leveraging the new caching layer, which was designed to handle the increased throughput requirements that emerged after the Q3 traffic spike, the team was able to reduce p99 latency by 60%.

**After:**
> The team added a caching layer after the Q3 traffic spike. p99 latency dropped 60%. [Was it the cache, or did traffic also change?]

---

## PASS 2: EPISTEMIC (JUDGMENT)

Find where fluency hides real uncertainty. Bainbridge (1983) wrote about the ironies of automation in industrial control — operators lose skill precisely when automation needs them most. The connection to AI text is indirect but suggestive: if readers stop engaging with fluent AI prose, they lose the ability to evaluate it when it matters.

### 5. Flag Unsupported Claims

AI text asserts things confidently without evidence. Confident assertions get accepted more readily than hedged ones. That much seems clear from basic psychology, though the specific effect size for AI text is not well-established.

**Draft mode:**
> The migration improved reliability. `[How measured? Compared to what baseline?]`

**Share mode:**
> The migration improved reliability, though the team hasn't published before/after metrics.

Look for: causal claims without evidence, quantitative claims without sources, evaluative claims ("improved," "better," "successful") without criteria.

---

### 6. Surface Hidden Uncertainty

AI text presents one interpretation as if it's the only one. It says "X causes Y" when the evidence is correlational. It treats complex situations as settled.

**Draft mode:**
> Users who received onboarding emails had 20% higher retention. `[Correlation — engaged users were more likely to both open emails and retain. Not necessarily causal.]`

**Share mode:**
> Users who received onboarding emails had 20% higher retention, though this may reflect engagement differences rather than email effectiveness.

Look for: "causes," "leads to," "results in," "drives" used with observational data. Any time one explanation is given for a phenomenon that has several plausible explanations.

---

### 7. Leave Gaps for Human Judgment

AI text draws conclusions the reader should draw themselves. This may be the deepest form of cognitive surrender — outsourcing the judgment, not just the analysis. Or it may just be convenience. Either way, strip it.

**Draft mode:**
> `[Given these trade-offs, which approach fits your constraints?]`

**Share mode:**
> The trade-offs suggest different answers depending on how you weight reliability against development speed.

Look for: recommendations, "the best approach is," "teams should," "the clear winner." Replace with the evidence and let the reader decide.

---

### 8. Mark Provenance

AI text blends established facts, inferences, and speculation into a single confident voice. The reader can't tell which parts to trust.

In **draft mode**, use bracket labels:
> Python 3.12 added `@override`. `[fact]` Early benchmarks show 5-10% performance gains. `[benchmarks exist but sample is small]` This could make Python competitive with Go for CLI tools. `[speculation]`

In **share mode**, let the voice shift instead of annotating. Facts get flat, declarative delivery. Inferences get hedged, conversational. Speculation gets rough, openly uncertain. The texture of the sentence tells the reader what kind of claim it is.
> Python 3.12 added `@override`. Early benchmarks — limited ones — show 5-10% performance gains. Whether that makes Python competitive with Go for CLI tools, who knows. Different problem, different constraints.

---

## WHAT THIS SKILL IS NOT

**Disfluent is not humanizer.** Humanizer makes AI text pass for human writing. Disfluent makes AI text demand human engagement. They work on different problems — one is about detection, the other about cognition. Text can be both humanized and disfluent, or neither.

**Disfluent does not make text worse.** That's the claim, anyway. If the result reads worse, it's probably because the original was hiding something behind fluency. But it's also possible you over-applied friction to text that was fine. Use judgment.

**Uniformity would defeat the purpose.** Established facts get zero friction. Unsupported claims get heavy friction. The reader learns where the text is strong by noticing where friction is absent. If you add friction everywhere, you've just made noisy text.

---

## WHERE THIS FAILS

Grice's cooperative principle means readers interpret whatever style you give them. They'll find coherence in roughness, read intention into hedges, interpret unevenness as a signal of thoroughness. There is no neutral voice — just different signals. This skill doesn't escape that. It trades one set of signals for another.

The practical consequence: if you apply this skill formulaically — same hedges, same bracket patterns, same rhythm of rough-then-smooth — the disfluency becomes its own fluency. The roughness starts to mean "this writer is careful," and the reader relaxes again. Vary the technique. Don't let it become a house style.

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

- Shaw, S.D. & Nave, G. (2026). "Thinking — Fast, Slow, and Artificial." Working paper, Wharton School. [Working paper — not peer-reviewed. The cognitive surrender framing is theirs; this skill assumes it's directionally right.]
- Bainbridge, L. (1983). "Ironies of Automation." Automatica, 19(6), 775-779. [About industrial automation, not AI text. The connection is by analogy.]
- Grice, H.P. (1975). "Logic and Conversation." In Syntax and Semantics 3: Speech Acts.
