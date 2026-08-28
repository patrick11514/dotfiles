#!/bin/bash

EPP_FILE="/sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference"

if [ ! -f "$EPP_FILE" ]; then
    echo "{\"text\": \"N/A\", \"tooltip\": \"CPU EPP not supported\", \"class\": \"error\"}"
    exit 0
fi

# Get current EPP profile
current=$(cat "$EPP_FILE")

if [ "$1" == "toggle" ]; then
    case "$current" in
        "power"|"balance_power") next="balance_performance" ;;
        "balance_performance")   next="performance" ;;
        "performance")           next="power" ;;
        *)                       next="balance_performance" ;;
    esac
    
    # Try writing with sudo tee without password if configured, or pkexec fallback
    if ! echo "$next" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference > /dev/null 2>&1; then
        pkexec sh -c "echo $next | tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference" > /dev/null 2>&1
    fi
    
    # Read again to confirm change source of truth
    current=$(cat "$EPP_FILE")
fi

# Determine icon and text based on current profile
case "$current" in
    "power"|"balance_power")
        text="Power"
        tooltip="Power Saving Mode (EPP: $current)"
        icon=" "
        class="low-power"
    ;;
    "balance_performance"|"default")
        text="Bal"
        tooltip="Balanced Mode (EPP: $current)"
        icon=" "
        class="balanced"
    ;;
    "performance")
        text="Perf"
        tooltip="Performance Mode (EPP: $current)"
        icon=""
        class="performance"
    ;;
    *)
        text="$current"
        tooltip="Unknown profile: $current"
        icon=" "
        class="unknown"
    ;;
esac

# Output JSON for Waybar
echo "{\"text\": \"$icon\", \"tooltip\": \"$tooltip\", \"alt\": \"$current\", \"class\": \"$class\" }"
