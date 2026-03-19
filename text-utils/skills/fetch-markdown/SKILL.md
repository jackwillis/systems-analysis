---
name: fetch-markdown
description: Use when fetching web content for analysis, summarization, or reference — especially when context window efficiency matters. Triggers on "fetch this page", "get the content from", "read this URL", "summarize this article", or when WebFetch would return bloated HTML.
---

# Fetch Markdown

Get clean markdown from a URL. Uses less context than WebFetch by stripping navigation, scripts, and chrome.

## Strategy

Try these in order. Stop at the first one that returns clean content.

All `curl` calls use a browser user agent to avoid bot-blocking:

```bash
UA="Mozilla/5.0 (compatible)"
```

### 1. markdown.new proxy

Returns clean markdown. No dependencies.

```bash
curl -sL -A "$UA" "https://markdown.new/$URL"
```

If it returns an error or is blocked, move to step 2.

### 2. Jina reader proxy

Handles JavaScript rendering, returns clean markdown. No dependencies.

```bash
curl -sL -A "$UA" "https://r.jina.ai/$URL"
```

If it returns an error or is blocked, move to step 3. Between the two proxies, most domains are covered — they tend to fail on different sites.

### 3. trafilatura (best local extraction)

Purpose-built article extractor. Strips nav, ads, and chrome. Returns the article text.

```bash
uvx trafilatura -u "$URL"
```

Or if installed globally: `trafilatura --URL "$URL"`. Install with `pipx install trafilatura`.

### 4. curl + pandoc (local, noisy)

Downloads the full page and converts. Includes navigation, footers, and page chrome — usable but not clean.

```bash
curl -sL -A "$UA" "$URL" | pandoc -f html -t markdown-raw_html-native_divs-native_spans --wrap=none
```

### 5. lynx -dump (plaintext fallback)

Always available on macOS. Gets the article content but loses all markdown formatting (headers, links, emphasis become plain text).

```bash
lynx -dump -nolist "$URL"
```

## When to use which

| Situation | Strategy |
|-----------|----------|
| Blog post, article, documentation | Step 1 (markdown.new) or step 2 (Jina) |
| One proxy blocked or rate-limited | Try the other proxy |
| Both proxies blocked | Step 3 (trafilatura) |
| No Python tools available | Step 4 (curl + pandoc) |
| Nothing else works | Step 5 (lynx) |
| Need exact HTML fidelity | Don't use this skill — use WebFetch |

## Requirements

- `curl` (standard on macOS/Linux)
- `pandoc` (for step 4)
- `trafilatura` (optional, for step 3: `pipx install trafilatura`)
- `lynx` (usually pre-installed on macOS)

## Red Flags

- Proxy returns an error or is blocked for the domain — try the other proxy, then move to local tools
- pandoc output is full of `:::` fenced divs and schema attributes — that's page chrome, not article content. Try trafilatura or lynx instead.
- Content is behind authentication — this skill won't help, use browser tools
- Page is mostly JavaScript-rendered — the proxies handle this; local tools won't
