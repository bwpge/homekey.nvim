local M = {}

---Moves the cursor in the current buffer to the specified position. Positions
---follow Neovim's API with (1, 0)-indexed positions for (row, col).
---
---See `:h nvim_win_set_cursor` for more information.
---@param row number The 1-based row index
---@param col number The 0-based column index
---@private
function M.set_cursor(row, col)
    vim.api.nvim_win_set_cursor(0, { row, col })
end

---Parses a lazy.nvim keymap specification.
---
---See https://github.com/folke/lazy.nvim#%EF%B8%8F-lazy-key-mappings for more information.
---@param spec table
---@return table
---@private
function M.parse_lazy_keymap(spec)
    local result = {
        mode = {},
        lhs = "",
        rhs = "",
        opts = {},
    }
    for k, v in pairs(spec) do
        if k == 1 then
            result.lhs = v
        elseif k == 2 then
            result.rhs = v
        elseif k == "mode" then
            result.mode = v
        else
            result.opts[k] = v
        end
    end

    return result
end

return M
