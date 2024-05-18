-- I should look into making this part of my plugin
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LazyLoad", {}),
    callback = function()
        local keymap = require("shortcut").keymap

        keymap("n", "{", vim.cmd.AerialPrev, { buffer = 0 })
        keymap("n", "}", vim.cmd.AerialNext, { buffer = 0 })
    end
})

return {
    "stevearc/aerial.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    cmd = {
        "AerialGo",
        "AerialInfo",
        "AerialNavOpen",
        "AerialNavToggle",
        "AerialNext",
        "AerialOpen",
        "AerialOpenAll",
        "AerialPrev",
        "AerialToggle"
    },
    keys = { { "<leader>o", vim.cmd.AerialToggle } },
    config = true
}
