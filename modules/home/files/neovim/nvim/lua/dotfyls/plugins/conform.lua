-- TODO: lazy loading filetypes
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
    opts = {
        formatters_by_ft = {
            fish = { "fish_indent" },
            go = { "gofumpt", "goimports", "gofmt" },
            javascript = { "prettierd", "prettier" },
            lua = { "stylua" },
            nix = { "nixfmt" },
            python = { "ruff_format" },
            sh = { "shfmt" },
            sql = { "sql_formatter" },
            ["_"] = { "trim_whitespace" },
        },
        default_format_opts = {
            lsp_format = "fallback",
            stop_after_first = false,
        },
        format_after_save = {},
    },
}
