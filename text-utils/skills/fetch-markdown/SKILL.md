---
name: fetch-markdown
description: Use when fetching web content for analysis, summarization, or reference — especially when context window efficiency matters. Triggers on "fetch this page", "get the content from", "read this URL", "summarize this article", or when WebFetch would return bloated HTML.
---

# Fetch Markdown

Get clean markdown from a URL. Uses less context than WebFetch by stripping navigation, scripts, and chrome.

## Strategy

Try these in order. Stop at the first one that returns clean content.

### 1. Jina reader proxy (best quality)

Handles JavaScript rendering, returns clean markdown. No dependencies.

```bash
curl -sL "https://r.jina.ai/$URL"
```

May be blocked for some domains. If it returns an error, move to step 2.

### 2. trafilatura (best local extraction)

Purpose-built article extractor. Strips nav, ads, and chrome. Returns the article text.

```bash
uvx trafilatura -u "$URL"
```

Or if installed globally: `trafilatura --URL "$URL"`. Install with `pipx install trafilatura`.

### 3. curl + pandoc (local, noisy)

Downloads the full page and converts. Includes navigation, footers, and page chrome — usable but not clean.

```bash
curl -sL "$URL" | pandoc -f html -t markdown-raw_html-native_divs-native_spans --wrap=none
```

### 4. lynx -dump (plaintext fallback)

Always available on macOS. Gets the article content but loses all markdown formatting (headers, links, emphasis become plain text).

```bash
lynx -dump -nolist "$URL"
```

## When to use which

| Situation | Strategy |
|-----------|----------|
| Blog post, article, documentation | Step 1 (Jina proxy) |
| Proxy blocked or rate-limited | Step 2 (trafilatura) |
| No Python tools available | Step 3 (curl + pandoc) |
| Nothing else works | Step 4 (lynx) |
| Need exact HTML fidelity | Don't use this skill — use WebFetch |

## Requirements

- `curl` (standard on macOS/Linux)
- `pandoc` (for step 3)
- `trafilatura` (optional, for step 2: `pipx install trafilatura`)
- `lynx` (usually pre-installed on macOS)

## Red Flags

- Proxy returns an error or is blocked for the domain — move to next strategy
- pandoc output is full of `:::` fenced divs and schema attributes — that's page chrome, not article content. Try trafilatura or lynx instead.
- Content is behind authentication — this skill won't help, use browser tools
- Page is mostly JavaScript-rendered — Jina proxy handles this; local tools won't
