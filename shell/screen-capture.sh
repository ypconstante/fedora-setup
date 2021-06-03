#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "configure gnome screenshot"
dconf write /org/gnome/gnome-screenshot/auto-save-directory "'file://$HOME/downloads'"
dconf write /org/gnome/gnome-screenshot/last-save-directory "'file://$HOME/downloads'"
my:step_end

my:step_begin "install peek"
my:dnf_install peek ffmpeg
my:step_end

my:step_begin "configure peek"
dconf write /com/uploadedlobster/peek/interface-show-notification false
dconf write /com/uploadedlobster/peek/recording-output-format "'webm'"
dconf write /com/uploadedlobster/peek/recording-start-delay 1
dconf write /com/uploadedlobster/peek/persist-save-folder "'$HOME/downloads'"
my:step_end

my:step_begin "install flameshot"
my:dnf_install flameshot
my:step_end

my:step_begin "configure flameshot"
my:link_file "$ASSETS_DIR/screen-capture--flameshot.ini" "$XDG_CONFIG_HOME/flameshot/flameshot.ini"
my:step_end
