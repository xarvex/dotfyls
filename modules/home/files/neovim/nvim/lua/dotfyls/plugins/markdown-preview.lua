-- WARNING: UNMAINTAINED
return {
    "iamcco/markdown-preview.nvim",
    build = function(plugin)
        if vim.fn.executable("npx") == 1 then
            vim.cmd("!cd '" .. plugin.dir .. "'/app && npx -y yarn install")
        else
            require("lazy").load({ plugins = { plugin.name } })
            vim.fn["mkdp#util#install"]()
        end
    end,
    cmd = {
        "MarkdownPreview",
        "MarkdownPreviewStop",
        "MarkdownPreviewToggle",
    },
    keys = {
        { "<leader>md", vim.cmd.MarkdownPreviewToggle },
    },
    ft = "markdown",
    config = function() vim.g.mkdp_filetypes = { "markdown" } end,
}
