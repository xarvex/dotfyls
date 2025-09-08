---@module "lazy"
---@type LazySpec
return {
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                function() vim.cmd.Trouble("diagnostics toggle") end,
                silent = true,
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                function() vim.cmd.Trouble("diagnostics toggle filter.buf=0") end,
                silent = true,
                desc = "Buffer diagnostics (Trouble)",
            },
            {
                "<leader>xs",
                function() vim.cmd.Trouble("symbols toggle") end,
                silent = true,
                desc = "Symbols (Trouble)",
            },
            { "<leader>xL", function() vim.cmd.Trouble("lsp toggle") end, silent = true, desc = "LSP ... (Trouble)" },
            {
                "gd",
                function() vim.cmd.Trouble("lsp_definitions toggle focus=true") end,
                silent = true,
                desc = "LSP definition (Trouble)",
            },
            {
                "gD",
                function() vim.cmd.Trouble("lsp_declarations toggle focus=true") end,
                silent = true,
                desc = "LSP declaration (Trouble)",
            },
            {
                "gT",
                function() vim.cmd.Trouble("lsp_type_definitions toggle focus=true") end,
                silent = true,
                desc = "LSP type definition (Trouble)",
            },
            {
                "gi",
                function() vim.cmd.Trouble("lsp_implementations toggle focus=true") end,
                silent = true,
                desc = "LSP implementation (Trouble)",
            },
            {
                "gr",
                function() vim.cmd.Trouble("lsp_references toggle focus=true") end,
                silent = true,
                desc = "LSP references (Trouble)",
            },
            {
                "<leader>xl",
                function() vim.cmd.Trouble("loclist toggle") end,
                silent = true,
                desc = "Location list (Trouble)",
            },
            {
                "<leader>xQ",
                function() vim.cmd.Trouble("qflist toggle") end,
                silent = true,
                desc = "Quickfix list (Trouble)",
            },
            {
                "[q",
                function()
                    if require("trouble").is_open() then
                        ---@diagnostic disable-next-line: missing-fields, missing-parameter
                        require("trouble").prev({ skip_groups = true, jump = true })
                    else
                        vim.cmd.cprevious()
                    end
                end,
                silent = true,
                desc = "Previous quickfix item (Trouble)",
            },
            {
                "]q",
                function()
                    if require("trouble").is_open() then
                        ---@diagnostic disable-next-line: missing-fields, missing-parameter
                        require("trouble").next({ skip_groups = true, jump = true })
                    else
                        vim.cmd.cnext()
                    end
                end,
                silent = true,
                desc = "Next quickfix item (Trouble)",
            },
        },
        opts = {},
    },
    { "nvim-tree/nvim-web-devicons", lazy = true },
}
