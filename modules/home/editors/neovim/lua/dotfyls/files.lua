local M = {}

M.home = assert(vim.env.HOME, "No HOME found")

M.config_dir = vim.fs.joinpath(vim.env.XDG_CONFIG_HOME or vim.fs.joinpath(M.home, ".config"))
M.data_dir = vim.fs.joinpath(vim.env.XDG_DATA_HOME or vim.fs.joinpath(M.home, ".local/share"))
M.state_dir = vim.fs.joinpath(vim.env.XDG_STATE_HOME or vim.fs.joinpath(M.home, ".local/state"))

return M
