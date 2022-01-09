#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "disable system sounds"
dconf write /org/cinnamon/sounds/login-enabled false
dconf write /org/cinnamon/sounds/logout-enabled false
dconf write /org/cinnamon/sounds/switch-enabled false
dconf write /org/cinnamon/sounds/map-enabled false
dconf write /org/cinnamon/sounds/close-enabled false
dconf write /org/cinnamon/sounds/minimize-enabled false
dconf write /org/cinnamon/sounds/maximize-enabled false
dconf write /org/cinnamon/sounds/unmaximize-enabled false
dconf write /org/cinnamon/sounds/tile-enabled false
