---@module "lazy"
---@type LazySpec
-- TODO: Reconfigure.
return {
    "tpope/vim-fugitive",
    cmd = "Git",
    keys = {
        { "<leader>gs", vim.cmd.Git },
    },
}
