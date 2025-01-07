return {
    -- DEPENDENCIES: gnumake (optional) for building jsregexp.
    "L3MON4D3/LuaSnip",
    build = vim.fn.executable("make") == 1 and "make install_jsregexp" or nil,
    dependencies = {
        {
            "rafamadriz/friendly-snippets",
            config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
        },
    },
    lazy = true,
}
