local wezterm = require("wezterm")
local math = require("utils.math")
local palettes = require("utils.colors")
local M = {}

M.separator_char = " "

M.colors = palettes.palette_for_appearance(palettes.get_appearance()).right_status
M.last_appearance = nil

M.cells = {} -- wezterm FormatItems (ref: https://wezfurlong.org/wezterm/config/lua/wezterm/format.html)

---@param text string
---@param icon string
---@param fg string
---@param bg string
---@param separate boolean
M.push = function(text, icon, fg, bg, separate)
    table.insert(M.cells, {
        Foreground = {
            Color = fg
        }
    })
    table.insert(M.cells, {
        Background = {
            Color = bg
        }
    })
    table.insert(M.cells, {
        Attribute = {
            Intensity = "Bold"
        }
    })
    table.insert(M.cells, {
        Text = icon .. " " .. text .. " "
    })

    if separate then
        table.insert(M.cells, {
            Foreground = {
                Color = M.colors.separator_fg
            }
        })
        table.insert(M.cells, {
            Background = {
                Color = M.colors.separator_bg
            }
        })
        table.insert(M.cells, {
            Text = M.separator_char
        })
    end

    table.insert(M.cells, "ResetAttributes")
end

M.set_date = function()
    local date = wezterm.strftime("%a, %b%e · %I:%M %p")
    M.push(date, " ", M.colors.date_fg, M.colors.date_bg, true)
end

M.set_battery = function()
    -- ref: https://wezfurlong.org/wezterm/config/lua/wezterm/battery_info.html
    local discharging_icons = {"󰂃", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"}
    local charging_icons = {"󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"}

    local charge = ""
    local icon = ""

    for _, b in ipairs(wezterm.battery_info()) do
        local idx = math.clamp(math.round(b.state_of_charge * 10), 1, 10)
        charge = string.format("%.0f%%", b.state_of_charge * 100)

        if b.state == "Charging" then
            icon = charging_icons[idx]
        else
            icon = discharging_icons[idx]
        end
    end

    M.push(charge, icon, M.colors.battery_fg, M.colors.battery_bg, false)
end

M.set_workspace = function(window)
    local workspace = window and window:active_workspace() or nil
    if not workspace or workspace == "" then
        return
    end
    local fg = M.colors.workspace_fg or M.colors.date_fg
    local bg = M.colors.workspace_bg or M.colors.date_bg
    M.push(workspace, "󰙅 ", fg, bg, true)
end

M.set_cwd = function(window)
    if not window then
        return
    end
    local pane = window:active_pane()
    if not pane then
        return
    end
    local cwd_uri = pane:get_current_working_dir()
    if not cwd_uri then
        return
    end

    local cwd = cwd_uri.file_path or cwd_uri.path or cwd_uri
    if type(cwd) ~= "string" then
        cwd = tostring(cwd)
    end
    if not cwd or cwd == "" then
        return
    end

    cwd = cwd:gsub("^file://", "")
    cwd = cwd:gsub("/+$", "")
    if cwd == "" then
        cwd = "/"
    end

    local segments = {}
    for part in string.gmatch(cwd, "[^/]+") do
        table.insert(segments, part)
    end
    local short = "/"
    local total = #segments
    if total > 0 then
        local start_idx = math.max(total - 1, 1)
        short = table.concat(segments, "/", start_idx, total)
    end

    local fg = M.colors.cwd_fg or M.colors.workspace_fg or M.colors.date_fg
    local bg = M.colors.cwd_bg or M.colors.workspace_bg or M.colors.date_bg
    M.push("" .. short .. "", " ", fg, bg, true)
end

M.setup = function()
    wezterm.on("update-right-status", function(window, _pane)
        local appearance = palettes.get_appearance()
        if window and window.get_appearance then
            appearance = window:get_appearance()
        end

        if appearance ~= M.last_appearance and window then
            palettes.apply_to_window(window)
            M.last_appearance = appearance
        end

        M.colors = palettes.palette_for_appearance(appearance).right_status

        M.cells = {}
        M.set_cwd(window)
        M.set_workspace(window)
        M.set_date()
        M.set_battery()

        window:set_right_status(wezterm.format(M.cells))
    end)
end

return M
