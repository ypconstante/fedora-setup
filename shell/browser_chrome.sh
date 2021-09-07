#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install chrome"
sudo dnf config-manager --set-enabled google-chrome
my:dnf_install google-chrome-stable
my:step_end

my:step_begin "install chromium"
my:dnf_install chromium
my:step_end

my:step_begin "add temporary chromium to menu"
menu_file="$XDG_DATA_HOME/applications/chromium-temporary.desktop"
my:link_file "$ASSETS_DIR/browser_chrome--temp-profile.desktop" "$menu_file"
chmod +x "$menu_file"
my:step_end
