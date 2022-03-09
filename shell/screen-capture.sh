#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step-begin "install peek"
my:dnf-install peek ffmpeg

my:step-begin "configure peek"
dconf write /com/uploadedlobster/peek/interface-show-notification false
dconf write /com/uploadedlobster/peek/recording-output-format "'webm'"
dconf write /com/uploadedlobster/peek/recording-start-delay 1
dconf write /com/uploadedlobster/peek/persist-save-folder "'$HOME/downloads'"

my:step-begin "remove gnome screenshot"
my:dnf-remove gnome-screenshot

my:step-begin "install flameshot"
my:dnf-install flameshot

my:step-begin "configure flameshot"
my:copy-file "$ASSETS_DIR/screen-capture--flameshot.ini" "$XDG_CONFIG_HOME/flameshot/flameshot.ini"
sed -Ei "s|\\\$HOME|$HOME|" "$XDG_CONFIG_HOME/flameshot/flameshot.ini"
