# Dew Random Quote

🌿 **Dew Random Quote** is a minimal, focused [Neorg](https://github.com/nvim-neorg/neorg) extension designed to insert beautifully formatted, randomly fetched quotes into your notes.

This module is part of the [Neorg Dew](https://github.com/setupyourskills/neorg-dew) ecosystem.

## Features

- Fetches a random quote from the `quotable.io` API.

- Wraps and formats the quote with optional prefixes.

- Inserts the quote directly at the cursor position in your `.norg` buffer.

- Lightweight and easily customizable.

## Installation

### Prerequisites

- A functional installation of [Neorg](https://github.com/nvim-neorg/neorg) is required for this module to work.
- The core module [Neorg Dew](https://github.com/setupyourskills/neorg-dew) must be installed, as it provides essential base libraries.

### Using Lazy.nvim

```lua
{
  "setupyourskills/dew-randomquote",
  ft = "norg",
  dependencies = {
    "setupyourskills/neorg-dew",
  },
}
```

## Configuration

Make sure all of them are loaded through Neorg’s module system in your config:

```lua
["external.neorg-dew"] = {},
["external.dew-randomquote"] = {
    config = {
        limit = 100, -- Line length limit for wrapping the quote text
        prefix = ">> ", -- Optionnal prefix added to each line of the inserted quote
        provider_name = "quotable", -- Name of the quote provider 
    },
},
```

### Available Quote Providers

You can specify the quote provider you'd like to use in your configuration.

Use the corresponding name from the list below:

| Provider Name (`config`)   | API Used     |
|--------------------------|--------------|
| `quotable`                 | [quotable.io](https://quotable.io)  |
| `zenquotes`                | [zenquotes.io](https://zenquotes.io) |

## Usage

Run the following Neorg command to insert a quote at the current cursor location:

```
:Neorg dew_randomquote
```

You can also call the exposed public function:

```lua
require("neorg.core.modules").get_module("external.dew-randomquote").randomquote()
```

This returns a table of formatted strings that you can insert manually insert wherever you want.

## How it works

This module will:

- Call the `http://api.quotable.io/random` endpoint to retrieve a random quote.

- Split the result into multiple lines (wrapped to 100 characters by default)

- Prepend each line with the configured prefix.

- Insert the formatted quote into the buffer at the current cursor position.

## Bonus Feature: Using Random Quotes with Neorg Templates

You can integrate `dew-randomquote` with ['neorg-template'](https://github.com/nvim-neorg/neorg/wiki/Templates) to automatically insert a random quote using a custom keyword in your templates.

### Configuration Example

Add the following to your Neorg module configuration to define a custom `QUOTE` keyword that inserts a random quote:

```lua
["external.templates"] = {
    config = {
        keywords = {
            QUOTE = function()
                local lines = require("neorg.core.modules")
                    .get_module("external.dew-randomquote")
                    .random_quote()

                return require "luasnip".text_node(lines)
            end,
        },
    },
},
```

- This defines a `QUOTE` keyword usable in your templates.

- When triggered, it inserts a quote from the currently selected provider (`quotable`, `zenquotes`, etc.).

- `require "luasnip".text_node(lines)` requires ['LuaSnip'](https://github.com/L3MON4D3/LuaSnip), which is already used internally by `neorg-template`.
Make sure it's installed in your Neovim configuration:

```lua
{ "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" } },
```

### Example Template

Once the `QUOTE` keyword is configured, you can create a Neorg template like this:

```norg
* Journal Entry for {TODAY}

> {QUOTE}

---

Today I learned...
```

You can change the keyword name `QUOTE` to anything you like, or define multiple keywords for different use cases.

## Collaboration and Compatibility

This project embraces collaboration and may build on external modules created by other Neorg members, which will be tested regularly to ensure they remain **functional** and **compatible** with the latest versions of Neorg and Neovim.  

## Why **dew**?

Like morning dew, it’s **subtle**, **natural**, and brief, yet vital and effective for any workflow.
