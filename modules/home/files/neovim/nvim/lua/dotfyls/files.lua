local M = {}

M.home = assert(vim.env.HOME, "No HOME found")

M.config_dir = vim.fs.joinpath(vim.env.XDG_CONFIG_HOME or vim.fs.joinpath(M.home, ".config"))
M.data_dir = vim.fs.joinpath(vim.env.XDG_DATA_HOME or vim.fs.joinpath(M.home, ".local/share"))
M.state_dir = vim.fs.joinpath(vim.env.XDG_STATE_HOME or vim.fs.joinpath(M.home, ".local/state"))

M.lsp_directory = vim.fs.joinpath(M.config_dir, "dotfyls", "lsp")

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
