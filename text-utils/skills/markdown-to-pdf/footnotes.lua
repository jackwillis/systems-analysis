-- footnotes.lua: Convert pandoc footnotes to weasyprint CSS page footnotes.
-- Usage: pandoc --lua-filter=footnotes.lua
-- Only needed for binder format; editing format uses pandoc's default endnotes.

function Note(note)
  local content = pandoc.write(pandoc.Pandoc(note.content), 'html')
  -- Strip wrapping <p> tags for inline placement
  content = content:gsub('^%s*<p>(.-)</p>%s*$', '%1')
  return pandoc.RawInline('html',
    '<span class="footnote">' .. content .. '</span>')
end
