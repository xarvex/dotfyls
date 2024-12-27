-- TODO: figure out duplicate text entries
return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "onsails/lspkind.nvim",
        },
        cmd = "CmpStatus",
        event = { "CmdlineEnter", "InsertEnter" },
        config = function()
            local function fallback_confirm(fallback)
                local opts

                if require("cmp").visible() then
                    if require("cmp").get_selected_entry() then
                        opts = { select = false, behavior = require("cmp").ConfirmBehavior.Replace }
                    else
                        local entries = require("cmp").get_entries()
                        if #entries == 1 or (#entries > 0 and entries[1].exact) then opts = { select = true } end
                    end
                end

                if opts then
                    require("cmp").confirm(opts)
                else
                    fallback()
                end
            end
            local function fallback_jump(fallback, direction)
                if require("luasnip").locally_jumpable(direction) then
                    require("luasnip").jump(direction)
                elseif vim.snippet.active({ direction = direction }) then
                    vim.snippet.jump(direction)
                else
                    fallback()
                end
            end
            local mapping = {
                ["<C-Space>"] = require("cmp").mapping(require("cmp").mapping.complete(), { "c", "i" }),
                ["<C-d>"] = require("cmp").mapping(require("cmp").mapping.scroll_docs(4), { "c", "i" }),
                ["<C-u>"] = require("cmp").mapping(require("cmp").mapping.scroll_docs(-4), { "c", "i" }),
                ["<C-j>"] = require("cmp").mapping(require("cmp").mapping.select_next_item(), { "c", "i" }),
                ["<C-k>"] = require("cmp").mapping(require("cmp").mapping.select_prev_item(), { "c", "i" }),
                ["<CR>"] = require("cmp").mapping({
                    c = fallback_confirm,
                    i = fallback_confirm,
                    s = require("cmp").mapping.confirm({ select = true }),
                }),
                ["<Tab>"] = require("cmp").mapping({
                    c = function(fallback) fallback() end,
                    i = function(fallback) fallback_jump(fallback, 1) end,
                    s = function(fallback) fallback_jump(fallback, 1) end,
                }),
                ["<S-Tab>"] = require("cmp").mapping({
                    c = function() end,
                    i = function(fallback) fallback_jump(fallback, -1) end,
                    s = function(fallback) fallback_jump(fallback, -1) end,
                }),
            }
            local experimental = { ghost_text = true }
            require("cmp").setup({
                entries = { name = "custom", selection_order = "near_cursor" },
                ---@diagnostic disable-next-line: missing-fields
                formatting = { format = require("lspkind").cmp_format() },
                sources = require("cmp").config.sources({
                    { name = "nvim_lsp", priority = 100 },
                    { name = "luasnip", priority = 20 },
                    { name = "rg", priority = 70 },
                    { name = "path", priority = 100 },
                    { name = "nerdfont", priority = 60, insert = true },
                    { name = "emoji", priority = 60, insert = true },
                    { name = "nvim_lua", priority = 50 },
                    { name = "nvim_lsp_document_symbol", priority = 80 },
                }, {
                    { name = "buffer", priority = 50, keyword_length = 3 },
                    { name = "spell", priority = 40, keyword_length = 3 },
                    { name = "calc", priority = 50 },
                    { name = "treesitter", priority = 30 },
                    { name = "dictionary", priority = 10, keyword_length = 3 },
                }, { { name = "lazydev", group_index = 0 }, { name = "crates", group_index = 0 } }),
                mapping = mapping,
                snippet = {
                    expand = function(args) require("luasnip").lsp_expand(args.body) end,
                },
                experimental = experimental,
            })
            require("cmp").setup.cmdline({ "/", "?" }, {
                sources = { { name = "nvim_lsp_document_symbol" }, { name = "buffer", keyword_length = 3 } },
                mapping = mapping,
                experimental = experimental,
            })
            require("cmp").setup.cmdline(":", {
                sources = require("cmp").config.sources({ { name = "cmdline" } }, { { name = "path", keyword_length = 3 } }),
                mapping = mapping,
                ---@diagnostic disable-next-line: missing-fields
                matching = { disallow_symbol_nonprefix_matching = false },
                experimental = experimental,
            })
        end,
    },
    { "chrisgrieser/cmp-nerdfont", event = "InsertEnter" },
    { "f3fora/cmp-spell", event = "InsertEnter" },
    { "hrsh7th/cmp-calc", event = "InsertEnter" },
    { "hrsh7th/cmp-cmdline", event = "CmdlineEnter" },
    { "hrsh7th/cmp-emoji", event = "InsertEnter" },
    { "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
    { "hrsh7th/cmp-nvim-lsp-document-symbol", event = "InsertEnter" },
    { "hrsh7th/cmp-nvim-lua", event = "InsertEnter" },
    { "lukas-reineke/cmp-rg", event = "InsertEnter" },
    { "ray-x/cmp-treesitter", event = "InsertEnter" },
    { "saadparwaiz1/cmp_luasnip", event = "InsertEnter" },
    { "uga-rosa/cmp-dictionary", event = "InsertEnter" },
}
