-- https://wezfurlong.org/wezterm/config/lua/window-events/user-var-changed.html
require("wezterm").on("user-var-changed", function(window, pane, name, value)
    if name == "neovim_colorscheme" then
        local overrides = window:get_config_overrides() or {}
        overrides.color_scheme = value
        window:set_config_overrides(overrides)
    end
end)

return {
    ---@param config table
    apply_to_config = function(config)
        local file = io.open(require("wezterm").config_dir .. "/generated/neovim_colorscheme", "r")
        if file then
            local colorscheme = file:read("*l") -- read first line without newline
            file:close()
            config.color_scheme = colorscheme
        else
            config.color_scheme = "carbonfox" -- default
        end
    end,
}
