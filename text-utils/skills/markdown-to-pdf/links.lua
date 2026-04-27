-- links.lua: Number inline links and append a reference list at the end.
-- Usage: pandoc --lua-filter=styles/links.lua
--
-- Links with a title attribute render as:
--   1. Title text. URL
-- Links without a title render as:
--   1. URL

local links = {}
local counter = 0

function Link(el)
  counter = counter + 1
  links[counter] = {url = el.target, title = el.title}
  return {
    el,
    pandoc.RawInline('html', '<sup class="link-ref">' .. counter .. '</sup>')
  }
end

function Pandoc(doc)
  if #links == 0 then return doc end

  local ref_blocks = {}
  table.insert(ref_blocks, pandoc.HorizontalRule())
  table.insert(ref_blocks, pandoc.Header(2, "References"))

  local items = {}
  for _, link in ipairs(links) do
    if link.title and link.title ~= "" then
      table.insert(items, {pandoc.Plain({
        pandoc.Str(link.title .. " "),
        pandoc.Link({pandoc.Str(link.url)}, link.url)
      })})
    else
      table.insert(items, {pandoc.Plain({
        pandoc.Link({pandoc.Str(link.url)}, link.url)
      })})
    end
  end
  table.insert(ref_blocks, pandoc.OrderedList(items))

  local ref_div = pandoc.Div(ref_blocks)
  ref_div.attr = pandoc.Attr("", {"references"})
  table.insert(doc.blocks, ref_div)

  return doc
end
