local wezterm = require("wezterm")

local config = wezterm.config_builder()

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "nightfox"
	else
		return "dawnfox"
	end
end

config = {
	animation_fps = 15,
	automatically_reload_config = true,
	color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
	cursor_blink_rate = 450,
	enable_tab_bar = false,
	default_cursor_style = "BlinkingUnderline",
	font = wezterm.font("CommitMono"),
	font_size = 16.0,
	line_height = 1.3,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
}

return config
