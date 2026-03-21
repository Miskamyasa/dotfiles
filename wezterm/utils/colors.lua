local wezterm = require("wezterm")

local M = {}

-- Light palette matches the current custom look.
local light = {
    tab_bar = {
        background = "#DFDCD8",
        active_tab = {
            italic = false,
            bg_color = "#f4ede5",
            fg_color = "#3b2f2a"
        },
        inactive_tab = {
            italic = false,
            bg_color = "#cdc3bb",
            fg_color = "#2e2a28"
        },
        inactive_tab_hover = {
            italic = false,
            bg_color = "#c7c0ba",
            fg_color = "#2e2a28"
        },
        new_tab = {
            italic = false,
            bg_color = "#d7cfc8",
            fg_color = "#3b2f2a"
        },
        new_tab_hover = {
            italic = false,
            bg_color = "#ece4db",
            fg_color = "#2e2a28"
        }
    },
    right_status = {
        date_fg = "#3E7FB5",
        date_bg = "#DFDCD8",
        battery_fg = "#B52F90",
        battery_bg = "#DFDCD8",
        separator_fg = "#786D22",
        separator_bg = "#DFDCD8"
    }
}

-- Custom dark tab bar derived from the Nightfox palette.
local dark_tab_bar = {
    background = "#192330", -- bg1
    active_tab = {
        italic = false,
        bg_color = "#212e3f", -- bg2
        fg_color = "#d6d6d7" -- fg0
    },
    inactive_tab = {
        italic = false,
        bg_color = "#131a24", -- bg0
        fg_color = "#cdcecf" -- fg1
    },
    inactive_tab_hover = {
        italic = false,
        bg_color = "#1f2940", -- bg3-ish
        fg_color = "#e4e4e5" -- lighter fg
    },
    new_tab = {
        italic = false,
        bg_color = "#192330",
        fg_color = "#cdcecf"
    },
    new_tab_hover = {
        italic = false,
        bg_color = "#212e3f",
        fg_color = "#e4e4e5"
    }
}

local builtin = wezterm.color.get_builtin_schemes()

local function palette_from_scheme(name, fallback)
    local scheme = builtin[name] or {}
    local tab_bar = scheme.tab_bar or fallback.tab_bar
    local bg = (tab_bar and tab_bar.background) or scheme.background or fallback.right_status.date_bg
    local ansi = scheme.ansi or {}

    local right_status = {
        date_fg = ansi[5] or fallback.right_status.date_fg,
        date_bg = bg,
        battery_fg = ansi[6] or fallback.right_status.battery_fg,
        battery_bg = bg,
        separator_fg = ansi[3] or fallback.right_status.separator_fg,
        separator_bg = bg
    }

    return {
        tab_bar = tab_bar,
        right_status = right_status
    }
end

function M.get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return "Dark"
end

function M.scheme_for_appearance(appearance)
    if appearance:find("Dark") then
        return "nightfox"
    end
    return "dayfox"
end

function M.palette_for_appearance(appearance)
    if appearance:find("Dark") then
        return {
            tab_bar = dark_tab_bar,
            right_status = palette_from_scheme("nightfox", {
                tab_bar = dark_tab_bar,
                right_status = light.right_status
            }).right_status
        }
    end
    return light
end

-- Apply tab bar and color scheme overrides to a window based on its appearance.
function M.apply_to_window(window)
    local appearance = window:get_appearance()
    local palette = M.palette_for_appearance(appearance)

    local overrides = window:get_config_overrides() or {}
    overrides.colors = overrides.colors or {}
    overrides.colors.tab_bar = palette.tab_bar
    overrides.colors.split = "transparent"
    overrides.color_scheme = M.scheme_for_appearance(appearance)

    window:set_config_overrides(overrides)
    return palette
end

return M
