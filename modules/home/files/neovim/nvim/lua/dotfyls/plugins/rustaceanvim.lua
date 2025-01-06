local keymap = vim.keymap.set

keymap({ "n", "v" }, "<leader>ra", "<Nop>", { silent = true })
keymap("n", "<leader>re", "<Nop>", { silent = true })
keymap("n", "<leader>rC", "<Nop>", { silent = true })
keymap("n", "<leader>rD", "<Nop>", { silent = true })

return {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = "rust",
    config = function()
        keymap(
            { "n", "v" },
            "<leader>ra",
            function() vim.cmd.RustLsp("codeAction") end,
            { silent = true, desc = "LSP code action (rustaceanvim)" }
        )
        keymap(
            "n",
            "<leader>re",
            function() vim.cmd.RustLsp("explainError") end,
            { silent = true, desc = "rustc explain error (rustaceanvim)" }
        )
        keymap("n", "<leader>rC", function() vim.cmd.RustLsp("openCargo") end, { silent = true, desc = "Open Cargo.toml (rustaceanvim)" })
        keymap("n", "<leader>rD", function() vim.cmd.RustLsp("openDocs") end, { silent = true, desc = "Open docs.rs (rustaceanvim)" })

        vim.g.rustaceanvim = {
            tools = {}, -- TODO: configure tools
            server = {
                on_attach = function(_, bufnr)
                    keymap(
                        { "n", "v" },
                        "J",
                        function() vim.cmd.RustLsp("joinLines") end,
                        { silent = true, buffer = bufnr, desc = "Join lines (rustaceanvim)" }
                    )
                    keymap(
                        "n",
                        "<leader>ca",
                        function() vim.cmd.RustLsp("codeAction") end,
                        { silent = true, buffer = bufnr, desc = "LSP code action (rustaceanvim)" }
                    )
                end,
                default_settings = {
                    ["rust-analyzer"] = {}, -- TODO: set desired
                },
            },
            dap = {}, -- TODO: set up dap
        }
    end,
}
