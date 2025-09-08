---@module "lazy"
---@type LazySpec
return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    ---@module "snacks"
    ---@type snacks.Config
    opts = { image = {} },
}
