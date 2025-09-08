---@module "lazy"
---@type LazySpec
return {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function(plugin)
        local input = vim.ui.input
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.input = function(...)
            vim.ui.input = input
            require("lazy").load({ plugins = { plugin.name } })
            vim.ui.input(...)
        end

        local select = vim.ui.select
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.select = function(...)
            vim.ui.select = select
            require("lazy").load({ plugins = { plugin.name } })
            vim.ui.select(...)
        end
    end,
}
