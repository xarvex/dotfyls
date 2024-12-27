return {
    {
        "folke/lazydev.nvim",
        cond = require("dotfyls.languages").lsp.path["lua-language-server"],
        cmd = "LazyDev",
        ft = "lua",
        opts = {
            library = { "luvit-meta/library" },
            enabled = function(root_dir) return not vim.uv.fs_stat(root_dir .. "/.luarc.json") end,
        },
    },
    { "Bilal2453/luvit-meta", lazy = true },
}
