vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
    group = require("dotfyls.interop").group,
    callback = function()
        -- TODO: Figure out why `vim.lsp.config` is sometimes nil, and handle.
        -- Currently, the only known occurrence is with Git commit writing.
        if vim.lsp.config ~= nil then
            vim.lsp.config["*"] = require("dotfyls.lsp").default_opts()

            for _, file in pairs(vim.fn.readdir(require("dotfyls.files").lsp_directory)) do
                local server = file:gsub("%.json$", "")
                local opts = require("dotfyls.files").lsp_config(file)
                if opts ~= nil then
                    local override = require("dotfyls.lsp").server_opts[server]
                    if override ~= false then
                        if override ~= nil then
                            opts = vim.tbl_deep_extend("force", opts, type(override) == "function" and override() or override)
                        end

                        vim.lsp.config[server] = vim.tbl_deep_extend("force", vim.lsp.config[server], opts)
                        vim.lsp.enable(server)
                    end
                end
            end
        end
    end,
    once = true,
    desc = "Set LSP configuration",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = require("dotfyls.interop").group,
    pattern = "*.slint",
    callback = function(event) vim.bo[event.buf].filetype = "slint" end,
    desc = "Set slint filetype",
})

-- https://www.reddit.com/r/neovim/comments/wlkq0e/neovim_configuration_to_backup_files_with
vim.api.nvim_create_autocmd("BufWritePre", {
    group = require("dotfyls.interop").group,
    callback = function() vim.opt.backupext = "-" .. os.date("%Y%m%d%H%M") end,
    desc = "Add timestamp to backup extension",
})

vim.api.nvim_create_autocmd("BufWritePre", {
    group = require("dotfyls.interop").group,
    callback = function(event)
        if not event.match:match("^%w%w+:[\\/][\\/]") then
            local file = vim.uv.fs_realpath(event.match) or event.match
            vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
        end
    end,
    desc = "Create parent directories on write",
})

vim.api.nvim_create_autocmd("FileType", {
    group = require("dotfyls.interop").group,
    pattern = {
        "checkhealth",
        "help",
        "qf",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", vim.cmd.close, { silent = true, buffer = event.buf, desc = "Quit buffer" })
    end,
    desc = "Quit keymap assignment",
})

vim.api.nvim_create_autocmd("VimEnter", {
    group = require("dotfyls.interop").group,
    callback = function()
        if vim.fn.argc(-1) == 0 then
            vim.schedule(function()
                if vim.fn.line2byte(vim.fn.line("$")) == -1 then
                    local has_lazy, lazy_config = pcall(require, "lazy.core.config")

                    if has_lazy and lazy_config.plugins["oil.nvim"] then
                        require("oil").open()
                    else
                        vim.cmd.Ex()
                    end
                end
            end)
        end
    end,
    once = true,
    desc = "Open directory on launch when no files",
})

vim.api.nvim_create_autocmd("VimResized", {
    group = require("dotfyls.interop").group,
    callback = function()
        local current_tab = vim.fn.tabpagenr()

        vim.cmd("tabdo wincmd =")
        vim.cmd.tabnext(current_tab)
    end,
    desc = "Resize splits on Neovim resize",
})
