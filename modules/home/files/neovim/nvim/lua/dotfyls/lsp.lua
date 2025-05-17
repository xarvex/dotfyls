local M = {}

---@type table<string,nil|boolean|vim.lsp.Config|fun(): vim.lsp.Config?>
M.server_opts = {
    biome = function()
        local default_config = vim.lsp.config.biome
        local cmd = default_config.cmd --[[@as string[] ]]

        if default_config.root_dir(0, function() end) == nil then
            cmd = vim.list_extend({ [#cmd + 1] = "--config-path=" .. vim.fs.joinpath(require("dotfyls.files").config_dir, "biome") }, cmd)
        end

        return { cmd = cmd }
    end,
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
                -- NOTE: neotest-go has no DAP strategy.
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
    vale_ls = {
        filetypes = {
            "asciidoc",
            "c",
            "cpp",
            "cs",
            "css",
            "go",
            "haskell",
            "html",
            "java",
            "javascript",
            "lua",
            "markdown",
            "org",
            "perl",
            "php",
            "pod",
            "proto",
            "ps1",
            "python",
            "r",
            "rst",
            "ruby",
            "rust",
            "sass",
            "sbt",
            "scala",
            "swift",
            "tex",
            "text",
            "typescript",
            "typescriptreact",
            "xhtml",
            "xml",
        },
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

    if require("lazy.core.config").plugins["blink.cmp"] then opts.capabilities = require("blink.cmp").get_lsp_capabilities() end

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
