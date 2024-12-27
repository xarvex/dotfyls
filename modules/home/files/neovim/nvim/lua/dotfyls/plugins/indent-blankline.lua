-- TODO: reconfigure
return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "LspAttach",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
}
