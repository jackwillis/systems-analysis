# Open Questions

## riff: Does recombination produce novelty?

The riff skill's "inspired by picks" step is meant to create crossover between good ideas — options that wouldn't appear in any single generation round. The question is whether this actually happens or whether the model just produces slight variations of the picks.

**How to check:** Next time you run riff, compare the "inspired by" round to the picks that seeded it. If every option in [c] is a minor rewording of something in the selection, the recombination instruction needs sharpening — it should be producing genuine hybrids, not paraphrases. If at least one option in [c] combines elements from two different picks in a way neither pick contained, the step is working.

This is an informal observation, not a formal test. Notice it next time you use the skill.

## disfluent: Does the epistemic pass flag the right things?

The surface pass (strip connectives, break parallel structure) is mechanical and verifiable — either it stripped "Furthermore" or it didn't. The epistemic pass (flag unsupported claims, surface hidden uncertainty, leave gaps for human judgment, mark provenance) requires judgment, and that's where the skill could fail silently.

### What the source paper actually found

Shaw & Nave (2026) ran three preregistered CRT-based studies. The key findings that bear on this skill:

1. **Confidence inflation.** Participants' self-reported confidence *increased* after engaging with AI output, even when they knew the AI was wrong. This suggests the cost of under-flagging is higher than the cost of over-flagging — unflagged text actively inflates the reader's confidence in claims they haven't evaluated.

2. **Item-level feedback shifts behavior.** When participants received specific, per-item feedback (not just a general warning), they shifted from cognitive surrender (uncritical acceptance) to cognitive offloading (strategic delegation). This validates the bracket-annotation design in draft mode — specific flags like `[causal claim — was it X or something else?]` should prompt engagement, while generic flags like `[this might be wrong]` won't.

3. **Need for Cognition as moderator.** Low-NFC individuals are more vulnerable to surrender. Share mode (text going to others who may have low NFC) should err toward more friction, not less. Draft mode (self-review by the author, presumably higher NFC) can be more selective.

**Ecological validity caveat:** The studies used CRT quiz questions, not realistic work artifacts. Whether the findings transfer to developers reading post-mortems or managers reading status updates is an open question. The mechanism (fluency → confidence → surrender) is plausible but unconfirmed in professional contexts.

### Failure modes

1. **Over-flagging.** Every sentence gets a bracket. The model treats all uncertainty as equal — a well-sourced statistic gets the same friction as a baseless causal claim. The reader learns nothing from the friction because it's uniform. The calibration example (Postgres migration) was added to demonstrate restraint, but one example may not be enough to calibrate the model's behavior across diverse inputs. *However:* the confidence-inflation finding suggests over-flagging may be less harmful than under-flagging. An over-flagged document prompts the reader to evaluate each flag. An under-flagged document inflates confidence in the unflagged claims.

2. **Under-flagging.** The model flags surface-level uncertainty ("improved" without a metric) but misses deeper epistemic problems (selection bias in the data, survivorship in the sample, an unfalsifiable claim dressed as an empirical one). The expanded trigger list (precision without uncertainty, temporal coincidence as causation, absence of alternatives) targets this, but the triggers are still patterns to match — they don't help the model recognize novel forms of hidden uncertainty.

3. **Performing uncertainty theater.** The model adds hedges and brackets that look like epistemic humility but don't correspond to real uncertainty in the text. "This may reflect..." inserted before a claim that is actually well-supported. The brackets become decoration rather than diagnosis. The paper's finding on item-level feedback suggests the fix: flags must be *specific* (name the epistemic issue) rather than *generic* (express vague doubt). The specificity metric in the eval captures this.

### How to test

**Known-answer test:** Write 5 paragraphs where you (the author) know exactly which claims are supported and which aren't. Run them through disfluent. Score: did it flag the right sentences and leave the right ones alone?

**Blind test:** Take a real document you're about to share. Run it through disfluent. Before reading the output, mark which sentences you think are weakest. Compare your marks to the model's flags. Agreement = the epistemic pass is tracking real uncertainty. Disagreement = either you missed something or the model did. Investigate which.

**Adversarial test:** Write a paragraph where the unsupported claim is buried in a subordinate clause inside an otherwise factual sentence. Does the epistemic pass find it, or does the surrounding factual context make the whole sentence look safe?
