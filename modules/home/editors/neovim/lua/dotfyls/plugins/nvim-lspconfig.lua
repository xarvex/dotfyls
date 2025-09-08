local keymap = vim.keymap.set

keymap("n", "<leader>ch", "<Nop>", { silent = true })

---@module "lazy"
---@type LazySpec
return {
    "neovim/nvim-lspconfig",
    lazy = false,
    cmd = { "LspInfo", "LspLog", "LspStart" },
    init = function(plugin)
        -- Make LSP configs available.
        require("lazy.core.loader").add_to_rtp(plugin)
    end,
}
