---
name: pdf-to-text
description: Use when extracting text from a PDF file, especially when the built-in PDF reader is insufficient or the PDF is too large. Triggers on "read this PDF", "extract text from PDF", "what does this PDF say", scanned documents, image-heavy PDFs.
---

# PDF to Text

Extract text from PDF files. Try the fast path first, fall back to OCR for scanned documents.

## Strategy

### 1. pdftotext (fast, text-based PDFs)

```bash
pdftotext "$INPUT" -
```

For layout-sensitive documents (tables, columns):

```bash
pdftotext -layout "$INPUT" -
```

### 2. OCR fallback (scanned documents)

If pdftotext returns empty or garbage, the PDF is scanned images. Use ocrmypdf to add a text layer, then extract:

```bash
OCR_OUT=$(mktemp /tmp/ocr-XXXXXX.pdf)
ocrmypdf --skip-text "$INPUT" "$OCR_OUT"
pdftotext "$OCR_OUT" -
rm "$OCR_OUT"
```

Or OCR individual pages directly:

```bash
PAGE_DIR=$(mktemp -d /tmp/pages-XXXXXX)
pdftoppm "$INPUT" "$PAGE_DIR/page" -png
for f in "$PAGE_DIR"/page-*.png; do tesseract "$f" stdout; done
rm -r "$PAGE_DIR"
```

### 3. Specific pages

Extract a page range before processing:

```bash
SUBSET=$(mktemp /tmp/subset-XXXXXX.pdf)
qpdf "$INPUT" --pages . 5-10 -- "$SUBSET"
pdftotext "$SUBSET" -
rm "$SUBSET"
```

### How to tell if OCR is needed

```bash
pdftotext "$INPUT" - | wc -w
```

If the word count is near zero for a multi-page document, it's scanned.

## When to use which

| Situation | Strategy |
|-----------|----------|
| Normal PDF, digital text | pdftotext |
| Scanned document, forms | OCR (ocrmypdf or tesseract) |
| Large PDF, only need some pages | Extract pages first with qpdf |
| PDF with complex tables | pdftotext -layout, or tabula-java |

## Requirements

- `pdftotext` (from poppler)
- `tesseract` (for OCR)
- `ocrmypdf` (optional, wraps tesseract)
- `qpdf` (for page extraction)

**macOS:** `brew install poppler tesseract qpdf` and optionally `pipx install ocrmypdf`

**Debian/Ubuntu:** `sudo apt install poppler-utils tesseract-ocr qpdf` and optionally `pipx install ocrmypdf`

## Red Flags

- PDF is encrypted or password-protected — decrypt first with `qpdf --decrypt`
- Output is garbled unicode — PDF uses custom fonts without encoding. Try OCR instead.
- Tables come out jumbled — pdftotext doesn't understand table structure. Use `-layout` or a dedicated table extractor.
