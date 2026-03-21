local wezterm = require 'wezterm'
local act = wezterm.action
local M = {}

M.setup = function(config)
    config.keys = {{
        -- Cmd+T: New tab
        mods = "SUPER",
        key = "t",
        action = act.SpawnTab "CurrentPaneDomain"
    }, {
        -- Cmd+W closes just the focused pane, not the whole tab
        mods = "SUPER",
        key = "w",
        action = act.CloseCurrentPane {
            confirm = false
        }
    }, {
        -- Cmd+D: Split pane right
        mods = "SUPER",
        key = "d",
        action = act.SplitHorizontal {
            domain = 'CurrentPaneDomain'
        }
    }, {
        -- Cmd+Shift+D: Split pane down
        mods = "SUPER|SHIFT",
        key = "d",
        action = act.SplitVertical {
            domain = 'CurrentPaneDomain'
        }
    }, {
        mods = 'SUPER',
        key = 'LeftArrow',
        action = act.ActivatePaneDirection 'Left'
    }, {
        mods = 'SUPER',
        key = 'RightArrow',
        action = act.ActivatePaneDirection 'Right'
    }, {
        mods = 'SUPER',
        key = 'DownArrow',
        action = act.ActivatePaneDirection 'Down'
    }, {
        mods = 'SUPER',
        key = 'UpArrow',
        action = act.ActivatePaneDirection 'Up'
    }, {
        -- Cmd+E: Pane swap (with number overlay)
        mods = "SUPER",
        key = "e",
        action = act.PaneSelect {
            alphabet = "1234567890",
            mode = "SwapWithActive"
        }
    }, {
        -- Cmd+Shift+K to clear scrollback and viewport
        mods = "SUPER|SHIFT",
        key = 'K',
        action = act.ClearScrollback 'ScrollbackAndViewport'
    }, {
        -- Cmd+Shift+R to rename tab
        mods = "SUPER|SHIFT",
        key = "r",
        action = act.PromptInputLine {
            description = "Enter new name for tab",
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end)
        }
    }, {
        -- Cmd+Shift+O: Smart workspace switcher (fuzzy workspaces)
        mods = "SUPER|SHIFT",
        key = "o",
        action = act.ShowLauncherArgs {
            flags = "FUZZY|WORKSPACES"
        }
    }, {
        -- Cmd+Shift+P: Command palette
        mods = 'SUPER|SHIFT',
        key = 'p',
        action = act.ActivateCommandPalette
    }, {
        -- Cmd+Shift+L: Launcher
        mods = "SUPER|SHIFT",
        key = "l",
        action = act.ShowLauncher
    }}
end

return M
