---@module "lazy"
---@type LazySpec
-- TODO: Reconfigure.
return {
    {
        "zaldih/themery.nvim",
        lazy = false,
        priority = 1000,
        cmd = "Themery",
        event = "VimEnter",
        keys = {
            { "<C-A-t>", vim.cmd.Themery },
        },
        opts = {
        -- stylua: ignore
        themes = {
            "duskfox", "carbonfox",
            "oxocarbon",
            "rose-pine",
            "tokyonight",
        },
        },
    },
    {
        "EdenEast/nightfox.nvim",
        lazy = true,
        opts = { options = { transparent = true } },
    },
    {
        "folke/tokyonight.nvim",
        lazy = true,
        opts = {
            style = "night",
            transparent = true,
            terminal_colors = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
            hide_inactive_statusline = false,
            dim_inactive = false,
            lualine_bold = false,
        },
    },
    {
        "nyoom-engineering/oxocarbon.nvim",
        lazy = true,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = true,
        opts = {
            variant = "main",
            dark_variant = "main",
            disable_background = true,
            disable_float_background = true,
            styles = { transparent = true },
        },
    },
}
