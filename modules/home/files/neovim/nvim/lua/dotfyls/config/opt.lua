local o = vim.o
local opt = vim.opt

-- Appearance
--
o.number = true
o.relativenumber = true
o.cursorline = true
o.cursorlineopt = "number"
o.showmatch = true
o.signcolumn = "yes"
o.colorcolumn = "80"
o.list = true
opt.fillchars = {
    diff = "╱",
    eob = " ",
    fold = " ",
    foldclose = "",
    foldopen = "",
    foldsep = " ",
}
o.smoothscroll = true

-- Completion
--
o.completeopt = "menu,menuone,noselect"
o.pumheight = 10
o.pumblend = 15
o.wildmenu = true
o.wildmode = "longest:full,full"
o.wildoptions = o.wildoptions .. ",pum"

-- Diagnostic
--
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
        },
    },
})

-- File
--
o.autoread = true
o.updatetime = 200
o.undolevels = 10000
o.swapfile = false
o.backup = true
---@diagnostic disable-next-line: param-type-mismatch
o.backupdir = vim.fs.joinpath(vim.fn.stdpath("state"), "backup")
o.undofile = true
---@diagnostic disable-next-line: param-type-mismatch
o.undodir = vim.fs.joinpath(vim.fn.stdpath("state"), "undo")
opt.shortmess:append({ C = true, I = true, W = true, c = true })

-- Fold
--
o.foldcolumn = "0"
o.foldlevel = 99
o.foldlevelstart = 99
o.foldmethod = "expr"
o.foldtext = ""
o.foldexpr = "v:lua.require'dotfyls.interop'.foldexpr()"

-- Format
--
o.formatoptions = "jcroqlnt"
o.formatexpr = "v:lua.require'dotfyls.interop'.formatexpr()"

-- Indentation
--
o.expandtab = true
o.smartindent = true
o.shiftround = true
o.shiftwidth = 4
o.tabstop = 4

-- Input
--
o.confirm = true
o.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
o.mouse = "a"
o.mousemodel = "extend"
o.mousescroll = "ver:4,hor:6"

-- Navigation
--
o.jumpoptions = "view"

-- Search
--
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true
o.synmaxcol = 500

-- Spell
--
o.spell = true
opt.spelllang = { "en_us", "en" }
opt.spelloptions:append("noplainbuffer")

-- Window
--
o.wrap = false
o.linebreak = true
o.splitbelow = true
o.splitright = true
o.splitkeep = "screen"
o.winminwidth = 6
o.scrolloff = 8
o.sidescrolloff = 4
