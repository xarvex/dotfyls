local function map_oil(bufnr, dir)
    vim.keymap.set(
        "n",
        "-",
        function() require("oil").open(dir) end,
        { silent = true, buffer = bufnr, desc = "Open parent directory (oil.nvim)" }
    )
    vim.keymap.set(
        "n",
        "<leader>-",
        function() require("oil").open_float(dir) end,
        { silent = true, buffer = bufnr, desc = "Open parent directory floating (oil.nvim)" }
    )
end

---@module "lazy"
---@type LazySpec
return {
    {
        "stevearc/oil.nvim",
        cmd = "Oil",
        event = "VimEnter",
        init = function()
            map_oil()

            vim.api.nvim_create_autocmd("BufEnter", {
                group = require("dotfyls.interop").group,
                callback = function(args)
                    vim.schedule(function()
                        if vim.fn.isdirectory(vim.api.nvim_buf_get_name(args.buf)) == 1 then require("oil") end
                    end)
                end,
                desc = "Lazy loading (oil.nvim)",
            })
        end,
        opts = function()
            local hidden_files = require("dotfyls.list").into_set({ "..", ".devenv", ".direnv", ".git" })

            return {
                watch_for_changes = true,
                use_default_keymaps = false,
                keymaps = {
                    ["<CR>"] = {
                        "actions.select",
                        callback = function(opts)
                            opts = opts or {}
                            local callback = opts.callback

                            local entry = require("oil").get_cursor_entry()
                            local dir = require("oil").get_current_dir()
                            opts.callback = (entry ~= nil and entry.type == "link")
                                    and function()
                                        map_oil(true, dir)
                                        if callback ~= nil then callback() end
                                    end
                                or callback

                            require("oil.actions").select.callback(opts)
                        end,
                    },
                    ["_"] = { "actions.select", opts = { horizontal = true } },
                    ["|"] = { "actions.select", opts = { vertical = true } },
                    ["-"] = { "actions.parent" },
                },
                view_options = {
                    show_hidden = true,
                    is_always_hidden = function(name) return hidden_files[name] end,
                },
            }
        end,
    },
    { "nvim-tree/nvim-web-devicons", lazy = true },
}
