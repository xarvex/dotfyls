return {
    {
        -- DEPENDENCIES: rg and plenary for searching.
        "folke/todo-comments.nvim",
        event = { "BufNewFile", "BufReadPost" },
        keys = function()
            local keys = {
                { "[t", function() require("todo-comments").jump_prev() end, silent = true, desc = "Previous todo comment (Todo)" },
                { "]t", function() require("todo-comments").jump_next() end, silent = true, desc = "Next todo comment (Todo)" },
            }

            if require("lazy.core.config").plugins["trouble.nvim"] then
                vim.list_extend(keys, {
                    {
                        "<leader>xt",
                        function() vim.cmd.Trouble("todo toggle focus=true filter = {tag = {FIX,TODO,HACK}}") end,
                        silent = true,
                        desc = "Todo actionable comments (Trouble)",
                    },
                    {
                        "<leader>xT",
                        function() vim.cmd.Trouble("todo toggle focus=true") end,
                        silent = true,
                        desc = "Todo all comments (Trouble)",
                    },
                })
            end

            return keys
        end,
        opts = {},
    },
    { "nvim-lua/plenary.nvim", lazy = true },
}
