#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

POSTMAN_APP_NAME=com.getpostman.Postman

my:step_begin "install postman"
my:flatpak_install $POSTMAN_APP_NAME

my:step_begin "configure postman"
flatpak override --user $POSTMAN_APP_NAME --reset
flatpak override --user $POSTMAN_APP_NAME \
    --nofilesystem=home \
    --filesystem=~/projects
rm -rf "$HOME/Postman"
