-- TODO: reconfigure and split
return {
    "folke/zen-mode.nvim",
    dependencies = {
        {
            "folke/twilight.nvim",
            cmd = {
                "Twilight",
                "TwilightDisable",
                "TwilightEnable",
            },
            opts = {
                dimming = { inactive = true },
                context = 10,
                expand = {
                    "function",
                    "function_definition",
                    "method",
                    "table",
                },
            },
        },
    },
    cmd = "ZenMode",
    keys = {
        {
            "<leader>zz",
            function()
                require("zen-mode").toggle()
                vim.wo.wrap = false
            end,
        },
    },
    opts = {
        window = {
            options = { number = true, relativenumber = true },
        },
    },
}
