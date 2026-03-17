---
name: markdown-to-pdf
description: Use when the user wants to render markdown as a PDF, create a printable document, or generate a styled PDF from text. Triggers on "make a PDF", "render this to PDF", "printable version", "export as PDF".
---

# Markdown to PDF

Render markdown to styled PDF using pandoc + weasyprint + CSS.

## Pipeline

```bash
pandoc "$INPUT" -t html --standalone --css="$THEME" | weasyprint - "$OUTPUT"
```

## Themes

Three CSS themes ship in this skill's directory. Read them for the full font stacks and styling.

- **`default.css`** — Charter body, Fira Sans headings, ~75 character measure
- **`editing.css`** — same as default, double-spaced for review
- **`correspondence.css`** — PT Serif/PT Sans, 11pt, black-on-white, faxable

All themes use cross-platform font stacks (macOS, Windows, Linux, Android, iOS) with page numbers.

To customize: read a theme file, make the requested changes, and write it back or to a new file.

## Options

| Need | Flag |
|------|------|
| Table of contents | `--toc` |
| Numbered sections | `--number-sections` |
| Custom title/author | `--metadata title="..." --metadata author="..."` |

## Requirements

- `pandoc`
- `weasyprint` (`brew install weasyprint` or `pip install weasyprint`)

## Red Flags

- User needs .docx — use `pandoc -o output.docx` instead, skip weasyprint
- Complex layouts (multi-column, floating figures) — weasyprint has limits
