return {
    {
        -- DEPENDENCIES: rg for more features, and grep as fallback.
        "nvim-telescope/telescope.nvim",
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                cond = vim.fn.executable("make") == 1,
                build = "make",
                config = function() require("telescope").load_extension("fzf") end,
            },
        },
        cmd = "Telescope",
        keys = {
            { "<leader>Ff", function() require("telescope.builtin").find_files() end, silent = true, desc = "Find files (Telescope)" },
            { "<leader>Fg", function() require("telescope.builtin").live_grep() end, silent = true, desc = "Live grep (Telescope)" },
            { "<leader>Fb", function() require("telescope.builtin").buffers() end, silent = true, desc = "Buffers (Telescope)" },
            { "<leader>Fh", function() require("telescope.builtin").help_tags() end, silent = true, desc = "Help tags (Telescope)" },
        },
        opts = {
            defaults = {
                mappings = {
                    i = {
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                    },
                },
            },
            pickers = {
                buffers = { theme = "dropdown" },
                colorscheme = {
                    enable_preview = true,
                    previwer = true,
                },
                find_files = { theme = "dropdown" },
                help_tags = {
                    theme = "dropdown",
                    previewer = false,
                },
                live_grep = { theme = "dropdown" },
            },
        },
    },
    { "nvim-lua/plenary.nvim", lazy = true },
    { "nvim-tree/nvim-web-devicons", lazy = true },
    { "nvim-treesitter/nvim-treesitter", lazy = true },
}
