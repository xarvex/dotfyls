-- TODO: possibly bring back mason for legacy distros
return {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspLog", "LspStart" },
    ft = require("dotfyls.languages").lsp.ft,
    config = function()
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            require("lazy.core.config").plugins["cmp-nvim-lsp"] and require("cmp_nvim_lsp").default_capabilities() or {},
            {
                workspace = {
                    fileOperations = {
                        didRename = true,
                        willRename = true,
                    },
                },
            }
        )

        for server, opts in pairs(require("dotfyls.languages").lsp.config) do
            opts = type(opts) == "function" and opts() or opts

            require("lspconfig")[server].setup(vim.tbl_deep_extend("force", { capabilities = vim.deepcopy(capabilities) }, opts))
        end
    end,
}
