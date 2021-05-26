#!/usr/bin/env sh

power_off="   Shut down"
reboot="   Reboot"
lock="   Lock"
suspend="⏾   Sleep"
log_out="   Leave"

chosen=$(printf '%s;%s;%s;%s;%s\n' "$power_off" "$reboot" "$lock" "$suspend" \
                                   "$log_out" \
    | rofi -theme 'powermenu/powermenu.rasi' \
           -dmenu \
           -sep ';' \
           -selected-row 0)

case "$chosen" in
    "$power_off")
        poweroff
        ;;

    "$reboot")
        reboot
        ;;

    "$lock")
        betterlockscreen -l dim
        ;;

    "$suspend")
        systemctl suspend
        ;;

    "$log_out")
        i3-msg exit
        ;;

    *) exit 1 ;;
esac
