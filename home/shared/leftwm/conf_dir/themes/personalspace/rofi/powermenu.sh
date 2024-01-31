#!/usr/bin/env bash

THEME="$HOME/.config/leftwm/themes/current/rofi/cat/rasi/powermenu.rasi"

rofi_command="rofi -no-config -theme $THEME"

# Options
# shutdown="Shutdown"
# reboot="Restart"
# lock="Lock"
# suspend="Suspend"
# logout="Logout"
shutdown=""
reboot=""
lock="󰍁"
suspend=""
logout="󰍃"
# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 0)"
case $chosen in
    $shutdown)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $lock)
        betterlockscreen -l dim
        ;;
    $suspend)
        systemctl suspend
        ;;
    $logout)
        loginctl kill-session $XDG_SESSION_ID
        ;;
esac
