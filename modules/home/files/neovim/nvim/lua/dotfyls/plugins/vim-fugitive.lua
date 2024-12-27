-- TODO: reconfigure
return {
    "tpope/vim-fugitive",
    cmd = "Git",
    keys = {
        { "<leader>gs", vim.cmd.Git },
    },
}
