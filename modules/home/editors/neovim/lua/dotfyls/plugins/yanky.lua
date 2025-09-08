---@module "lazy"
---@type LazySpec
return {
    "gbprod/yanky.nvim",
    event = { "BufNewFile", "BufReadPost" },
    opts = {
        highlight = { timer = 150 },
    },
    keys = {
        { "<leader>p", vim.cmd.YankyRingHistory, mode = { "n", "x" }, desc = "Yank history (yanky.nvim)" },
        { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank (yanky.nvim)" },
        { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after cursor (yanky.nvim)" },
        { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before cursor (yanky.nvim)" },
        { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put after selection (yanky.nvim)" },
        { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put before selection (yanky.nvim)" },
        { "[y", "<Plug>(YankyCycleForward)", desc = "Next yank history item (yanky.nvim)" },
        { "]y", "<Plug>(YankyCycleBackward)", desc = "Previous yank history item (yanky.nvim)" },
    },
}
