-- TODO: reconfigure
return {
    {
        "m4xshen/hardtime.nvim",
        event = "VeryLazy",
        opts = {
            max_count = 5,
            disabled_keys = {
                ["<Up>"] = { "i", "v", "x" },
                ["<Down>"] = { "i", "v", "x" },
                ["<Left>"] = { "i", "v", "x" },
                ["<Right>"] = { "i", "v", "x" },
            },
        },
    },
    { "MunifTanjim/nui.nvim", lazy = true },
    { "nvim-lua/plenary.nvim", lazy = true },
}
