local M = require("wezterm").config_builder and require("wezterm").config_builder() or {}

require("colorscheme").apply_to_config(M)
require("font").apply_to_config(M)
require("keys").apply_to_config(M)

M.check_for_updates = false

M.enable_tab_bar = false

M.warn_about_missing_glyphs = false

M.window_background_opacity = 0.85
M.window_frame = {
    font = require("font").get("Bold"),
    font_size = 12.0,
    active_titlebar_bg = "black",
    inactive_titlebar_bg = "black"
}

require("wezterm").plugin.require("https://gitlab.com/xarvex/presentation.wez").apply_to_config(M, {
    presentation = { font_size_multiplier = 1.8 },
    presentation_full = { font_size_multiplier = 2.2 }
})

return M
