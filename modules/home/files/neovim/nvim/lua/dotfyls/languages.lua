local M = {
    lsp = {
        ft = {},
        parser = {},
        config = {},
        path = {},
    },
}

local languages = {
    astro = "astro",
    bash = {
        ft = "sh",
        parser = "bash",
    },
    c = {
        ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        parser = { "c", "cpp" },
    },
    css = {
        ft = { "css", "scss", "less" },
        parser = "css",
    },
    go = {
        ft = { "go", "gomod", "gowork", "gotmpl" },
        parser = { "go", "gomod", "gowork", "gosum" },
    },
    html = {
        ft = { "html", "templ" },
        parser = "html",
    },
    json = {
        ft = { "json", "jsonc" },
        parser = { "json", "jsonc", "json5" },
    },
    lua = {
        ft = "lua",
        parser = { "lua", "luadoc", "luap" },
    },
    nix = "nix",
    python = "python",
    rust = {
        ft = "rust",
        parser = { "rust", "ron" },
    },
    svelte = "svelte",
    typescript = {
        -- stylua: ignore
        ft = {
            "javascript", "javascriptreact", "javascript.jsx",
            "typescript", "typescriptreact", "typescript.tsx",
        },
        parser = { "javascript", "jsdoc", "typescript", "tsx" },
    },
    vue = "vue",
}

local lsps = {
    ["astro-ls"] = {
        language = languages.astro,
        entry = "astro",
    },
    ["bash-language-server"] = {
        language = languages.bash,
        entry = "bashls",
    },
    ["clangd"] = {
        language = languages.c,
        entry = "clangd",
        opts = {
            on_attach = function(_, bufnr)
                vim.keymap.set(
                    "n",
                    "<leader>ch",
                    vim.cmd.ClangdSwitchSourceHeader,
                    { silent = true, buffer = bufnr, desc = "LSP switch source/header (clangd)" }
                )
            end,
        },
    },
    ["vscode-css-language-server"] = {
        language = languages.css,
        entry = "cssls",
    },
    ["deno"] = {
        language = languages.typescript,
        entry = "denols",
        opts = function()
            return {
                root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
            }
        end,
    },
    ["gopls"] = {
        language = languages.go,
        opts = { settings = { gofumpt = true } },
    },
    ["vscode-html-language-server"] = {
        language = languages.html,
        entry = "html",
    },
    ["vscode-json-language-server"] = {
        language = languages.json,
        entry = "jsonls",
    },
    ["lua-language-server"] = {
        language = languages.lua,
        entry = "lua_ls",
    },
    ["nil"] = {
        language = languages.nix,
        entry = "nil_ls",
    },
    ["pyright-langserver"] = {
        language = languages.python,
        entry = "pyright",
    },
    ["rust-analyzer"] = {
        language = languages.rust,
        entry = "rust_analyzer",
        opts = false, -- TODO: default when rustaceanvim not enabled
    },
    ["svelteserver"] = {
        language = languages.svelte,
        entry = "svelte",
    },
    ["typescript-language-server"] = {
        language = languages.typescript,
        entry = "ts_ls",
        opts = function()
            return {
                root_dir = require("lspconfig").util.root_pattern("tsconfig.json"),
            }
        end,
    },
    ["vale-ls"] = {
        language = { ft = { "markdown", "text", "tex" } },
        entry = "vale_ls",
    },
    ["vls"] = {
        language = languages.vue,
        entry = "vuels",
    },
}

for server, data in pairs(lsps) do
    M.lsp.path[server] = vim.fn.executable(server) == 1
    if M.lsp.path[server] then
        if type(data.language) == "table" then
            if type(data.language.ft) == "table" then
                ---@diagnostic disable-next-line: param-type-mismatch
                vim.list_extend(M.lsp.ft, data.language.ft)
            else
                M.lsp.ft[#M.lsp.ft + 1] = data.language.ft
            end

            if type(data.parser) == "table" then
                ---@diagnostic disable-next-line: param-type-mismatch
                vim.list_extend(M.lsp.parser, data.language.parser)
            else
                M.lsp.parser[#M.lsp.parser + 1] = data.language.parser
            end
        else
            M.lsp.ft[#M.lsp.ft + 1] = data.language
            M.lsp.parser[#M.lsp.parser + 1] = data.language
        end

        if (data.entry or data.opts) and data.opts ~= false then M.lsp.config[data.entry or server] = data.opts or {} end
    end
end

return M
