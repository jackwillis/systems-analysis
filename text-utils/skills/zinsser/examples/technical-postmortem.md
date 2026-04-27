# Example: Incident Report Paragraph

## Input

The deployment was completed successfully, but it should be noted that a number of services were affected. The team made a decision to roll back the change after errors were reported. The migration was largely stable, with one region experiencing elevated latency. Mistakes were made in the rollout sequence, and the monitoring system failed to provide timely assistance.

---

## Expected Output

### Pass 1 — Surface

Before:
The deployment was completed successfully, but it should be noted that a number of services were affected. The team made a decision to roll back the change after errors were reported. The migration was largely stable, with one region experiencing elevated latency. Mistakes were made in the rollout sequence, and the monitoring system failed to provide timely assistance.

After:
The deployment completed successfully, but a number of services were affected. The team decided to roll back the change after errors were reported. The migration was largely stable, with one region experiencing elevated latency. Mistakes were made in the rollout sequence, and the monitoring system failed to help.

Cut: "was completed" → "completed" (passive→active, subject known), "it should be noted that" (hollow connective), "made a decision to" → "decided" (nominalization), "provide timely assistance" → "help" (nominalization)

Left alone: "largely stable" — exception is stated in the same sentence ("with one region experiencing elevated latency"), so "largely" is doing real work and stays.

---

### Pass 2 — Voice

Before:
The deployment completed successfully, but a number of services were affected. The team decided to roll back the change after errors were reported. The migration was largely stable, with one region experiencing elevated latency. Mistakes were made in the rollout sequence, and the monitoring system failed to help.

After:
The deployment completed successfully, but a number of services were affected. The team decided to roll back the change after errors were reported. The migration was largely stable, with one region experiencing elevated latency. [Who made mistakes in the rollout sequence? Subject unknown — flag for writer.] The monitoring system failed to help.

Rewrote: "a number of services were affected" → left alone (no count inferrable from context); "errors were reported" → left alone (reporter unknown); "Mistakes were made" → flagged, not rewritten (no active subject inferrable)

Note: "largely stable" was already left alone in Pass 1 for the right reason — it stays here too.

---

Final:
The deployment completed successfully, but a number of services were affected. The team decided to roll back the change after errors were reported. The migration was largely stable, with one region experiencing elevated latency. [Who made mistakes in the rollout sequence? Subject unknown — flag for writer.] The monitoring system failed to help.

---

## What This Example Demonstrates

- **Qualifiers that earn their keep** — "largely" was not cut because an exception appears in the same sentence. The rule is: cut `largely` only when no exception is stated; otherwise it's doing real work.
- **Passive with unknown subject** — "Mistakes were made" gets a flag, not a rewrite. The skill doesn't invent an active subject.
- **Passive with known subject** — "The deployment was completed" → "The deployment completed" is fine because the subject (the deployment / the team) is inferrable.
- **Vague noun left alone** — "a number of services" stays because no count is inferrable from context. Don't invent specifics.
