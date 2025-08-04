local neorg = require "neorg.core"
local modules = neorg.modules

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
  provider_name = "quotable",
}

module.config.private = {
  providers = {
    quotable = {
      url = "http://api.quotable.io/random",
      parse = function(response)
        return response.content, response.author
      end,
    },
    zenquotes = {
      url = "https://zenquotes.io/api/random",
      parse = function(response)
        return response[1].q, response[1].a
      end,
    },
  },
}

module.public = {
  random_quote = function()
    local quote, author = module.private.get_random_quote()

    return module.private.formatting(quote, author, module.config.public.prefix)
  end,
}

module.private = {
  formatting = function(content, author, prefix)
    local wrapped_content =
      modules.get_module("external.neorg-dew").wrap_text(content, module.config.public.limit, prefix)

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
    local provider = module.config.private.providers[module.config.public.provider_name]

    if not provider then
      error("Provider " .. module.config.public.provider_name .. " is unkown!")
    end

    local response = vim.fn.system { "curl", "-s", provider.url }

    if response == "" then
      error("Failed to get response!")
    end

    return provider.parse(vim.fn.json_decode(response))
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
