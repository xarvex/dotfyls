return {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {
        {
            "<leader>cr",
            function() return ":IncRename " .. vim.fn.expand("<cword>") end,
            expr = true,
            desc = "LSP rename (inc-rename.nvim)",
        },
    },
    opts = function()
        return {
            preview_empty_name = true,
            save_in_cmdline_history = false,
            input_buffer_type = require("lazy.core.config").plugins["dressing.nvim"]
                    and not require("lazy.core.config").plugins["noice.nvim"]
                    and "dressing"
                or nil,
        }
    end,
}
