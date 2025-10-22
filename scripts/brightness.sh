#!/bin/bash

CURRENT=$(brightnessctl get)

if [ "$1" == "up" ]; then
    if [ -f /tmp/.brightness.lock ]; then
        rm /tmp/.brightness.lock
        hyprctl dispatch dpms on
        exit 0
    fi

    brightnessctl -q s +5%
elif [ "$1" == "down" ]; then
    if [ "$CURRENT" -eq 0 ]; then
        hyprctl dispatch dpms off
        touch /tmp/.brightness.lock
        exit 0
    fi

    brightnessctl -q s 5%-
elif [ "$1" == "set" ]; then
    if [ "$2" -eq 0 ]; then
        hyprctl dispatch dpms off
        touch /tmp/.brightness.lock
    elif [ -f /tmp/.brightness.lock ]; then
        rm /tmp/.brightness.lock
        hyprctl dispatch dpms on
    fi

    brightnessctl -q s "$2"
fi