#!/usr/bin/env bash

TERMINAL_WINDOW_HEXADECIMAL=$(wmctrl -lx | grep gnome-terminal | awk '{print $1}')

if [ -z "$TERMINAL_WINDOW_HEXADECIMAL" ]; then
    gnome-terminal
else
    wmctrl -i -R "$TERMINAL_WINDOW_HEXADECIMAL"
fi
