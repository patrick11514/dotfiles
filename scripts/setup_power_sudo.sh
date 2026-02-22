#!/bin/bash

# This script sets up sudo rights for modifying the platform_profile
# It allows the current user to write to the file using 'tee' without a password.

PROFILE_FILE="/sys/firmware/acpi/platform_profile"
USER=$(whoami)
SUDOERS_FILE="/etc/sudoers.d/waybar-power-profile"

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

echo "Allowing user '$USER' to write to '$PROFILE_FILE' without password..."

# Create the sudoers file
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/tee $PROFILE_FILE" > "$SUDOERS_FILE"

# Set correct permissions (0440 is required for sudoers files)
chmod 0440 "$SUDOERS_FILE"

echo "Done! You can now toggle power profiles without a password."
echo "Created $SUDOERS_FILE"
