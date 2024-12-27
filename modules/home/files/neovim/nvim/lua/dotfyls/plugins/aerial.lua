return {
    {
        "stevearc/aerial.nvim",
        cmd = {
            "AerialGo",
            "AerialInfo",
            "AerialNavOpen",
            "AerialNavToggle",
            "AerialNext",
            "AerialOpen",
            "AerialOpenAll",
            "AerialPrev",
            "AerialToggle",
        },
        keys = {
            { "<leader>cs", vim.cmd.AerialToggle, silent = true, desc = "Symbols (Aerial)" },
            { "{", vim.cmd.AerialPrev, silent = true, desc = "Previous symbol (Aerial)" },
            { "}", vim.cmd.AerialNext, silent = true, desc = "Next symbol (Aerial)" },
        },
        opts = {
            backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
            layout = {
                win_opts = {
                    winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
                    signcolumn = "yes",
                    statuscolumn = " ",
                },
            },
            guides = {
                mid_item = "├╴",
                last_item = "└╴",
            },
            lsp = { diagnostics_trigger_update = true },
        },
    },
    { "nvim-tree/nvim-web-devicons", lazy = true },
}
