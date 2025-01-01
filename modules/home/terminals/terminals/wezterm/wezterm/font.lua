local function get(weight) return require("wezterm").font("Iosevka Term SS14", { stretch = "SemiExpanded", weight = weight }) end

return {
    get = get,
    ---@param config table
    apply_to_config = function(config)
        config.font = get()
        config.font_size = 14.0
    end,
}
