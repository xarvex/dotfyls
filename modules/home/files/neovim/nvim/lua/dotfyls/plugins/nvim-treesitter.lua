return {
    "nvim-treesitter/nvim-treesitter",
    build = function() require("nvim-treesitter.install").update({ with_sync = true })() end,
    main = "nvim-treesitter.configs",
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
    opts = {
        ensure_installed = {
            "astro",
            "bash",
            "c",
            "comment",
            "cpp",
            "css",
            "csv",
            "diff",
            "fish",
            "git_config",
            "git_rebase",
            "gitattributes",
            "gitcommit",
            "gitignore",
            "go",
            "gomod",
            "gosum",
            "gowork",
            "html",
            "hyprlang",
            "ini",
            "java",
            "javascript",
            "jsdoc",
            "json",
            "json5",
            "jsonc",
            "kotlin",
            "lua",
            "luadoc",
            "luap",
            "luau",
            "make",
            "markdown",
            "markdown_inline",
            "nix",
            "passwd",
            "python",
            "query",
            "regex",
            "requirements",
            "rust",
            "slint",
            "sql",
            "ssh_config",
            "svelte",
            "toml",
            "tsx",
            "typescript",
            "typst",
            "udev",
            "vala",
            "vim",
            "vimdoc",
            "vue",
            "xml",
            "xresources",
            "yaml",
            "zathurarc",
        },
        highlight = { enable = true },
        indent = { enable = true },
    },
}
