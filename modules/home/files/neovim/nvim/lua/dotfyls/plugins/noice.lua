-- TODO: adjust appearance
return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = function()
            return {
                lsp = {
                    override = {
                        ["cmp.entry.get_documentation"] = true,
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                    },
                },
                presets = {
                    long_message_to_split = true,
                    inc_rename = require("lazy.core.config").plugins["inc-rename.nvim"] ~= nil,
                },
                views = {
                    cmdline_popup = {
                        border = {
                            style = "none",
                            padding = { 1, 2 },
                        },
                        filter_options = {},
                        win_options = {
                            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                        },
                        position = {
                            row = 5,
                            col = "70%",
                        },
                    },
                    popupmenu = {
                        relative = "editor",
                        border = {
                            style = "none",
                            padding = { 0, 1 },
                        },
                        win_options = {
                            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                        },
                    },
                },
                routes = {
                    {
                        filter = {
                            event = "msg_show",
                            find = "%d+L, %d+B",
                        },
                        opts = { skip = true },
                    },
                },
            }
        end,
    },
    { "MunifTanjim/nui.nvim", lazy = true },
}
