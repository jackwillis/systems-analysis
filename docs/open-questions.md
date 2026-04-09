# Open Questions

## riff: Does recombination produce novelty?

The riff skill's "inspired by picks" step is meant to create crossover between good ideas — options that wouldn't appear in any single generation round. The question is whether this actually happens or whether the model just produces slight variations of the picks.

**How to check:** Next time you run riff, compare the "inspired by" round to the picks that seeded it. If every option in [c] is a minor rewording of something in the selection, the recombination instruction needs sharpening — it should be producing genuine hybrids, not paraphrases. If at least one option in [c] combines elements from two different picks in a way neither pick contained, the step is working.

This is an informal observation, not a formal test. Notice it next time you use the skill.

## disfluent: Does the epistemic pass flag the right things?

The surface pass (strip connectives, break parallel structure) is mechanical and verifiable — either it stripped "Furthermore" or it didn't. The epistemic pass (flag unsupported claims, surface hidden uncertainty, leave gaps for human judgment, mark provenance) requires judgment, and that's where the skill could fail silently.

### Failure modes

1. **Over-flagging.** Every sentence gets a bracket. The model treats all uncertainty as equal — a well-sourced statistic gets the same friction as a baseless causal claim. The reader learns nothing from the friction because it's uniform. The calibration example (Postgres migration) was added to demonstrate restraint, but one example may not be enough to calibrate the model's behavior across diverse inputs.

2. **Under-flagging.** The model flags surface-level uncertainty ("improved" without a metric) but misses deeper epistemic problems (selection bias in the data, survivorship in the sample, an unfalsifiable claim dressed as an empirical one). The expanded trigger list (precision without uncertainty, temporal coincidence as causation, absence of alternatives) targets this, but the triggers are still patterns to match — they don't help the model recognize novel forms of hidden uncertainty.

3. **Performing uncertainty theater.** The model adds hedges and brackets that look like epistemic humility but don't correspond to real uncertainty in the text. "This may reflect..." inserted before a claim that is actually well-supported. The brackets become decoration rather than diagnosis.

### How to test

**Known-answer test:** Write 5 paragraphs where you (the author) know exactly which claims are supported and which aren't. Run them through disfluent. Score: did it flag the right sentences and leave the right ones alone?

**Blind test:** Take a real document you're about to share. Run it through disfluent. Before reading the output, mark which sentences you think are weakest. Compare your marks to the model's flags. Agreement = the epistemic pass is tracking real uncertainty. Disagreement = either you missed something or the model did. Investigate which.

**Adversarial test:** Write a paragraph where the unsupported claim is buried in a subordinate clause inside an otherwise factual sentence. Does the epistemic pass find it, or does the surrounding factual context make the whole sentence look safe?
