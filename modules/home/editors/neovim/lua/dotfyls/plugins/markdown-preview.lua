---@module "lazy"
---@type LazySpec
-- WARNING: UNMAINTAINED
return {
    "iamcco/markdown-preview.nvim",
    build = function(plugin)
        if vim.fn.executable("npx") == 1 then
            local job = vim.fn.jobstart(
                { "npx", "-y", "yarn", "install" },
                { cwd = vim.fs.joinpath(plugin.dir, "app") }
            )
            vim.fn.jobwait({ job })
        else
            require("lazy").load({ plugins = { plugin.name } })
            vim.fn["mkdp#util#install"]()
        end
    end,
    cmd = { "MarkdownPreview", "MarkdownPreviewToggle" },
    keys = {
        { "<leader>md", vim.cmd.MarkdownPreviewToggle },
    },
    ft = "markdown",
    config = function() vim.g.mkdp_filetypes = { "markdown" } end,
}
