local keymap = vim.keymap.set

keymap("n", "<leader>ch", "<Nop>", { silent = true })

---@module "lazy"
---@type LazySpec
return {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspLog", "LspStart" },
    event = { "BufNewFile", "BufReadPost" },
    config = function()
        local servers = {
            biome = function()
                local default_config = require("lspconfig.configs.biome").default_config
                local cmd = default_config.cmd

                if default_config.root_dir() == nil then
                    cmd = vim.list_extend(
                        { [#cmd + 1] = "--config-path=" .. vim.fs.joinpath(require("dotfyls.files").config_dir, "biome") },
                        cmd
                    )
                end

                return { cmd = cmd }
            end,
            clangd = {
                on_attach = function(_, bufnr)
                    keymap(
                        "n",
                        "<leader>ch",
                        vim.cmd.ClangdSwitchSourceHeader,
                        { silent = true, buffer = bufnr, desc = "LSP switch source/header (clangd)" }
                    )
                end,
            },
            gopls = {
                on_attach = function(_, bufnr)
                    if require("lazy.core.config").plugins["nvim-dap-go"] then
                        -- NOTE: neotest-go has no DAP strategy.
                        -- See: https://github.com/nvim-neotest/neotest-go/issues/12
                        keymap(
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
            rust_analyzer = false,
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

        local default_opts = {}

        if require("lazy.core.config").plugins["blink.cmp"] then default_opts.capabilities = require("blink.cmp").get_lsp_capabilities() end

        if require("lazy.core.config").plugins["nvim-ufo"] then
            default_opts = vim.tbl_deep_extend("force", default_opts, {
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

        vim.lsp.config["*"] = default_opts

        for _, file in pairs(vim.fn.readdir(require("dotfyls.files").lsp_directory)) do
            local server = file:gsub("%.json$", "")
            local opts = require("dotfyls.files").lsp_config(file)
            if opts ~= nil then
                local override = servers[server]
                if override ~= false then
                    if override ~= nil then
                        opts = vim.tbl_deep_extend("force", opts, type(override) == "function" and override() or override)
                    end

                    vim.tbl_deep_extend("force", vim.lsp.config[server], opts)
                    vim.lsp.enable(server)
                end
            end
        end
    end,
}
