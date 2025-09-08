---@module "lazy"
---@type LazySpec
-- TODO: Reconfigure.
return {
    {
        "m4xshen/hardtime.nvim",
        cmd = "Hardtime",
        event = { "BufNewFile", "BufReadPost" },
        opts = {
            max_count = 5,
            disable_mouse = false,
            disabled_keys = {
                ["<Up>"] = { "i", "v", "x" },
                ["<Down>"] = { "i", "v", "x" },
                ["<Left>"] = { "i", "v", "x" },
                ["<Right>"] = { "i", "v", "x" },
            },
        },
    },
    { "MunifTanjim/nui.nvim", lazy = true },
}
