#!/bin/bash

PROFILE_FILE="/sys/firmware/acpi/platform_profile"

if [ ! -f "$PROFILE_FILE" ]; then
    echo "{\"text\": \"N/A\", \"tooltip\": \"Profile not supported\", \"class\": \"error\"}"
    exit 0
fi

# Get current profile
current=$(cat "$PROFILE_FILE")

if [ "$1" == "toggle" ]; then
    case "$current" in
        "low-power") next="balanced" ;;
        "balanced") next="performance" ;;
        "performance") next="low-power" ;;
        *) next="balanced" ;;
    esac
    
    # Try to write using sudo tee without password if configured, or pkexec as fallback
    if [ ! -w "$PROFILE_FILE" ]; then
        echo "$next" | sudo tee "$PROFILE_FILE" > /dev/null 2>&1 || pkexec sh -c "echo $next > $PROFILE_FILE"
    else
        echo "$next" > "$PROFILE_FILE"
    fi
    
    # Read again to confirm change source of truth
    current=$(cat "$PROFILE_FILE")
fi

# Determine icon and text based on current profile
case "$current" in
    "low-power")
        text="Low"
        tooltip="Low Power Mode"
        icon=" "
        class="low-power"
    ;;
    "balanced")
        text="Bal"
        tooltip="Balanced Mode"
        icon=" "
        class="balanced"
    ;;
    "performance")
        text="Perf"
        tooltip="Performance Mode"
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
