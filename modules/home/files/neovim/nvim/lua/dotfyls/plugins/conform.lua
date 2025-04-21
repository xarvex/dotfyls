---@module "lazy"
---@type LazySpec
return {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    event = "BufWritePre",
    keys = {
        {
            "<leader>cf",
            function() require("conform").format({ async = true }) end,
            silent = true,
            desc = "Format (conform.nvim)",
        },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        formatters_by_ft = {
            bash = { "shfmt" },
            fish = { "fish_indent" },
            javascript = { "prettierd", "prettier" },
            lua = { "stylua" },
            nix = { "nixfmt" },
            python = { "ruff_format" },
            sh = { "shfmt" },
            sql = { "sqlfluff" },
            ["_"] = { "trim_whitespace", lsp_format = "prefer" },
        },
        default_format_opts = {
            lsp_format = "fallback",
            stop_after_first = false,
        },
        format_after_save = {},
    },
}
