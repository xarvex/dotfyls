return {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = { "BufNewFile", "BufReadPost" },
    opts = function()
        vim.diagnostic.config({
            virtual_text = false,
            virtual_lines = { highlight_whole_line = false },
        })

        vim.diagnostic.config({
            virtual_text = true,
            virtual_lines = false,
        }, vim.api.nvim_get_namespaces().lazy)

        return {}
    end,
}
