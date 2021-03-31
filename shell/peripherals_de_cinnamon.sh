#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "modify mouse and touchpad settings"
# locate cursor with ctrl
dconf write /org/cinnamon/settings-daemon/peripherals/mouse/locate-pointer false
# disable left+right click to middle click
dconf write /org/cinnamon/settings-daemon/peripherals/mouse/middle-button-enabled false
# disable tap to click
dconf write /org/cinnamon/settings-daemon/peripherals/touchpad/tap-to-click false
# scroll two fingers
dconf write /org/cinnamon/settings-daemon/peripherals/touchpad/scrolling-method 1
my:step_end

my:step_begin "modify keyboard settings"
dconf write /org/gnome/libgnomekbd/keyboard/options "['caps\tcaps:none']"
dconf load /org/cinnamon/desktop/keybindings/ < "$ASSETS_DIR/peripherals--cinnamon-keyboard-bindings.dconf"
my:step_end
