# homekey.nvim

A simple Neovim plugin to make the home key behave like in other popular editors and IDEs.

## Overview

This plugin aims to bring the `<Home>` key in line with how most other editors behave:

- If the cursor is on the first non-whitespace character, move to the 0-th column (e.g., `0`)
- Otherwise, moves the cursor to the first non-whitespace character on the line

This creates a sort of toggle effect when tapping the `<Home>` key.

`<C-Home>` is set to a function that is essentially `gg0`. No particular reason to have a plugin for just this, but figured I would include it since it's the same sort of expected home key behavior from other editors.

## Installation

With [`lazy.nvim`](https://github.com/folke/lazy.nvim)

```lua
{
    "bwpge/homekey.nvim",
    config = true,
    -- or equivalent for default options:
    -- opts = {},
}
```

With [`packer.nvim`](https://github.com/wbthomason/packer.nvim)

```lua
use { "bwpge/homekey.nvim" }
```

## Configuration

This plugin uses the following default configuration:

```lua
{
    -- set keymaps for <Home> and <C-Home> when `require("homekey").setup` is called
    set_keymaps = true,
    -- do not use plugin behavior on these filetypes,
    -- can be exact filetype or lua regular expression
    exclude_filetypes = {
        "neo-tree",
        "NvimTree",
    },
}
```

Which is used when the `setup` function is called without a value (or empty table):

```lua
-- plugin stuff...

require("homekey").setup()
-- or:
-- require("homekey").setup({})
```

`lazy.nvim` users do not need to explicitly call `require("homekey").setup(...)`. This is done automatically by providing `opts = {}` or `config = true`. If you want to provide your own options, populate the `opts` table:

```lua
require("lazy").setup({
    -- other plugins
    {
        "bwpge/homekey.nvim",
        opts = {
            set_keymaps = false,
            exclude_filetypes = { "foo", "bar" },
        },
        -- `config` key not needed since setup will
        -- automatically be called with `opts`
    },
})
```

## Keymaps

The following keymaps are set by default:

- `<Home>`: `require("homekey").move_home()`
    - Modes: `n`, `i`, `v`
    - Description: *Move the cursor to the beginning of the line, alternating between the start and end of leading whitespace*
- `<C-Home>`: `require("homekey").move_begin()`
    - Modes: `n`, `i`, `v`
    - Description: *Move the cursor to the 0-th column on the first line*

### Lazy Keymaps

There shouldn't be any particular need to lazy-load keymaps for this plugin since startup is pretty much instant, but a `default_keymaps` table is provided if you need it. The table is compatible with the `lazy.nvim` keymap spec, so it can be used in a callback:

```lua
require("lazy").setup({
    -- other plugins
    {
        "bwpge/homekey.nvim",
        -- disable keymaps in `setup`
        opts = { set_keymaps = false },
        -- lazy load in plugin spec
        keys = function() return require("homekey").default_keymaps end,
    },
})
```

### Custom Keymaps

Explicit keymap setting (for example, in `lua/user/keymaps.lua` config module):

```lua
-- disable keymaps during setup, e.g., in init.lua
require("lazy").setup({
    -- other plugins
    {
        "bwpge/homekey.nvim",
        -- be sure to set excluded filetypes if different from defaults
        opts = { set_keymaps = false }
    },
})

-- set `<leader>h` to `move_home` in normal mode
vim.keymap.set("n", "<leader>h", require("homekey").move_home)
```

See the [API](#api) section for more information.

## API

The `homekey` module exposes three functions (two of interest):

- `setup(table?)`: the usual plugin setup function
    - Options table does not have to be provided, but setup function must be called to set default keymaps
    - This should only be called once in your plugin initialization
- `move_home()`: moves the cursor in the current window to the 0-th column or the first non-whitespace character on the current column
- `move_start()`: moves the cursor in the current window to the 0-th column on the first row

These can be used anywhere that lua is used (such as a `lua/user/keymaps.lua` module in a keymap function).

Basic usage of the `homekey` module:

```lua
local homekey = require("homekey")
homekey.move_home()
homekey.move_begin()
```

Submodules of `homekey` are not for public use and may change without warning.
