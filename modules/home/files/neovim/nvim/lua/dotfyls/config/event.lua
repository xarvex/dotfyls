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

vim.api.nvim_create_autocmd("LspAttach", {
    group = require("dotfyls.interop").group,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client ~= nil then
            if client.name == "gopls" then
                if not client.server_capabilities.semanticTokensProvider then
                    local semantic = client.config.capabilities.textDocument.semanticTokens
                    if semantic ~= nil then
                        client.server_capabilities.semanticTokensProvider = {
                            full = true,
                            legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
                            range = true,
                        }
                    end
                end
            elseif client.name == "nil_ls" then
                client.server_capabilities.renameProvider = false
            end
        end
    end,
    desc = "LSP server fixes",
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
        else
            local has_lazy, lazy_config = pcall(require, "lazy.core.config")

            if has_lazy and lazy_config.plugins["oil.nvim"] then require("lazy").load({ plugins = { "oil.nvim" } }) end
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
