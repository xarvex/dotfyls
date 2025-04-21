require("dotfyls.config")

if vim.fn.executable("git") == 1 then
    local lazypath = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy/lazy.nvim")
    if vim.fn.isdirectory(lazypath) == 0 then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)

    require("lazy").setup("dotfyls.plugins", {
        dev = {
            path = vim.fs.joinpath(vim.env.XDG_DOCUMENTS_DIR or vim.fs.joinpath(require("dotfyls.files").home, "Documents"), "Projects"),
        },
        change_detection = { notify = false },
        performance = {
            rtp = {
                disabled_plugins = {
                    "editorconfig",
                    "rplugin",
                    "tohtml",
                    "tutor",
                },
            },
        },
    })
    vim.keymap.set("n", "<C-A-l>", vim.cmd.Lazy, { silent = true, desc = "Open Lazy" })
end
