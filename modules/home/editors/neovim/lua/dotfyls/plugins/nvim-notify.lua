---@module "lazy"
---@type LazySpec
-- TODO: Adjust appearance.
return {
    "rcarriga/nvim-notify",
    keys = {
        {
            "<leader>N",
            function() require("notify").dismiss({ silent = true, pending = true }) end,
            silent = true,
            desc = "Dismiss All Notifications",
        },
    },
    init = function()
        if not require("lazy.core.config").plugins["noice.nvim"] then vim.notify = require("notify") end
    end,
    opts = {
        background_colour = "#000000",
        render = "wrapped-compact",
        stages = "fade",
        timeout = 3000,
        max_height = function() return math.floor(vim.o.lines * 0.75) end,
        max_width = function() return math.floor(vim.o.columns * 0.75) end,
        on_open = function(win) vim.api.nvim_win_set_config(win, { zindex = 100 }) end,
    },
}
