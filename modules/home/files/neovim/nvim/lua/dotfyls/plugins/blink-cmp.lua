---@module "lazy"
---@type LazySpec
return {
    {
        "Saghen/blink.cmp",
        cond = vim.fn.executable("nix") == 1 or vim.fn.executable("cargo") == 1,
        build = "sh -c '(unset CARGO_TARGET_DIR && "
            .. (vim.fn.executable("nix") == 1 and "nix run .#build-plugin --override-input nixpkgs nixpkgs" or "cargo build --release")
            .. ")'",
        dependencies = {
            "f3fora/cmp-spell",
            "uga-rosa/cmp-dictionary",
        },
        event = { "CmdlineEnter", "InsertEnter" },
        opts = function()
            ---@module "blink.cmp"
            ---@param ctx blink.cmp.Context
            ---@param items blink.cmp.CompletionItem[]
            ---@return blink.cmp.CompletionItem[]
            local function transform_items_capitalization(ctx, items)
                local keyword = ctx.get_keyword()
                local correct, case
                if keyword:match("^%l") then
                    correct = "^%u%l+$"
                    case = string.lower
                elseif keyword:match("^%u") then
                    correct = "^%l+$"
                    case = string.upper
                else
                    return items
                end

                local seen = {}
                local out = {}
                for _, item in ipairs(items) do
                    local insertText = item.insertText
                    if insertText ~= nil then
                        if insertText:match(correct) then
                            local text = case(insertText:sub(1, 1)) .. insertText:sub(2)
                            item.insertText = text
                            item.label = text
                        elseif not seen[insertText] then
                            seen[insertText] = true
                            table.insert(out, item)
                        end
                    end
                end

                return out
            end

            ---@module "blink.cmp"
            ---@param _ctx blink.cmp.Context
            ---@param items blink.cmp.CompletionItem[]
            ---@param label string
            ---@return blink.cmp.CompletionItem[]
            ---@diagnostic disable-next-line: unused-local
            local function transform_items_label(_ctx, items, label)
                for _, item in ipairs(items) do
                    if label ~= nil then item.labelDetails = { description = "(" .. label .. ")" } end
                end

                return items
            end

            ---@module "blink.cmp"
            ---@type blink.cmp.Config
            return {
                appearance = {
                    use_nvim_cmp_as_default = true,
                    nerd_font_variant = "mono",
                },
                completion = {
                    list = {
                        selection = {
                            preselect = function(ctx) return ctx.mode ~= "cmdline" end,
                            auto_insert = false,
                        },
                    },
                    accept = { auto_brackets = { enabled = true } },
                    menu = {
                        draw = {
                            treesitter = { "lsp" },
                            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
                            components = {
                                kind_icon = {
                                    ellipsis = false,
                                    text = function(ctx) return require("lspkind").symbolic(ctx.kind, { mode = "symbol" }) end,
                                },
                                label = {
                                    text = require("colorful-menu").blink_components_text,
                                    highlight = require("colorful-menu").blink_components_highlight,
                                },
                                label_description = {
                                    text = function(ctx)
                                        if ctx.source_id == "lsp" then
                                            local label = require("colorful-menu").blink_highlights(ctx).label
                                            if
                                                label ~= ctx.label
                                                or label == ctx.label_description
                                                or ctx.label == ctx.label_description
                                            then
                                                return nil
                                            end
                                        end
                                        return ctx.label_description
                                    end,
                                },
                            },
                        },
                    },
                    documentation = { auto_show = true, auto_show_delay_ms = 100 },
                    ghost_text = { enabled = true },
                },
                fuzzy = { prebuilt_binaries = { download = false } },
                keymap = {
                    preset = "none",
                    ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
                    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
                    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
                    ["<C-j>"] = { "select_next", "fallback" },
                    ["<C-k>"] = { "select_prev", "fallback" },
                    ["<CR>"] = { "accept", "fallback" },
                    ["<C-CR>"] = {
                        function()
                            require("blink.cmp").cancel({
                                callback = function()
                                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "m", false)
                                end,
                            })
                        end,
                    },
                    ["<Tab>"] = { "snippet_forward", "fallback" },
                    ["<S-Tab>"] = { "snippet_backward", "fallback" },
                },
                -- signature = { enabled = true },
                sources = {
                    default = { "lsp", "path", "snippets", "buffer", "ripgrep", "dictionary", "spell" },
                    per_filetype = {
                        lua = { "lazydev", "lsp", "path", "snippets", "buffer", "ripgrep", "dictionary", "spell" },
                    },
                    providers = {
                        lazydev = {
                            name = "LazyDev",
                            module = "lazydev.integrations.blink",
                            score_offset = 100,
                        },
                        lsp = { score_offset = 3 },
                        path = {
                            opts = {
                                trailing_slash = false,
                                label_trailing_slash = false,
                            },
                            score_offset = 10,
                        },
                        snippets = { score_offset = 1 },
                        buffer = {
                            transform_items = function(ctx, items)
                                return transform_items_label(ctx, transform_items_capitalization(ctx, items), "buf")
                            end,
                            min_keyword_length = 3,
                        },
                        ripgrep = {
                            module = "blink-ripgrep",
                            name = "Ripgrep",
                            ---@module "blink-ripgrep"
                            ---@type blink-ripgrep.Options
                            opts = { prefix_min_len = 3 },
                            async = true,
                            transform_items = function(ctx, items)
                                return transform_items_label(ctx, transform_items_capitalization(ctx, items), "rg")
                            end,
                            min_keyword_length = 3,
                        },
                        dictionary = {
                            name = "dictionary",
                            module = "blink.compat.source",
                            transform_items = function(ctx, items)
                                return transform_items_label(ctx, transform_items_capitalization(ctx, items), "dict")
                            end,
                            min_keyword_length = 3,
                        },
                        spell = {
                            name = "spell",
                            module = "blink.compat.source",
                            transform_items = function(ctx, items)
                                return transform_items_label(ctx, transform_items_capitalization(ctx, items), "spell")
                            end,
                            min_keyword_length = 3,
                        },
                    },
                },
                snippets = { preset = "luasnip" },
            }
        end,
    },
    { "Saghen/blink.compat", lazy = true, opts = { impersonate_nvim_cmp = true, debug = true } },
    { "mikavilpas/blink-ripgrep.nvim", lazy = true },
    { "onsails/lspkind.nvim", lazy = true },
    { "rafamadriz/friendly-snippets", lazy = true },
}
