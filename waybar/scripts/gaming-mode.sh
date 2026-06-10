#!/bin/bash

STATE_FILE="/tmp/gaming-mode"

# Clean stale backups only when returning to normal state
cleanup_stale_backups() {
    for f in "$HOME/.config/omarchy/current/theme/"*.bak; do
        [[ -f $f ]] && rm -f "$f"
    done
}
HYPRLAND_CONF="$HOME/.config/omarchy/current/theme/hyprland.conf"
HYPRLAND_CONF_BAK="$HOME/.config/omarchy/current/theme/hyprland.conf.bak"
WALKER_CSS="$HOME/.config/omarchy/current/theme/walker.css"
WALKER_CSS_BAK="$HOME/.config/omarchy/current/theme/walker.css.bak"
WAYBAR_CSS="$HOME/.config/omarchy/current/theme/waybar.css"
WAYBAR_CSS_BAK="$HOME/.config/omarchy/current/theme/waybar.css.bak"

HEAVY_PROCS=("firefox" "chromium" "chromium-browser" "chrome" "brave" "electron" "steam" "discord" "slack" "teams" "code" "obsidian" "thunderbird")

suspend_apps() {
    for proc in "${HEAVY_PROCS[@]}"; do
        pkill -STOP -x "$proc" 2>/dev/null || true
    done
}

resume_apps() {
    for proc in "${HEAVY_PROCS[@]}"; do
        pkill -CONT -x "$proc" 2>/dev/null || true
    done
}

count_suspended() {
    local count=0
    for proc in "${HEAVY_PROCS[@]}"; do
        if pgrep -x "$proc" >/dev/null 2>&1; then
            pid=$(pgrep -x "$proc" 2>/dev/null | head -1)
            if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
                state=$(ps -o state= -p "$pid" 2>/dev/null)
                [[ "$state" == "T" ]] && count=$((count + 1))
            fi
        fi
    done
    echo "$count"
}

gaming_hyprland() {
    cp "$HYPRLAND_CONF" "$HYPRLAND_CONF_BAK"
    sed -i \
        -e 's/rounding = 14/rounding = 0/' \
        -e 's/active_opacity = 0.95/active_opacity = 1.0/' \
        -e 's/inactive_opacity = 0.95/inactive_opacity = 1.0/' \
        -e '/blur {/,/^    }/s/enabled = true/enabled = false/' \
        "$HYPRLAND_CONF"
    echo 'windowrule = opacity 1.0 override 1.0 override' >> "$HYPRLAND_CONF"
    hyprctl reload
}

normal_hyprland() {
    if [ -f "$HYPRLAND_CONF_BAK" ]; then
        cp "$HYPRLAND_CONF_BAK" "$HYPRLAND_CONF"
        rm -f "$HYPRLAND_CONF_BAK"
        hyprctl reload
    fi
}

gaming_walker() {
    cp "$WALKER_CSS" "$WALKER_CSS_BAK"
    sed -i \
        -e 's/border-radius: 28px;/border-radius: 0px;/g' \
        -e 's/border-radius: 10px;/border-radius: 0px;/g' \
        "$WALKER_CSS"
    omarchy-restart-walker 2>/dev/null || true
}

normal_walker() {
    if [ -f "$WALKER_CSS_BAK" ]; then
        cp "$WALKER_CSS_BAK" "$WALKER_CSS"
        rm -f "$WALKER_CSS_BAK"
        omarchy-restart-walker 2>/dev/null || true
    fi
}

gaming_waybar() {
    cp "$WAYBAR_CSS" "$WAYBAR_CSS_BAK"
    sed -i \
        -e 's/alpha(@background, [^)]*)/@background/g' \
        -e 's/alpha(@cyan, [^)]*)/@cyan/g' \
        -e 's/alpha(@magenta, [^)]*)/@magenta/g' \
        "$WAYBAR_CSS"
}

normal_waybar() {
    if [ -f "$WAYBAR_CSS_BAK" ]; then
        cp "$WAYBAR_CSS_BAK" "$WAYBAR_CSS"
        rm -f "$WAYBAR_CSS_BAK"
    fi
}

if [ "$1" = "--status" ]; then
    if [ -f "$STATE_FILE" ]; then
        suspended=$(count_suspended)
        tooltip=" Gaming Mode: ON\n"
        tooltip+="━━━━━━━━━━━━━━━━━━\n"
        tooltip+="󰄱 Blur: disabled\n"
        tooltip+="󰕿 Rounding: disabled\n"
        tooltip+="󰤂 Transparency: forced opaque (all windows)\n"
        tooltip+="󰁅 Gaps: unchanged\n"
        tooltip+="󰘓 Walker: no rounding\n"
        tooltip+="󰾲 Apps suspended: $suspended\n"
        tooltip+="━━━━━━━━━━━━━━━━━━\n"
        tooltip+="󰐥 Click to disable"
        echo "{\"text\": \"\", \"alt\": \"gaming\", \"tooltip\": \"$tooltip\", \"class\": \"gaming\"}"
    else
        tooltip=" Gaming Mode: OFF\n"
        tooltip+="━━━━━━━━━━━━━━━━━━\n"
        tooltip+="󰄱 Blur: enabled\n"
        tooltip+="󰕿 Rounding: enabled\n"
        tooltip+="󰤂 Transparency: normal\n"
        tooltip+="󰁅 Gaps: 5 / 8\n"
        tooltip+="󰘓 Walker: normal\n"
        tooltip+="━━━━━━━━━━━━━━━━━━\n"
        tooltip+="󰐥 Click to enable"
        echo "{\"text\": \"\", \"alt\": \"default\", \"tooltip\": \"$tooltip\", \"class\": \"default\"}"
    fi
    exit 0
fi

if [ -f "$STATE_FILE" ]; then
    rm -f "$STATE_FILE"
    normal_hyprland
    resume_apps
    normal_walker
    normal_waybar
    cleanup_stale_backups
    notify-send "Gaming Mode" "Off — restored to normal" -t 1500
else
    cleanup_stale_backups
    touch "$STATE_FILE"
    gaming_hyprland
    suspend_apps
    gaming_walker
    gaming_waybar
    notify-send "Gaming Mode" "On — maximum performance, all opacity removed" -t 2000
fi
