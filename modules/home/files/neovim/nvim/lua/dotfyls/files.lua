local M = {}

M.lsp_directory = vim.fs.joinpath(vim.env.XDG_CONFIG_DIR or vim.fs.joinpath(assert(vim.env.HOME), ".config"), "dotfyls", "lsp")

---@param filename string
---@param extension boolean?
---@return table?
function M.lsp_config(filename, extension)
    local ok_read, contents = pcall(vim.fn.readblob, vim.fs.joinpath(M.lsp_directory, filename .. (extension and ".json" or "")))
    if ok_read then
        local ok_decode, opts = pcall(vim.json.decode, contents, { luanil = { object = true, array = true } })
        return ok_decode and opts or nil
    end
end

return M
