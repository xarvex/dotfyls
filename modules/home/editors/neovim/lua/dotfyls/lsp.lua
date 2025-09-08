local M = {}

---@type table<string,nil|boolean|vim.lsp.Config|fun(): vim.lsp.Config?>
M.server_opts = {
    biome = {
        -- From: https://github.com/neovim/nvim-lspconfig/blob/408cf07b97535825cca6f1afa908d98348712ba6/lsp/biome.lua#L18-L25
        -- cmd = function(dispatchers) return vim.lsp.rpc.start({ "biome", "lsp-proxy" }, dispatchers) end,
        cmd = { "biome", "lsp-proxy" },
    },
    clangd = {
        on_attach = function(_, bufnr)
            vim.keymap.set(
                "n",
                "<leader>ch",
                vim.cmd.ClangdSwitchSourceHeader,
                { silent = true, buffer = bufnr, desc = "LSP switch source/header (clangd)" }
            )
        end,
    },
    gopls = {
        on_attach = function(client, bufnr)
            if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                if semantic ~= nil then
                    client.server_capabilities.semanticTokensProvider = {
                        full = true,
                        legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
                        range = true,
                    }
                end
            end

            if require("lazy.core.config").plugins["nvim-dap-go"] then
                -- neotest-go has no DAP strategy.
                -- See: https://github.com/nvim-neotest/neotest-go/issues/12
                vim.keymap.set(
                    "n",
                    "<leader>td",
                    function() require("dap-go").debug_test() end,
                    { silent = true, buffer = bufnr, desc = "Debug nearest test (nvim-dap-go)" }
                )
            end
        end,
    },
    jsonls = function()
        return require("lazy.core.config").plugins["schemastore.nvim"]
                and {
                    settings = {
                        json = {
                            schemas = require("schemastore").json.schemas(),
                        },
                    },
                }
            or {}
    end,
    nil_ls = {
        on_attach = function(client) client.server_capabilities.renameProvider = false end,
    },
    rust_analyzer = require("lazy.core.config").plugins["rustaceanvim"] and false,
    ts_ls = {
        on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end,
    },
    yamlls = function()
        return require("lazy.core.config").plugins["schemastore.nvim"]
                and {
                    settings = {
                        yaml = {
                            schemaStore = { enable = false, url = "" },
                            schemas = require("schemastore").yaml.schemas(),
                        },
                    },
                }
            or {}
    end,
}

---@return table
function M.default_opts()
    local opts = {}

    if require("lazy.core.config").plugins["blink.cmp"] then
        opts.capabilities = require("blink.cmp").get_lsp_capabilities()
    end

    if require("lazy.core.config").plugins["nvim-ufo"] then
        opts = vim.tbl_deep_extend("force", opts, {
            capabilities = {
                textDocument = {
                    foldingRange = {
                        dynamicRegistration = false,
                        lineFoldingOnly = true,
                    },
                },
            },
        })
    end

    return opts
end

return M
