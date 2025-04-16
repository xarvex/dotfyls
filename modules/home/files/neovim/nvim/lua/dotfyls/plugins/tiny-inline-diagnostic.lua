---@module "lazy"
---@type LazySpec
return {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = { "BufNewFile", "BufReadPost" },
    init = function() vim.diagnostic.config({ virtual_text = false }) end,
    opts = function()
        ---@module "tiny-inline-diagnostic"
        ---@type PluginConfig
        ---@diagnostic disable-next-line: missing-fields
        return {
            options = {
                show_source = { if_many = true },
                multilines = { enabled = true },
            },
        }
    end,
}
