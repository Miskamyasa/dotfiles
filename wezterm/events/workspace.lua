local wez = require("wezterm")

-- Setup function to configure workspace and session management
local function setup()
    local req = wez.plugin.require
    local mux = wez.mux

    -- Setup smart workspace switcher plugin
    local sw = req("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
    sw.apply_to_config({})

    -- Setup resurrect plugin for session management
    local r = req("https://github.com/MLFlexer/resurrect.wezterm")
    local sm = r.state_manager

    -- Configure periodic saving
    sm.periodic_save({
        interval_seconds = 180,
        save_workspaces = true,
        save_windows = true,
        save_tabs = true
    })

    -- Add error handling for resurrect plugin
    wez.on("resurrect.error", function(err)
        wez.log_error("ERROR!")
        local gui_windows = wez.gui.gui_windows()
        if #gui_windows > 0 then
            gui_windows[1]:toast_notification("resurrect", err, nil, 3000)
        end
    end)

    -- GUI startup event handling
    wez.on("gui-startup", function()
        sm.resurrect_on_gui_startup()
        local ws = r.workspace_state
        local current_workspace = mux.get_active_workspace()
        sm.save_state(ws.get_workspace_state())
        sm.write_current_state(current_workspace, "workspace")
        -- local tab, pane, window = mux.spawn_window(cmd or {})
        -- window:gui_window():toggle_fullscreen()
        if #mux.all_windows() == 0 then mux.spawn_window(cmd or {}) end
    end)

    -- Enhanced workspace restoration integration with smart workspace switcher
    wez.on("smart_workspace_switcher.workspace_switcher.created",
           function(window, path, label)
        local workspace_state = r.workspace_state

        -- Try to restore the workspace state
        local state = sm.load_state(label, "workspace")
        if state then
            workspace_state.restore_workspace(state, {
                window = window,
                relative = true,
                restore_text = true,
                resize_window = false,
                on_pane_restore = r.tab_state.default_on_pane_restore
            })
        end
    end)

    -- Save workspace state when switching workspaces
    wez.on("smart_workspace_switcher.workspace_switcher.selected",
           function(window, path, label)
        local workspace_state = r.workspace_state
        sm.save_state(workspace_state.get_workspace_state())
        -- This is crucial for gui-startup restoration to work
        sm.write_current_state(label, "workspace")
    end)

    -- Also save current state on window close to ensure we don't lose recent work
    wez.on("window-close-requested", function(window, pane)
        local workspace_state = r.workspace_state
        local current_workspace = window:active_workspace()
        sm.save_state(workspace_state.get_workspace_state())
        sm.write_current_state(current_workspace, "workspace")
        -- Don't return anything - let the default close behavior proceed
    end)
end

return {setup = setup}
