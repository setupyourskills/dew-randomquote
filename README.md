# Dew Random Quote

🌿 **neorg-dew-crumb** is a minimal, focused [Neorg](https://github.com/nvim-neorg/neorg) extension designed to insert beautifully formatted, randomly fetched quotes into your notes.

This module is part of the [neorg-dew](https://github.com/setupyourskills/neorg-dew) ecosystem.

## Features

- Fetches a random quote from the `quotable.io` API.

- Wraps and formats the quote with optional prefixes.

- Inserts the quote directly at the cursor position in your `.norg` buffer.

- Lightweight and easily customizable.

## Installation

### Prerequisites

- A functional installation of [Neorg](https://github.com/nvim-neorg/neorg) is required for this module to work.
- The core module [Neorg-dew](https://github.com/setupyourskills/neorg-dew) must be installed, as it provides essential base libraries.

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
    },
},
```

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

## Collaboration and Compatibility

This project embraces collaboration and may build on external modules created by other Neorg members, which will be tested regularly to ensure they remain **functional** and **compatible** with the latest versions of Neorg and Neovim.  

## Why **dew**?

Like morning dew, it’s **subtle**, **natural**, and brief, yet vital and effective for any workflow.
