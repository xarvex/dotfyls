-- TODO: reconfigure
return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        keys = function()
            local keys = {
                { "<leader>h", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end },
                { "<leader>H", function() require("harpoon"):list():add() end },
            }

            for i = 1, 9 do
                keys[#keys + 1] = { string.format("<leader>%s", i), function() require("harpoon"):list():select(i) end }
            end

            return keys
        end,
        opts = {
            settings = { save_on_toggle = true },
        },
    },
    { "nvim-lua/plenary.nvim", lazy = true },
}
