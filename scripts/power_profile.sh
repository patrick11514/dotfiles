#!/bin/bash

# Unified dispatcher: delegates to power_profile_nb.sh if ACPI platform_profile exists, else power_profile_pc.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "/sys/firmware/acpi/platform_profile" ]; then
    exec "$SCRIPT_DIR/power_profile_nb.sh" "$@"
else
    exec "$SCRIPT_DIR/power_profile_pc.sh" "$@"
fi
