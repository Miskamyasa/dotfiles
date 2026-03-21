local wezterm = require 'wezterm'
local mux = wezterm.mux

local r = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

local sm = r.state_manager

local M = {}
M.setup = function()
    wezterm.on("augment-command-palette", function(_, _)
        return {{
            brief = "Workspace | Save all workspaces",
            icon = "md_content_save_all",
            action = wezterm.action_callback(function()
                local ws = r.workspace_state
                for _, name in ipairs(mux.get_workspace_names()) do
                    local state = ws.get_workspace_state(name)
                    if state then
                        sm.save_state(state, name)
                    end
                end
            end)
        }, {
            brief = "Workspace | Load all workspaces",
            icon = "md_folder_open",
            action = wezterm.action_callback(function()
                local ws = r.workspace_state
                local active_workspaces = mux.get_workspace_names()
                local saved_states = sm.get_state_names("workspace") or {}

                for _, name in ipairs(saved_states) do
                    -- Only restore if workspace is not already active
                    local already_active = false
                    for _, active_name in ipairs(active_workspaces) do
                        if active_name == name then
                            already_active = true
                            break
                        end
                    end

                    if not already_active then
                        local state = sm.load_state(name, "workspace")
                        if state then
                            ws.restore_workspace(state, {
                                spawn_in_workspace = true,
                                relative = true,
                                restore_text = true,
                                on_pane_restore = r.tab_state.default_on_pane_restore
                            })
                        end
                    end
                end
            end)
        }, {
            brief = "Workspace | Create a new named workspace",
            icon = "md_plus_circle",
            action = wezterm.action.PromptInputLine {
                description = "Enter name for new workspace",
                action = wezterm.action_callback(function(window, pane, line)
                    if line and line ~= "" then
                        window:perform_action(wezterm.action.SwitchToWorkspace {
                            name = line
                        }, pane)
                    end
                end)
            }
        }, {
            brief = "Workspace | Rename current workspace",
            icon = "md_form_textbox",
            action = wezterm.action.PromptInputLine {
                description = "Enter new name for current workspace",
                action = wezterm.action_callback(function(inner_window, inner_pane, line)
                    local current_workspace = inner_window:active_workspace()
                    if not line or line == "" or line == current_workspace then
                        return
                    end

                    for _, name in ipairs(mux.get_workspace_names()) do
                        if name == line then
                            inner_window:toast_notification(
                                "Workspace Rename",
                                "Workspace already exists: " .. line,
                                nil,
                                3000
                            )
                            return
                        end
                    end

                    local ok, err = pcall(function()
                        mux.rename_workspace(current_workspace, line)
                    end)

                    if not ok then
                        inner_window:toast_notification(
                            "Workspace Rename",
                            "Failed to rename workspace: " .. tostring(err),
                            nil,
                            4000
                        )
                        return
                    end

                    local state = sm.load_state(current_workspace, "workspace")
                    if state then
                        sm.save_state(state, line)
                        sm.delete_state(current_workspace, "workspace")
                    end

                    sm.write_current_state(line, "workspace")
                    inner_window:toast_notification(
                        "Workspace Rename",
                        "Renamed workspace to: " .. line,
                        nil,
                        3000
                    )
                end)
            }
        }, {
            brief = "Workspace | Delete workspace by name",
            icon = "md_delete",
            action = wezterm.action_callback(function(window, pane)
                local current_workspace = window:active_workspace()
                local workspaces = mux.get_workspace_names()
                local choices = {}

                -- Build choices list, excluding current workspace
                for _, name in ipairs(workspaces) do
                    if name ~= current_workspace then
                        table.insert(choices, {
                            id = name,
                            label = name
                        })
                    end
                end

                if #choices == 0 then
                    window:toast_notification("Workspace Delete",
                        "No workspaces available for deletion (cannot delete active workspace)", nil, 3000)
                    return
                end

                window:perform_action(wezterm.action.InputSelector {
                    action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
                        if id then
                            -- Find all windows in the target workspace and close them
                            local all_windows = mux.all_windows()
                            local panes_to_kill = {}

                            for _, win in ipairs(all_windows) do
                                if win:get_workspace() == id then
                                    local tabs = win:tabs()
                                    for _, tab in ipairs(tabs) do
                                        local panes = tab:panes()
                                        for _, p in ipairs(panes) do
                                            table.insert(panes_to_kill, p)
                                        end
                                    end
                                end
                            end

                            if #panes_to_kill == 0 then
                                inner_window:toast_notification("Workspace Delete",
                                    "No panes found in workspace: " .. id, nil, 3000)
                                return
                            end

                            -- Kill all panes without switching workspaces
                            for _, p in ipairs(panes_to_kill) do
                                -- Send exit command first for graceful shutdown
                                p:send_text("exit\n")
                            end

                            -- After a short delay, force kill any remaining panes
                            wezterm.time.call_after(1.0, function()
                                for _, p in ipairs(panes_to_kill) do
                                    if p:pane_id() then -- Check if pane still exists
                                        -- Try to get the mux pane and kill it
                                        local mux_pane = p:mux_pane()
                                        if mux_pane then
                                            -- Kill the underlying process
                                            local success, _ = pcall(function()
                                                mux_pane:kill()
                                            end)
                                        end
                                    end
                                end

                                -- Remove saved state
                                sm.delete_state(id, "workspace")

                                inner_window:toast_notification("Workspace Delete", "Deleted workspace: " .. id, nil,
                                    3000)
                            end)
                        end
                    end),
                    title = "Select workspace to delete",
                    choices = choices,
                    fuzzy = true
                }, pane)
            end)
        }}
    end)
end

return M
