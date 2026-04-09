# Proposal: Decision Journal

## The problem

Design decisions are made in conversation and lost. Someone asks "why is it like this?" six months later and the answer is "git blame says Jack changed it in March" with no record of what was considered and rejected, or what assumptions the decision depended on.

LLMs make this worse: they produce fluent, confident recommendations that feel complete. The user accepts, the code ships, and the reasoning evaporates. The decision looked obvious at the time. When the assumptions change, nobody remembers what the assumptions were.

## Core mechanism

When making a design choice, record four things:

1. **What you chose.** The option you're going with.
2. **What you rejected.** The alternatives you considered. (If you didn't consider alternatives, that's a signal — see R&I's competing models.)
3. **Why.** The specific reasons this option won. Not "it's simpler" but "it avoids a database migration, and we're in a feature freeze until March 15."
4. **What would make you reconsider.** The conditions under which this decision should be revisited. "If we need to support multi-tenant access, the single-table design breaks." "If latency requirements drop below 50ms, the caching layer isn't worth the complexity."

Item 4 is the key. It turns a decision into a falsifiable claim with an expiration condition.

## What this is NOT

- **Not an ADR (Architecture Decision Record).** ADRs are formal documents that live in a `docs/decisions/` directory. This skill produces something lighter — a structured commit message annotation, a PR comment, or a code comment. The overhead needs to be low enough that people actually do it.
- **Not a planning tool.** Writing-plans handles "what should we build and in what order." Decision journal handles "we chose X over Y, here's why, here's when to revisit."
- **Not R&I.** R&I models the system to diagnose a problem. Decision journal records the reasoning behind a choice. R&I might produce the analysis that informs the decision; the journal records the decision itself.

## Relationship to existing skills

- **Inverse of staleness-check.** Staleness-check asks "has the world changed since I last looked?" Decision journal records what the world looked like when you decided, so future-you can tell whether it's changed. The "what would make you reconsider" field is a pre-written staleness trigger.
- **Downstream of R&I.** R&I's Represent phase produces competing models. The decision journal records which model you chose and why. If R&I is "how does this work?", the journal is "given how it works, here's what we decided."
- **Connects to causal-analysis.** If the "why" includes a causal claim ("we chose X because X causes better performance"), causal-analysis can audit whether that claim is supported. The journal makes the causal assumption explicit and auditable.

## Design questions

- **Format and location.** Where does the journal entry live? Options: structured commit message, PR description, code comment at the decision point, separate file. Each has tradeoffs — commit messages are permanent but hard to find; code comments are discoverable but clutter the code; separate files add overhead.
- **Granularity.** Not every decision needs a journal entry. "Should we use a hash map or a list?" doesn't. "Should we use a relational database or a document store?" does. The skill needs a threshold — probably keyed to reversibility. Hard-to-reverse decisions get journal entries; easy-to-reverse ones don't.
- **The "what would make you reconsider" problem.** This is the most valuable field and the hardest to fill. It requires imagining future states — which is forecasting, and LLMs aren't great at it. The skill could provide prompts: "What assumption about scale does this depend on?", "What assumption about the team does this depend on?", "What external dependency could change?"
- **Integration with git.** The most natural place for a decision journal in a code context is the commit or PR. A structured format in PR descriptions could be lightweight enough to adopt: `## Decision: [choice] over [alternative] because [reason]. Revisit if: [condition].`

## What would make this skill strong

The "revisit if" field. Most decision records are write-only — nobody reads them. But "revisit if" creates a trigger that future conversations can check against. If the staleness-check skill could cross-reference decision journal entries... that's a feedback loop between two skills.

The low overhead. If the skill produces a 3-line annotation rather than a full document, it might actually get used. ADRs fail because they're too heavy. This should feel like writing a good commit message, not writing a design doc.

## What could go wrong

- Nobody reads the entries. Decision journals are valuable in theory and ignored in practice. The skill needs to produce entries that are discoverable — attached to the code they affect, not buried in a separate directory.
- The "revisit if" conditions are too vague to be useful. "Revisit if requirements change" is a non-condition. The skill needs to push for specificity: "Revisit if the user count exceeds 10K" is actionable; "revisit if things get more complex" is not.
- The model fills in the journal mechanically without genuine reasoning. "We chose X over Y because X is better" with "revisit if Y becomes better" is ceremony, not documentation. The skill needs examples showing genuine reasoning vs. template-filling.

## The compound interest argument

Every other skill in the suite is per-conversation — it improves the current interaction and then it's done. The decision journal is the only proposed skill that compounds over time. Each entry makes the codebase more legible to future readers (including future Claude sessions). After 50 entries, you have a navigable record of why the system is the way it is. That's a different kind of value than "this debugging session went better."

Whether that compound value justifies the per-entry overhead is the central design question.
