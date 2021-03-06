#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step-begin "install dbeaver"
my:flatpak-install io.dbeaver.DBeaverCommunity

my:step-begin "configure dbeaver"
flatpak override --user io.dbeaver.DBeaverCommunity --reset
flatpak override --user io.dbeaver.DBeaverCommunity \
    --nofilesystem=home \
    --filesystem=xdg-config \
    --filesystem=xdg-data \
    --persist=.eclipse \
    --persist=.swt
