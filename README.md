# Claude Code Plugins for Systems Thinking

**Three plugins that change how Claude Code reasons about your code.**

> **Experimental.** Under active development. Expect rough edges.

AI coding agents are biased toward action. They guess before they model, add rules when rules can't keep up, and treat correlation as causation. These plugins add structured reasoning at the points where rushing costs the most.

### What changes

You tell Claude a test passes locally but fails 30% of the time in CI. Without these plugins, it guesses "race condition" and starts adding sleeps.

With them, Claude states two competing models (missing `ORDER BY` vs. race condition), picks the cheapest distinguishing test (check CI config for a parallel runner), confirms, fixes, and verifies. It writes down what it thinks before it touches anything.

## Skills

### Systems Analysis

Analysis frameworks for modeling, causation, and control. Install:

```
/plugin install systems-analysis@jackwillis
```

| Skill | Command | Auto-triggers on |
|-------|---------|-----------------|
| [Debug with a model](docs/representing-and-intervening.md) | `/representing-and-intervening` | "why is this happening", unexplained behavior |
| [Check your controls](docs/requisite-variety.md) | `/requisite-variety` | regulation failure, alert fatigue |
| [Verify causal claims](docs/causal-analysis.md) | `/causal-analysis` | "does X cause Y", observational data |
| [Staleness check](docs/staleness-check.md) | `/staleness-check` | acting on information read earlier, user signals changes |

### Break Things

Failure-mode-first test design. Install:

```
/plugin install break-things@jackwillis
```

| Skill | Command | Auto-triggers on |
|-------|---------|-----------------|
| [What to test](docs/what-to-test.md) | `/what-to-test` | "what tests do I need?", writing code that needs guards |
| [Is it tested](docs/is-it-tested.md) | `/is-it-tested` | "is this well-tested?", tests pass but production breaks |

### Text Utils

Text extraction, conversion, and generation. Install:

```
/plugin install text-utils@jackwillis
```

| Skill | Command | Auto-triggers on |
|-------|---------|-----------------|
| [Disfluent](docs/disfluent.md) | `/disfluent` | "add friction", "make this rougher", reviewing AI text |
| [Riff](docs/riff.md) | `/riff` | Invoke explicitly |
| Fetch markdown | `/fetch-markdown` | Fetching web content |
| Markdown to PDF | `/markdown-to-pdf` | "make a PDF", "export as PDF" |
| PDF to text | `/pdf-to-text` | "read this PDF", scanned documents |

### Marketplace

All three plugins are in the same marketplace:

```
/plugin marketplace add https://github.com/jackwillis/claude-plugins.git
```

Restart Claude Code after installing to load new skills.

### Requirements (text-utils)

```bash
# macOS
brew install pandoc weasyprint poppler qpdf   # core
brew install tesseract                         # optional: OCR
pipx install trafilatura                       # optional: article extraction

# Debian/Ubuntu
sudo apt install pandoc weasyprint poppler-utils qpdf
sudo apt install tesseract-ocr                 # optional: OCR
pipx install trafilatura                       # optional: article extraction
```

> **Pairs well with [Superpowers](https://github.com/obra/superpowers)** — these plugins focus on *when to stop and think*. Superpowers handles planning and execution with review checkpoints. They complement each other.

## License

[MIT](LICENSE)
