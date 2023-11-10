local wezterm = require("wezterm")
local util = require("util")

local M = wezterm.config_builder and wezterm.config_builder() or {}

M.check_for_updates = false

M.color_scheme = "Tomorrow Night Eighties"
M.colors = {
    background = "black",
    tab_bar = { inactive_tab_edge = "black" }
}

M.window_background_opacity = 0.4

local font = "Iosevka Term SS14"

M.font = wezterm.font(font, { stretch = "SemiExpanded" })
M.font_size = 14.0

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
-- nice retro bar, but only works with one theme
-- wezterm.plugin.require("https://github.com/nekowinston/wezterm-bar").apply_to_config(M)

return M
