---@module "lazy"
---@type LazySpec
return {
    "dstein64/nvim-scrollview",
    cmd = { "ScrollViewEnable", "ScrollViewLegend", "ScrollViewToggle" },
    event = { "BufNewFile", "BufReadPost" },
    config = function() vim.g.scrollview_signs_on_startup = { "all" } end,
}
