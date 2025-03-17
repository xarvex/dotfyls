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
                    -- NOTE: neotest-go has no DAP strategy.
                    -- See: https://github.com/nvim-neotest/neotest-go/issues/12
                    keymap(
                        "n",
                        "<leader>td",
                        function() require("dap-go").debug_test() end,
                        { silent = true, buffer = bufnr, desc = "Debug nearest test (nvim-dap-go)" }
                    )
                end,
            },
            jsonls = {
                settings = {
                    json = {
                        schemas = require("schemastore").json.schemas(),
                    },
                },
            },
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
            yamlls = {
                settings = {
                    yaml = {
                        schemaStore = { enable = false, url = "" },
                        schemas = require("schemastore").yaml.schemas(),
                    },
                },
            },
        }

        for _, file in pairs(vim.fn.readdir(require("dotfyls.files").lsp_directory)) do
            local server = file:gsub("%.json$", "")
            local opts = require("dotfyls.files").lsp_config(file)
            if opts ~= nil then
                local override = servers[server]
                if override ~= false then
                    if override ~= nil then
                        opts = vim.tbl_deep_extend("force", opts, type(override) == "function" and override() or override)
                    end
                    if require("lazy.core.config").plugins["blink.cmp"] then
                        opts.capabilities = require("blink.cmp").get_lsp_capabilities(opts.capabilities, true)
                    end
                    require("lspconfig")[server].setup(opts)
                end
            end
        end
    end,
}
