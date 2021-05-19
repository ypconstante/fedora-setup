#!/usr/bin/env bash

PAUSED_PLAYER="none"

logger "starting"

get_desktop() {
    # https://github.com/folixg/pause-on-lock/blob/master/pause-on-lock

    declare -A desktops=(
        ["Unity"]="interface='com.canonical.Unity.Session'"
        ["GNOME"]="gnome"
        ["ubuntu:GNOME"]="gnome"
        ["X-Cinnamon"]="cinnamon"
        ["MATE"]="mate"
        ["KDE"]="freedesktop"
        ["pop:GNOME"]="gnome"
        ["XFCE"]="xfce"
    )
    echo "${desktops[$XDG_CURRENT_DESKTOP]}"
}

disable_bluetooth() {
    pkill blueman-applet
    pkill blueman-manager
    sudo rfkill block bluetooth
}

close_jetbrains_toolbox() {
    pkill jetbrains-toolb
}

minimize_private_windows() {
    xdotool search --name Private | xargs --no-run-if-empty -L 1 xdotool windowminimize
}

mute() {
    pactl set-sink-mute @DEFAULT_SINK@ 1
}

mute_speakers() {
    amixer -Dhw:0 -q set Speaker 0% &> /dev/null
    amixer -Dhw:0 -q set Speaker mute &> /dev/null
}

unmute() {
    pactl set-sink-mute @DEFAULT_SINK@ 0
}

pause() {
    # https://github.com/folixg/pause-on-lock/blob/master/pause-on-lock
    PAUSED_PLAYER="none"

    read -r -a players <<< "$(playerctl --list-all)"
    for player in "${players[@]}"; do
      if [ "$(playerctl --player="$player" status)" = "Playing" ]; then
        playerctl --player="$player" pause
        PAUSED_PLAYER=$player
      fi
    done
}

play() {
    if [ "$PAUSED_PLAYER" != "none" ]; then
        playerctl --player="$PAUSED_PLAYER" play
        PAUSED_PLAYER="none"
    fi
}

on_startup() {
    logger "BEGIN: on_startup"
    disable_bluetooth
    mute_speakers
    logger "END: on_startup"
}

on_lock() {
    logger "BEGIN: on_lock"
    minimize_private_windows
    mute
    pause
    close_jetbrains_toolbox
    disable_bluetooth
    logger "END: on_lock"
}

on_unlock() {
    logger "BEGIN: on_unlock"
    unmute
    mute_speakers
    play
    logger "END: on_unlock"
}

on_headphone_unplug() {
    logger "BEGIN: on_headphone_unplug"
    mute_speakers
    pause
    logger "END: on_headphone_unplug"
}


DESKTOP="$(get_desktop)"
DBUS_EVENT="type='signal',interface='org.${DESKTOP}.ScreenSaver',member='ActiveChanged'"

logger "\$DESKTOP: ${DESKTOP}"
logger "\$DBUS_EVENT: ${DBUS_EVENT}"

on_startup

pactl subscribe |
    while read line; do
        case "$line" in
            "Event 'remove'"*)
                on_headphone_unplug;;
        esac
    done &

dbus-monitor --session "$DBUS_EVENT" |
    while read line; do
        case "$line" in
            *"true"*)
                on_lock;;
            *"false"*)
                on_unlock;;
        esac
    done

logger "end"
