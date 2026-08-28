#!/bin/bash

# This script sets up sudo rights for modifying power profiles without password
# Supports both notebook ACPI platform_profile and desktop CPU energy_performance_preference

USER=$(whoami)
SUDOERS_FILE="/etc/sudoers.d/waybar-power-profile"
PROFILE_FILE="/sys/firmware/acpi/platform_profile"
EPP_FILES="/sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference"

echo "Setting up passwordless sudo for power profile switching for '$USER'..."

# Create the sudoers file
cat <<EOF | sudo tee "$SUDOERS_FILE" > /dev/null
$USER ALL=(ALL) NOPASSWD: /usr/bin/tee $PROFILE_FILE
$USER ALL=(ALL) NOPASSWD: /usr/bin/tee $EPP_FILES
EOF

# Set correct permissions (0440 is required for sudoers files)
sudo chmod 0440 "$SUDOERS_FILE"

echo "Done! You can now toggle power profiles without a password on notebook and PC."
echo "Created $SUDOERS_FILE"
