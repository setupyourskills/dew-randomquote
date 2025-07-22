local neorg = require "neorg.core"
local modules = neorg.modules
local neorg_dew = require("neorg.core.modules").get_module "external.neorg-dew"

local api = vim.api

local module = modules.create "external.dew-randomquote"

module.setup = function()
  return {
    requires = {
      "core.neorgcmd",
    },
  }
end

module.load = function()
  module.required["core.neorgcmd"].add_commands_from_table {
    dew_randomquote = {
      args = 0,
      name = "dew-randomquote.insert",
    },
  }
end

module.config.public = {
  limit = 100,
  prefix = "",
}

module.public = {
  random_quote = function()
    local quote, author = unpack(module.private.get_random_quote())

    return module.private.formatting(quote, author, module.config.public.prefix)
  end,
}

module.private = {
  formatting = function(content, author, prefix)
    local wrapped_content =
      neorg_dew.wrap_text(content, module.config.public.limit, prefix)

    local lines = {
      prefix .. "   QUOTE",
      prefix,
    }

    for _, line in ipairs(wrapped_content) do
      table.insert(lines, line)
    end

    vim.list_extend(lines, {
      prefix,
      prefix .. "— */" .. author .. "/*",
    })

    return lines
  end,

  get_random_quote = function()
    local apiUrl = "http://api.quotable.io/random"
    local response = vim.fn.system { "curl", "-s", apiUrl }

    if response == "" then
      return nil, "Failed to get response"
    end

    local content = response:match '"content":"(.-)"'
    local author = response:match '"authorSlug":"(.-)"'

    if not content then
      return nil, "No content found"
    end

    return { content, author }
  end,
}

module.on_event = function(event)
  if event.split_type[2] == "dew-randomquote.insert" then
    local lines = module.public.random_quote()
    local row, _ = unpack(api.nvim_win_get_cursor(0))

    api.nvim_buf_set_lines(0, row - 1, row, false, lines)
  end
end

module.events.subscribed = {
  ["core.neorgcmd"] = {
    ["dew-randomquote.insert"] = true,
  },
}

return module
