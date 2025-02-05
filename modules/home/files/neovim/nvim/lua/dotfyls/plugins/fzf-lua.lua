---@module "lazy"
---@type LazySpec
return {
    {
        -- DEPENDENCIES:
        -- fd (for files), rg, and grep in that order for search.
        -- chafa for image preview.
        -- delta for native code actions.
        "ibhagwan/fzf-lua",
        cmd = "FzfLua",
        keys = {
            { "<leader>ff", function() require("fzf-lua").files() end, desc = "Find files (fzf-lua)" },
            { "<leader>fg", function() require("fzf-lua").live_grep() end, silent = true, desc = "Live grep (fzf-lua)" },
            { "<leader>fb", function() require("fzf-lua").buffers() end, silent = true, desc = "Buffers (fzf-lua)" },
            { "<leader>fh", function() require("fzf-lua").help_tags() end, silent = true, desc = "Help tags (fzf-lua)" },
        },
        opts = function()
            return {
                "default-title",
                fzf_colors = true,
                fzf_opts = {
                    ["--no-scrollbar"] = true,
                },
                defaults = {
                    formatter = "path.dirname_first",
                    keymap = {
                        fzf = {
                            ["ctrl-q"] = "select-all+accept",
                            ["ctrl-d"] = "preview-page-down",
                            ["ctrl-u"] = "preview-page-up",
                            ["ctrl-x"] = "jump",
                        },
                    },
                },
                previewers = {
                    builtin = {
                        extensions = {
                            ["gif"] = { cmd = "chafa", args = { "{file}", "--format=symbols" } },
                            ["jpeg"] = { cmd = "chafa", args = { "{file}", "--format=symbols" } },
                            ["jpg"] = { cmd = "chafa", args = { "{file}", "--format=symbols" } },
                            ["png"] = { cmd = "chafa", args = { "{file}", "--format=symbols" } },
                            ["webp"] = { cmd = "chafa", args = { "{file}", "--format=symbols" } },
                        },
                    },
                },
                winopts = {
                    col = 0.5,
                    row = 0.5,
                    width = 0.8,
                    height = 0.8,
                    preview = { scrollchars = { "┃", "" } },
                },
                buffers = {
                    prompt = " ",
                    silent = true,
                },
                files = {
                    prompt = " ",
                    silent = true,
                    cwd_prompt = false,
                    actions = {
                        ["alt-i"] = { require("fzf-lua.actions").toggle_ignore },
                        ["alt-h"] = { require("fzf-lua.actions").toggle_hidden },
                        ["ctrl-t"] = {
                            fn = require("lazy.core.config").plugins["trouble.nvim"]
                                    and function(selected, fzf_opts, opts)
                                        if require("lazy.core.config").plugins["trouble.nvim"] then
                                            require("trouble.sources.fzf").actions.open.fn(selected, fzf_opts, opts)
                                        end
                                    end
                                or function() end,
                            prefix = vim.uv.os_uname().sysname:find("Windows")
                                    and "transform(IF %FZF_SELECT_COUNT% LEQ 0 (echo select-all))"
                                or "transform([ $FZF_SELECT_COUNT -eq 0 ] && echo select-all)",
                            desc = "smart-open-with-trouble",
                        },
                    },
                },
                grep = {
                    prompt = " ",
                    silent = true,
                    actions = {
                        ["alt-i"] = { require("fzf-lua.actions").toggle_ignore },
                        ["alt-h"] = { require("fzf-lua.actions").toggle_hidden },
                    },
                },
                lsp = {
                    prompt = " ",
                    silent = true,
                    code_actions = {
                        previewer = vim.fn.executable("delta") and "codeaction_native" or nil,
                    },
                },
            }
        end,
    },
    { "nvim-tree/nvim-web-devicons", lazy = true },
}
