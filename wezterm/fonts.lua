local wez = require("wezterm")

local M = {}

M.setup = function(config)
    config.font_size = 14.0
    config.font = wez.font {
        family = 'ZedMono Nerd Font',
        weight = 'Medium',
        italic = false
    }

    config.font_rules = {{
        intensity = 'Bold',
        italic = false,
        font = wez.font('ZedMono Nerd Font', {
            weight = 'Bold',
            italic = false
        })
    }, {
        intensity = 'Half',
        italic = false,
        font = wez.font('ZedMono Nerd Font', {
            weight = 'Medium',
            italic = false
        })
    }, {
        intensity = 'Normal',
        italic = false,
        font = wez.font('ZedMono Nerd Font', {
            weight = 'Medium',
            italic = false
        })
    }, {
        intensity = 'Bold',
        italic = true,
        font = wez.font('ZedMono Nerd Font', {
            weight = 'Bold',
            italic = false
        })
    }, {
        intensity = 'Half',
        italic = true,
        font = wez.font('ZedMono Nerd Font', {
            weight = 'Medium',
            italic = false
        })
    }, {
        intensity = 'Normal',
        italic = true,
        font = wez.font('ZedMono Nerd Font', {
            weight = 'Medium',
            italic = false
        })
    }}
end

return M
