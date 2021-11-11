#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "replace blueberry with blueman"
my:dnf_install blueman
my:dnf_remove blueberry
my:step_end

my:step_begin "disable blueman applet startup"
cp /etc/xdg/autostart/blueman.desktop "$XDG_CONFIG_HOME/autostart/"
echo 'X-GNOME-Autostart-enabled=false' >> "$XDG_CONFIG_HOME/autostart/blueman.desktop"
my:step_end

my:step_begin "disable bluetooth automatic power on"
dconf write /org/blueman/plugins/powermanager/auto-power-on '@mb false'
my:step_end
