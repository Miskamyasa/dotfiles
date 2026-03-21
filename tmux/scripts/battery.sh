#!/bin/bash

# Battery icons for different states and charge levels
discharging_icons=("󰂃" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
charging_icons=("󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅")

# Get battery info using pmset on macOS
if command -v pmset &> /dev/null; then
    battery_info=$(pmset -g batt | grep -E "([0-9]+\%)" | head -1)
    
    # Extract charge percentage
    charge=$(echo "$battery_info" | grep -o '[0-9]*%' | sed 's/%//')
    
    # Determine if charging
    if echo "$battery_info" | grep -q "AC Power"; then
        is_charging=true
    else
        is_charging=false
    fi
    
    # Calculate icon index (1-10 based on charge level)
    idx=$(( (charge + 9) / 10 ))
    if [ $idx -lt 1 ]; then idx=1; fi
    if [ $idx -gt 10 ]; then idx=10; fi
    
    # Select appropriate icon
    if [ "$is_charging" = true ]; then
        icon=${charging_icons[$((idx-1))]}
    else
        icon=${discharging_icons[$((idx-1))]}
    fi
    
    echo "${icon} ${charge}%"
else
    echo "🔋 N/A"
fi