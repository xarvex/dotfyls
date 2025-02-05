local M = {}

M.group = vim.api.nvim_create_augroup("dotfyls", {})

local foldexpr_skip = {} --[[@type table<number,boolean>]]
local foldexpr_check = assert(vim.uv.new_check())
function M.foldexpr()
    local bufnr = vim.api.nvim_get_current_buf()

    if foldexpr_skip[bufnr] or vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "" then return "0" end

    if pcall(vim.treesitter.get_parser, bufnr) then return vim.treesitter.foldexpr() end

    foldexpr_skip[bufnr] = true
    foldexpr_check:start(function()
        foldexpr_skip = {}
        foldexpr_check:stop()
    end)

    return "0"
end

function M.formatexpr()
    return require("lazy.core.config").plugins["conform.nvim"] and require("conform").formatexpr()
        or vim.lsp.formatexpr({ timeout_ms = 3000 })
end

return M
