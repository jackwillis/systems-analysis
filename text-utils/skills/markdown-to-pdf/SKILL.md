---
name: markdown-to-pdf
description: Use when the user wants to render markdown as a PDF, create a printable document, or generate a styled PDF from text. Triggers on "make a PDF", "render this to PDF", "printable version", "export as PDF".
---

# Markdown to PDF

Render markdown to styled PDF using pandoc + weasyprint + CSS.

## Pipeline

```bash
pandoc "$INPUT" -t html --standalone --css="$THEME" -o "$TMPHTML"
weasyprint "$TMPHTML" "$OUTPUT"
```

Or in one step:

```bash
pandoc "$INPUT" -t html --standalone --css="$THEME" | weasyprint - "$OUTPUT"
```

## Themes

Use a CSS file to control styling. If the user doesn't specify a theme, use a clean default.

### Default theme

```css
body {
  font-family: -apple-system, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
  max-width: 42em;
  margin: 2em auto;
  padding: 0 1em;
  line-height: 1.6;
  color: #1a1a1a;
  font-size: 12pt;
}

h1, h2, h3 { margin-top: 1.4em; }
h1 { font-size: 1.8em; border-bottom: 1px solid #ddd; padding-bottom: 0.3em; }
h2 { font-size: 1.4em; }
h3 { font-size: 1.1em; }

code { background: #f4f4f4; padding: 0.2em 0.4em; border-radius: 3px; font-size: 0.9em; }
pre code { display: block; padding: 1em; overflow-x: auto; }

blockquote {
  border-left: 3px solid #ccc;
  margin-left: 0;
  padding-left: 1em;
  color: #555;
}

table { border-collapse: collapse; width: 100%; margin: 1em 0; }
th, td { border: 1px solid #ddd; padding: 0.5em; text-align: left; }
th { background: #f4f4f4; }

@page { margin: 2cm; }
```

### Double-spaced (editing/review)

Add to the default:

```css
body { line-height: 2.0; }
```

### If the user provides their own CSS

Use it directly — don't merge with the default.

## Options

| Need | Flag |
|------|------|
| Table of contents | `--toc` |
| Numbered sections | `--number-sections` |
| Custom title/author | `--metadata title="..." --metadata author="..."` |
| Page numbers | Add to CSS: `@bottom-center { content: counter(page); }` |

## Requirements

- `pandoc`
- `weasyprint` (install via `pip install weasyprint` or `brew install weasyprint`)

## Red Flags

- User wants WYSIWYG editing — this is a one-way render, not an editor
- Complex layouts (multi-column, floating figures) — weasyprint supports CSS but has limits
- User needs .docx — use `pandoc -o output.docx` instead, skip weasyprint entirely
