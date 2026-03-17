---
name: read-pdf
description: Use when extracting text from a PDF file, especially when the built-in PDF reader is insufficient or the PDF is too large. Triggers on "read this PDF", "extract text from PDF", "what does this PDF say", scanned documents, image-heavy PDFs.
---

# Read PDF

Extract text from PDF files. Try the fast path first, fall back to OCR for scanned documents.

## Strategy

### 1. pdftotext (fast, text-based PDFs)

```bash
pdftotext "$INPUT" -
```

Outputs plain text to stdout. Works well for PDFs with embedded text (most digital documents).

For layout-sensitive documents:

```bash
pdftotext -layout "$INPUT" -
```

### 2. OCR fallback (scanned documents)

If pdftotext returns empty or garbage, the PDF is likely scanned images:

```bash
ocrmypdf --skip-text "$INPUT" "$OUTPUT_PDF"
pdftotext "$OUTPUT_PDF" -
```

Or extract images and OCR directly:

```bash
pdftoppm "$INPUT" /tmp/page -png
tesseract /tmp/page-1.png -
```

For multi-page:

```bash
pdftoppm "$INPUT" /tmp/page -png
for f in /tmp/page-*.png; do tesseract "$f" stdout; done
```

### 3. Specific pages

Extract a page range before processing:

```bash
pdftk "$INPUT" cat 5-10 output /tmp/subset.pdf
pdftotext /tmp/subset.pdf -
```

Or with qpdf:

```bash
qpdf "$INPUT" --pages . 5-10 -- /tmp/subset.pdf
pdftotext /tmp/subset.pdf -
```

## When to use which

| Situation | Strategy |
|-----------|----------|
| Normal PDF, digital text | pdftotext |
| Scanned document, forms | OCR (ocrmypdf or tesseract) |
| Large PDF, only need some pages | Extract pages first, then pdftotext |
| PDF with complex tables | pdftotext -layout, or consider tabula-java |

## How to tell if OCR is needed

```bash
pdftotext "$INPUT" - | wc -w
```

If the word count is near zero for a multi-page document, it's scanned.

## Requirements

- `pdftotext` (from poppler: `brew install poppler`)
- `tesseract` (for OCR: `brew install tesseract`)
- `ocrmypdf` (optional, wraps tesseract: `pip install ocrmypdf`)

## Red Flags

- PDF is encrypted or password-protected — decrypt first with `qpdf --decrypt`
- Output is garbled unicode — PDF may use custom fonts without proper encoding. Try OCR instead.
- Tables come out as jumbled text — pdftotext doesn't understand table structure. Use `-layout` or a dedicated table extractor.
