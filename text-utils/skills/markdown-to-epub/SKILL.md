---
name: markdown-to-epub
description: Use when the user wants to render markdown as an EPUB, create an ebook, or generate a reflowable book file for e-readers. Triggers on "make an epub", "export as epub", "ebook version", "send to Kindle".
---

# Markdown to EPUB

Render markdown to EPUB3 using pandoc's native writer.

## Pipeline

```bash
pandoc "$INPUT" -o "$OUTPUT.epub" --css="$(dirname "$0")/epub.css"
```

That's the whole thing. Pandoc handles packaging, navigation, and the manifest.

## Metadata

EPUB readers expect title and author. If the markdown has a YAML header, pandoc uses it. Otherwise pass flags:

```bash
pandoc input.md -o book.epub \
  --metadata title="The Title" \
  --metadata author="Author Name" \
  --metadata lang=en
```

## Cover image

```bash
pandoc input.md -o book.epub --epub-cover-image=cover.jpg
```

Cover should be JPG or PNG, roughly 1600×2400, under 1 MB.

## Chapter splitting

By default pandoc splits at top-level headings (`#`). Override:

```bash
--split-level=2   # split at ## instead
```

For multi-file input, concatenate first — pandoc reads one logical document:

```bash
pandoc ch01.md ch02.md ch03.md -o book.epub
```

## Options

| Need | Flag |
|------|------|
| Table of contents | `--toc` (readers usually generate their own from nav) |
| Numbered sections | `--number-sections` |
| Embed fonts | `--epub-embed-font=path/to/font.ttf` |
| Different stylesheet | `--css=your.css` |

## Requirements

- `pandoc`

**macOS:** `brew install pandoc`

**Debian/Ubuntu:** `sudo apt install pandoc`

## Red Flags

- **Complex layout** — EPUB reflows. Multi-column, precise positioning, floating figures will not survive. If layout matters, use markdown-to-pdf.
- **Code-heavy content** — many e-readers render code blocks poorly (wrapping, tiny monospace). Preview on the target device.
- **Large images** — readers choke on images over ~2 MB. Resize before embedding.
- **User wants .mobi / Kindle format** — Amazon accepts EPUB via Send to Kindle now. Only reach for `kindlegen` or Calibre if the target is an old Kindle.
- **User wants print output** — use markdown-to-pdf instead.
