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
    bluetoothctl -- power off
}

disable_numlock() {
    numlockx off
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
    if pactl list sinks | grep 'Active Port' | grep 'speaker'; then
        amixer -Dhw:0 -q set Speaker 0% &> /dev/null
        amixer -Dhw:0 -q set Speaker mute &> /dev/null
    fi
}

mute_internal_mic() {
    amixer -Dhw:0 -q set 'Internal Mic Boost' 0% &> /dev/null
    amixer -Dhw:0 -q set Capture 0% &> /dev/null
    amixer -Dhw:0 -q set Capture nocap &> /dev/null
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
    mute_internal_mic
    disable_numlock
    logger "END: on_startup"
}

on_lock() {
    logger "BEGIN: on_lock"
    minimize_private_windows
    mute
    pause
    close_jetbrains_toolbox
    disable_bluetooth
    disable_numlock
    mute_internal_mic
    logger "END: on_lock"
}

on_unlock() {
    logger "BEGIN: on_unlock"
    unmute
    mute_speakers
    mute_internal_mic
    play
    disable_numlock
    logger "END: on_unlock"
}

on_new_audio_device() {
    logger "BEGIN: on_new_audio_device"
    mute_speakers
    logger "END: on_new_audio_device"
}

on_generic_change_audio_device() {
    logger "BEGIN: on_generic_change_audio_device"
    mute_speakers
    logger "END: on_generic_change_audio_device"
}

on_removed_audio_device() {
    logger "BEGIN: on_removed_audio_device"
    mute_speakers
    pause
    logger "END: on_removed_audio_device"
}


DESKTOP="$(get_desktop)"
DBUS_EVENT="type='signal',interface='org.${DESKTOP}.ScreenSaver',member='ActiveChanged'"

logger "\$DESKTOP: ${DESKTOP}"
logger "\$DBUS_EVENT: ${DBUS_EVENT}"

on_startup

pactl subscribe |
    while read line; do
        case "$line" in
            "Event 'new' on card"*)
                on_new_audio_device;;
            "Event 'change' on card"*)
                on_generic_change_audio_device;;
            "Event 'remove' on card"*)
                on_removed_audio_device;;
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
