local M = require("wezterm").config_builder and require("wezterm").config_builder() or {}

M.check_for_updates = false

M.color_scheme = "carbonfox"

M.enable_kitty_keyboard = true
M.enable_tab_bar = false

M.font = require("wezterm").font("monospace")

M.warn_about_missing_glyphs = false

M.window_frame = {
    font = require("wezterm").font("monospace", { weight = "Bold" }),
    active_titlebar_bg = "black",
    inactive_titlebar_bg = "black",
}

require("wezterm").plugin.require("https://gitlab.com/xarvex/presentation.wez").apply_to_config(M, {
    presentation = { font_size_multiplier = 1.8 },
    presentation_full = { font_size_multiplier = 2.2 },
})

local has_nix, nix = pcall(require, "nix")
if has_nix then nix.apply_to_config(M) end

return M
