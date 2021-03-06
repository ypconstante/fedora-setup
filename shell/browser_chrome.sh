#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step-begin "install chrome"
sudo dnf config-manager --set-enabled google-chrome
my:dnf-install google-chrome-stable

my:step-begin "install chromium"
my:flatpak-install com.github.Eloston.UngoogledChromium

my:step-begin "configure"
flatpak override --user com.github.Eloston.UngoogledChromium --reset
flatpak override --user com.github.Eloston.UngoogledChromium \
    --nofilesystem=home \
    --persist=xdg-config
