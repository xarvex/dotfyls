---@module "lazy"
---@type LazySpec
return {
    "nvim-mini/mini.icons",
    specs = { { "nvim-tree/nvim-web-devicons", enabled = false, optional = true } },
    lazy = true,
    init = function()
        package.preload["nvim-web-devicons"] = function()
            require("mini.icons").mock_nvim_web_devicons()
            return package.loaded["nvim-web-devicons"]
        end
    end,
    opts = {},
}
