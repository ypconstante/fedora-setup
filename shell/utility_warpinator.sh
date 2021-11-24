#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

APP_NAME=org.x.Warpinator
my:step_begin "install wrapinator"
my:flatpak_install $APP_NAME
my:step_end

my:step_begin "configure wrapinator"
flatpak override --user $APP_NAME --reset
flatpak override --user $APP_NAME \
    --nofilesystem=home \
    --persist=Warpinator \
    --filesystem=xdg-download
rm -rf "$HOME/Warpinator"

CONFIG_FILE="$HOME/.var/app/$APP_NAME/config/glib-2.0/settings/keyfile"
my:append_to_file_if_not_contains $CONFIG_FILE "[org/x/warpinator/preferences]"
my:append_to_file_if_not_contains $CONFIG_FILE "receiving-folder='file://$HOME/downloads'"
my:step_end

