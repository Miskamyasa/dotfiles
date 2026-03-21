local wez = require("wezterm")

local palettes = require("utils.colors")

local config = wez.config_builder()
local act = wez.action

config.use_fancy_tab_bar = false

config.default_cursor_style = 'SteadyBlock'

config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"

config.native_macos_fullscreen_mode = true

config.scrollback_lines = 3000

config.window_padding = {
    left = 8,
    right = 8,
    top = 14,
    bottom = 6
}

local appearance = palettes.get_appearance()
local palette = palettes.palette_for_appearance(appearance)

config.colors = {
    tab_bar = palette.tab_bar
}
config.color_scheme = palettes.scheme_for_appearance(appearance)

do
    local inactive_tab = palette.tab_bar and palette.tab_bar.inactive_tab
    config.command_palette_bg_color = (inactive_tab and inactive_tab.bg_color) or "#1c1c1c"
    config.command_palette_fg_color = (inactive_tab and inactive_tab.fg_color) or "#c0c0c0"
end

config.tab_max_width = 64

require("commands").setup()
require("fonts").setup(config)
require("keys").setup(config)

require("events.right-status").setup()
require("events.tab-title").setup({
    prepend_index = true
})
require("events.new-tab-button").setup()
require("events.workspace").setup()

return config
