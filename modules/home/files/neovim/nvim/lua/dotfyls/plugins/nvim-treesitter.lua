return {
    "nvim-treesitter/nvim-treesitter",
    build = function() require("nvim-treesitter.install").update({ with_sync = true })() end,
    cmd = {
        "TSBufDisable",
        "TSBufEnable",
        "TSBufToggle",
        "TSConfigInfo",
        "TSDisable",
        "TSEditQuery",
        "TSEditQueryUserAfter",
        "TSEnable",
        "TSInstall",
        "TSInstallFromGrammar",
        "TSInstallInfo",
        "TSInstallSync",
        "TSModuleInfo",
        "TSToggle",
        "TSUninstall",
        "TSUpdate",
        "TSUpdateSync",
    },
    event = { "BufNewFile", "BufReadPost" },
    init = function(plugin)
        -- Plugins do not `require`, so make queries available.
        require("lazy.core.loader").add_to_rtp(plugin)
        require("nvim-treesitter.query_predicates")
    end,
    config = function()
        local ensure_installed = vim.list_extend(vim.list_extend({}, require("dotfyls.languages").lsp.parser), {
            "diff",
            "git_config",
            "git_rebase",
            "gitattributes",
            "gitcommit",
            "gitignore",
            "json5",
            "lua",
            "luadoc",
            "luap",
            "markdown",
            "markdown_inline",
            "query",
            "regex",
            "toml",
            "vim",
            "vimdoc",
            "xml",
            "yaml",
        })

        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.configs").setup({
            ensure_installed = ensure_installed,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
