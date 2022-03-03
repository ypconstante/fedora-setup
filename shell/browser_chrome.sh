#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install chrome"
sudo dnf config-manager --set-enabled google-chrome
my:dnf_install google-chrome-stable

my:step_begin "install chromium"
my:flatpak_install com.github.Eloston.UngoogledChromium

my:step_begin "configure"
flatpak override --user com.github.Eloston.UngoogledChromium --reset
flatpak override --user com.github.Eloston.UngoogledChromium \
    --nofilesystem=home \
    --persist=xdg-config
