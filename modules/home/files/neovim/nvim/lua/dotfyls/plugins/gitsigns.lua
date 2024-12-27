-- TODO: reconfigure
return {
    "lewis6991/gitsigns.nvim",
    event = { "BufNewFile", "BufReadPost" },
    opts = {
        on_attach = function(bufnr)
            local keymap = vim.keymap.set
            local opts = { buffer = bufnr }

            keymap("n", "[g", function()
                if vim.wo.diff then return "[c" end
                vim.schedule(function() require("gitsigns").prev_hunk() end)
                return "<Ignore>"
            end, { buffer = bufnr, expr = true })
            keymap("n", "]g", function()
                if vim.wo.diff then return "]c" end
                vim.schedule(function() require("gitsigns").next_hunk() end)
                return "<Ignore>"
            end, { buffer = bufnr, expr = true })

            keymap("n", "<leader>Hs", require("gitsigns").stage_hunk, opts)
            keymap("v", "<leader>Hs", function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, opts)
            keymap("n", "<leader>HS", require("gitsigns").stage_buffer, opts)

            keymap("n", "<leader>Hu", require("gitsigns").undo_stage_hunk, opts)

            keymap("n", "<leader>Hr", require("gitsigns").reset_hunk, opts)
            keymap("v", "<leader>Hr", function() require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, opts)
            keymap("n", "<leader>HR", require("gitsigns").reset_buffer, opts)

            keymap("n", "<leader>Hp", require("gitsigns").preview_hunk, opts)

            keymap("n", "<leader>Hb", require("gitsigns").toggle_current_line_blame, opts)
            keymap("n", "<leader>HB", function() require("gitsigns").blame_line({ full = true }) end, opts)

            keymap("n", "<leader>Hd", require("gitsigns").diffthis, opts)
            keymap("n", "<leader>HD", function() require("gitsigns").diffthis("~") end, opts)
        end,
    },
}
