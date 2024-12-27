local keymap = vim.keymap.set

-- ! Core
--
keymap({ "i", "n", "v", "x" }, "<Esc>", "<cmd>nohlsearch<CR><Esc>", { silent = true, desc = "Escape and clear hlsearch" })
-- Fixes problems with wrapped lines.
keymap({ "n", "v", "x" }, "j", function() return vim.v.count > 0 and "j" or "gj" end, { silent = true, expr = true, desc = "Down" })
keymap({ "n", "v", "x" }, "k", function() return vim.v.count > 0 and "k" or "gk" end, { silent = true, expr = true, desc = "Up" })
keymap({ "n", "v", "x" }, "<Down>", function() return vim.v.count > 0 and "j" or "gj" end, { silent = true, expr = true, desc = "Down" })
keymap({ "n", "v", "x" }, "<Up>", function() return vim.v.count > 0 and "k" or "gk" end, { silent = true, expr = true, desc = "Up" })
-- See: https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keymap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
keymap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
keymap({ "o", "x" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap({ "o", "x" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
-- Re-select after indent.
keymap("v", "<", "<gv", { silent = true, desc = "Decrease indent" })
keymap("v", ">", ">gv", { silent = true, desc = "Increase indent" })

-- Buffer
--
keymap("n", "<leader>bb", function() vim.cmd.e("#") end, { silent = true, desc = "Switch to other buffer" })
keymap("n", "<leader>bd", vim.cmd.bdelete, { silent = true, desc = "Delete buffer and window" })
keymap("n", "[b", vim.cmd.bprevious, { silent = true, desc = "Prev Buffer" })
keymap("n", "]b", vim.cmd.bnext, { silent = true, desc = "Next Buffer" })

-- Diagnostic
--
keymap("n", "<leader>d", function() vim.diagnostic.open_float({ border = "rounded" }) end, { silent = true, desc = "Current diagnostic" })
keymap(
    "n",
    "[d",
    function() vim.diagnostic.goto_prev({ float = { border = "rounded" } }) end,
    { silent = true, desc = "Previous diagnostic" }
)
keymap("n", "]d", function() vim.diagnostic.goto_next({ float = { border = "rounded" } }) end, { silent = true, desc = "Next diagnostic" })
keymap(
    "n",
    "[w",
    function() vim.diagnostic.goto_prev({ float = { border = "rounded" } }) end,
    { silent = true, desc = "Previous diagnostic warning" }
)
keymap(
    "n",
    "]w",
    function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN, float = { border = "rounded" } }) end,
    { silent = true, desc = "Next diagnostic warning" }
)
keymap(
    "n",
    "[e",
    function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, float = { border = "rounded" } }) end,
    { silent = true, desc = "Previous diagnostic error" }
)
keymap(
    "n",
    "]e",
    function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, float = { border = "rounded" } }) end,
    { silent = true, desc = "Next diagnostic error" }
)

-- File
--
keymap("n", "-", vim.cmd.Ex, { silent = true, desc = "Open parent directory" })

-- Movement
--
keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move down" })
keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move up" })
-- Comment insertion.
keymap("n", "gco", "o<Esc>Vcx<Esc><cmd>normal gcc<CR>fxa<BS>", { silent = true, desc = "Add comment below" })
keymap("n", "gcO", "O<Esc>Vcx<Esc><cmd>normal gcc<CR>fxa<BS>", { silent = true, desc = "Add comment above" })

-- LSP
--
-- Overridden by Trouble:
keymap("n", "gd", vim.lsp.buf.definition, { silent = true, desc = "LSP definition" })
keymap("n", "gD", vim.lsp.buf.declaration, { silent = true, desc = "LSP declaration" })
keymap("n", "gT", vim.lsp.buf.type_definition, { silent = true, desc = "LSP type definition" })
keymap("n", "gi", vim.lsp.buf.implementation, { silent = true, desc = "LSP implementation" })
keymap("n", "gr", vim.lsp.buf.references, { silent = true, desc = "LSP references" })
--
keymap("n", "K", vim.lsp.buf.hover, { silent = true, desc = "LSP hover" })
keymap("i", "<C-k>", vim.lsp.buf.signature_help, { silent = true, desc = "LSP signature help" })
keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { silent = true, desc = "LSP code action" })
keymap({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, { silent = true, desc = "LSP run codelens" })
keymap("n", "<leader>cC", vim.lsp.codelens.refresh, { silent = true, desc = "LSP refresh codelens" })
keymap("n", "<leader>cr", vim.lsp.buf.rename, { silent = true, desc = "LSP rename" })
keymap("n", "<leader>i", "<Nop>", { silent = true, desc = "LSP toggle inlay hint" })
vim.api.nvim_create_autocmd("LspAttach", {
    group = require("dotfyls.interop").group,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client ~= nil and client.server_capabilities.inlayHintProvider then
            keymap(
                "n",
                "<leader>i",
                function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }), { bufnr = args.buf }) end,
                { silent = true, buffer = args.buf, desc = "LSP toggle inlay hint" }
            )
        end
    end,
})

-- Quickfix
--
keymap("n", "<leader>xl", vim.cmd.lopen, { silent = true, desc = "Open location list" })
keymap("n", "<leader>xq", vim.cmd.copen, { silent = true, desc = "Open quickfix list" })
keymap("n", "[q", vim.cmd.cprevious, { silent = true, desc = "Previous quickfix list" })
keymap("n", "]q", vim.cmd.cnext, { silent = true, desc = "Next quickfix list" })

-- Undo
--
-- Add undo break-points.
keymap("i", ",", ",<C-g>u", { silent = true })
keymap("i", ".", ".<C-g>u", { silent = true })
keymap("i", ";", ";<C-g>u", { silent = true })

-- Tab
--
keymap("n", "<leader><Tab><Tab>", vim.cmd.tabnew, { silent = true, desc = "New tab" })
keymap("n", "<leader><Tab>d", vim.cmd.tabclose, { silent = true, desc = "Close tab" })
keymap("n", "[<Tab>", vim.cmd.tabprevious, { silent = true, desc = "Previous tab" })
keymap("n", "]<Tab>", vim.cmd.tabnext, { silent = true, desc = "Next tab" })

-- Window
--
keymap("n", "_", function() vim.cmd.wincmd("s") end, { silent = true, desc = "Split window horizontally" })
keymap("n", "|", function() vim.cmd.wincmd("v") end, { silent = true, desc = "Split window vertically" })
keymap("n", "<A-c>", function() vim.cmd.wincmd("c") end, { silent = true, desc = "Close window" })
keymap("n", "<A-h>", function() vim.cmd.wincmd("h") end, { silent = true, desc = "Go to left window" })
keymap("n", "<A-j>", function() vim.cmd.wincmd("j") end, { silent = true, desc = "Go to lower window" })
keymap("n", "<A-k>", function() vim.cmd.wincmd("k") end, { silent = true, desc = "Go to upper window" })
keymap("n", "<A-l>", function() vim.cmd.wincmd("l") end, { silent = true, desc = "Go to right window" })
keymap("n", "<C-h>", "<cmd>vertical resize +2<CR>", { silent = true, desc = "Decrease window width" })
keymap("n", "<C-j>", "<cmd>resize -2<CR>", { silent = true, desc = "Decrease window height" })
keymap("n", "<C-k>", "<cmd>resize +2<CR>", { silent = true, desc = "Increase window height" })
keymap("n", "<C-l>", "<cmd>vertical resize -2<CR>", { silent = true, desc = "Increase window width" })
