return {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspLog", "LspStart" },
    event = { "BufNewFile", "BufReadPost" },
    config = function()
        local servers = {
            astro = true,
            bashls = true,
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
            cssls = true,
            denols = { root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc") },
            fish_lsp = true,
            gopls = { settings = { gofumpt = true } },
            html = true,
            jsonls = true,
            lua_ls = true,
            nil_ls = true,
            pyright = true,
            rust_analyzer = false,
            slint_lsp = true,
            svelte = true,
            tinymist = true,
            ts_ls = { root_dir = require("lspconfig").util.root_pattern("tsconfig.json") },
            vala_ls = true,
            vale_ls = true,
            vuels = true,
        }

        for server, opts in pairs(servers) do
            if opts ~= false then
                opts = type(opts) == "table" and opts or {}
                if require("lazy.core.config").plugins["blink.cmp"] then
                    opts.capabilities = require("blink.cmp").get_lsp_capabilities(opts.capabilities, true)
                end
                require("lspconfig")[server].setup(opts)
            end
        end
    end,
}
