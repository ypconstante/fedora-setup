#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install telegram"
my:flatpak_install org.telegram.desktop


SLACK_APP_NAME=com.slack.Slack

my:step_begin "install slack"
my:flatpak_install $SLACK_APP_NAME

my:step_begin "configure slack"
flatpak override --user $SLACK_APP_NAME --reset
flatpak override --user $SLACK_APP_NAME \
    --nofilesystem=xdg-documents \
    --nofilesystem=xdg-music \
    --nofilesystem=xdg-pictures \
    --nofilesystem=xdg-videos


ZOOM_APP_NAME=us.zoom.Zoom

my:step_begin "install zoom"
my:flatpak_install $ZOOM_APP_NAME

my:step_begin "configure zoom"
flatpak override --user $ZOOM_APP_NAME --reset
flatpak override --user $ZOOM_APP_NAME \
    --nofilesystem=~/.zoom \
    --persist=.zoom \
    --nofilesystem=~/Documents/Zoom \
    --persist=Documents
rm -rf "$HOME/.zoom" "$HOME/Documents/Zoom"

