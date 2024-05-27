local wezterm = require("wezterm")
local util = require("util")

local M = wezterm.config_builder and wezterm.config_builder() or {}

M.check_for_updates = false

-- colorscheme sync with Neovim
local file = io.open(wezterm.config_dir .. "/generated_neovim_colorscheme", "r")
if file then
    M.color_scheme = file:read("*l") -- read first line without newline
    file:close()
else
    M.color_scheme = "carbonfox" -- default
end

M.enable_tab_bar = false

M.window_background_opacity = 0.85

local font = "Iosevka Term SS14"

M.font = wezterm.font(font, { stretch = "SemiExpanded" })
M.font_size = 14.0

M.warn_about_missing_glyphs = false

M.window_frame = {
    font = wezterm.font(font, { stretch = "SemiExpanded", weight = "Bold" }),
    font_size = 12.0,
    active_titlebar_bg = "black",
    inactive_titlebar_bg = "black"
}

M.keys = require("remap")

-- if SSH domains are available, require it
if util.module_available("ssh") then M.ssh_domains = require("ssh") end

wezterm.plugin.require("https://gitlab.com/xarvex/presentation.wez").apply_to_config(M, {
    presentation = { font_size_multiplier = 1.8 },
    presentation_full = { font_size_multiplier = 2.2 }
})

return M
