return {
    "mbbill/undotree",
    cmd = {
        "UndotreeFocus",
        "UndotreeHide",
        "UndotreePersistUndo",
        "UndotreeShow",
        "UndotreeToggle",
    },
    keys = {
        { "<leader>u", vim.cmd.UndotreeToggle, silent = true, desc = "Show undotree (undotree)" },
    },
    config = function() vim.g.undotree_WindowLayout = 2 end,
}
