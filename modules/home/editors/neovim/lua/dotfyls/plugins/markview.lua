---@module "lazy"
---@type LazySpec
return {
    "OXY2DEV/markview.nvim",
    cmd = "Markview",
    event = { "BufNewFile", "BufReadPost" },
    opts = function()
        ---@module "markview"
        ---@type markview.config
        return {
            ---@diagnostic disable-next-line: missing-fields
            experimental = {
                prefer_nvim = true,
            },
            preview = {
                icon_provider = require("lazy.core.config").plugins["mini.icons"] and "mini"
                    or (require("lazy.core.config").plugins["nvim-web-devicons"] and "devicons" or "internal"),
            },
        }
    end,
}
