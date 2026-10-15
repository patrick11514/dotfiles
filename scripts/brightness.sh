#!/bin/bash

CURRENT=$(brightnessctl get)

set_dpms() {
    local state="$1"
    local lua_action="enable"
    if [ "$state" == "off" ] || [ "$state" == "disable" ]; then
        lua_action="disable"
        state="off"
    else
        lua_action="enable"
        state="on"
    fi

    if ! hyprctl dispatch "hl.dsp.dpms({ action = \"$lua_action\" })" >/dev/null 2>&1; then
        hyprctl dispatch dpms "$state" >/dev/null 2>&1 || true
    fi
}

is_screen_off() {
    [ -f /tmp/.brightness.lock ] || [ "$(hyprctl -j monitors 2>/dev/null | jq -r '.[0].dpmsStatus' 2>/dev/null)" == "false" ]
}

if [ "$1" == "up" ]; then
    if is_screen_off; then
        rm -f /tmp/.brightness.lock
        set_dpms on
        exit 0
    fi

    brightnessctl -q s +5%
elif [ "$1" == "down" ]; then
    if [ "$CURRENT" -le 0 ]; then
        set_dpms off
        touch /tmp/.brightness.lock
        exit 0
    fi

    brightnessctl -q --min-value=0 s 5%-
elif [ "$1" == "set" ]; then
    if [ "$2" -le 0 ]; then
        set_dpms off
        touch /tmp/.brightness.lock
    elif is_screen_off; then
        rm -f /tmp/.brightness.lock
        set_dpms on
    fi

    brightnessctl -q s "$2"
fi