-- see: https://github.com/hrsh7th/nvim-cmp/issues/1017#issuecomment-1141440976
---@diagnostic disable-next-line: deprecated
table.unpack = table.unpack or unpack -- 5.1 compatibility

local utils = require("homekey.utils")

local M = {}

---Moves the cursor to the 0-th column of the first row in the current window.
function M.move_start()
    utils.set_cursor(1, 0)
end

---Moves the cursor to the appropriate column based on current position in the
---current window.
function M.move_home()
    -- check if we can move the cursor
    local value = vim.api.nvim_win_get_cursor(0)
    if value == nil then
        return
    end
    local row, col = table.unpack(value)
    if row <= 0 then
        return
    end

    -- get first column that is not whitespace in the buffer
    local line = vim.api.nvim_get_current_line()
    local matched = line:match("^%s*")
    local idx = matched:len()

    -- toggle between 0 and current index column based on cursor position
    -- note: if the line is all whitespace, the "toggle" column will be off by 1
    --       in normal/visual modes
    if col == idx or (matched == line and col + 1 == idx) then
        idx = 0
    end

    utils.set_cursor(row, idx)
end

---Default keymaps, compatible with lazy.nvim `keys` field in the plugin spec.
---@type table[]
M.default_keymaps = {
    {
        "<Home>",
        M.move_home,
        mode = { "n", "i", "v" },
        desc = "Move the cursor to the beginning of the line, alternating between the start and end of leading whitespace",
        noremap = true,
        silent = true,
    },
    {
        "<C-Home>",
        M.move_start,
        mode = { "n", "i", "v" },
        desc = "Move the cursor to the 0-th column on the first line",
        noremap = true,
        silent = true,
    },
}

M.default_config = {
    set_keymaps = true,
}

---Runs this plugin's setup with the given options. Primarily handles setting up keymaps.
---@param config? table User specified options for this plugin.
function M.setup(config)
    local cfg = vim.tbl_deep_extend("force", config or {}, M.default_config)
    if not cfg.set_keymaps then
        return
    end

    for _, mapping in ipairs(M.default_keymaps) do
        local spec = utils.parse_lazy_keymap(mapping)
        vim.keymap.set(spec.mode or "n", spec.lhs, spec.rhs, spec.opts)
    end
end

return M
