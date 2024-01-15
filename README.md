# homekey.nvim

A simple plugin to make the home key behave as in other popular editors and IDEs.

## Installation

See the [Configuration](#configuration) section for setup details.

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
}
```

Which is used when the `setup` function is called:

```lua
-- plugin stuff...

require("homekey").setup()
-- or:
-- require("homekey").setup({})
```

`lazy.nvim` users do not need to explicitly call `require("homekey").setup(...)`. This is done automatically by providing `opts = {}` or `config = true`. If you want to provide your own options, simply populate the `opts` table:

```lua
require("lazy").setup({
    -- other plugins
    {
        "bwpge/homekey.nvim",
        opts = { set_keymaps = false },
        -- `config` key not needed since it will
        -- automatically be called with `opts`
    },
})
```

## Keymaps

The following keymaps are set by default when `setup` is called:

- `<Home>`: `homekey.move_home()`
    - Modes: `n`, `i`, `v`
    - Description: *Move the cursor to the beginning of the line, alternating between the start and end of leading whitespace*
- `<C-Home>`: `homekey.move_begin()`
    - Modes: `n`, `i`, `v`
    - Description: *Move the cursor to the 0-th column on the first line*

### Lazy Keymaps

Requires `lazy.nvim`:

```lua
require("lazy").setup({
    -- other plugins
    {
        "bwpge/homekey.nvim",
        -- disable keymaps in `setup`
        opts = { set_keymaps = false },
        -- lazy load in plugin spec
        keys = function() return require("homekey").default_keymaps end
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
        "bwpge/homekey.nvim"
        -- if opts and config are not set, setup won't be called
        -- and no keymaps will be set. you can also use:
        -- opts = { set_keymaps = false }
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
