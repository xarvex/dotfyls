---@module "lazy"
---@type LazySpec
-- TODO: Reconfigure.
return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function()
            local function filename_component(no_separator)
                local separator = nil
                if no_separator then separator = "" end
                return {
                    "filename",
                    newfile_status = true,
                    path = 1,
                    symbols = {
                        unnamed = "",
                        newfile = "",
                        modified = "●",
                        readonly = "",
                    },
                    fmt = function(name) return vim.fs.basename(name) == "" and "" or name end,
                    separator = separator,
                }
            end

            return {
                options = {
                    disabled_filetypes = {
                        "aerial",
                        "diff",
                        "fugitive",
                        "help",
                        "noice",
                        "qf",
                        "trouble",
                        "undotree",
                    },
                    component_separators = "|",
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { { "mode", separator = { left = "", right = "" }, right_padding = 2 } },
                    lualine_b = { filename_component(), "branch" },
                    lualine_c = { "diagnostics" },
                    lualine_x = { "fileformat" },
                    lualine_y = { "filetype", "progress" },
                    lualine_z = { { "location", separator = { left = "", right = "" }, left_padding = 2 } },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { filename_component(true), "diagnostics" },
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = { "location" },
                },
            }
        end,
    },
    { "nvim-tree/nvim-web-devicons", lazy = true },
}
