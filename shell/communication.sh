#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install telegram"
my:flatpak_install org.telegram.desktop
my:step_end

ZOOM_APP_NAME=us.zoom.Zoom

my:step_begin "install zoom"
my:flatpak_install $ZOOM_APP_NAME
my:step_end

my:step_begin "configure zoom"
flatpak override --user $ZOOM_APP_NAME --reset
flatpak override --user $ZOOM_APP_NAME \
    --nofilesystem=~/.zoom \
    --persist=.zoom \
    --nofilesystem=~/Documents/Zoom \
    --persist=Documents
rm -rf ~/.zoom ~/Documents/Zoom
my:step_end

