local keymap = vim.keymap.set

keymap({ "n", "v" }, "<leader>ra", "<Nop>", { silent = true })
keymap("n", "<leader>re", "<Nop>", { silent = true })
keymap("n", "<leader>rC", "<Nop>", { silent = true })
keymap("n", "<leader>rD", "<Nop>", { silent = true })

---@module "lazy"
---@type LazySpec
return {
    "mrcjkb/rustaceanvim",
    version = "^6",
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

        local lsp_opts = require("dotfyls.files").lsp_config("rust_analyzer", true)
        vim.lsp.config.rust_analyzer = lsp_opts
        ---@module "rustaceanvim"
        ---@type rustaceanvim.Opts
        vim.g.rustaceanvim = {
            tools = {}, -- TODO: Configure tools.
            server = {
                on_attach = function(client, bufnr)
                    local default_opts = require("dotfyls.lsp").default_opts()
                    client.capabilities = vim.tbl_deep_extend(
                        "force",
                        require("rustaceanvim.config.server").create_client_capabilities(),
                        default_opts.capabilities ~= nil and default_opts.capabilities or {},
                        (lsp_opts ~= nil and lsp_opts.capabilities ~= nil) and lsp_opts.capabilities or {}
                    )

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
                default_settings = (lsp_opts ~= nil and lsp_opts.settings ~= nil) and lsp_opts.settings or { ["rust-analyzer"] = {} },
            },
            ---@module "dap"
            dap = { adapter = require("dap").adapters.codelldb },
        }
    end,
}
