#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "documents folder lower case"
mv "$HOME/Documents" "$HOME/documents"
xdg-user-dirs-update --set DOCUMENTS "$HOME/documents"
my:step_end

my:step_begin "downloads lower case"
mv "$HOME/Downloads" "$HOME/downloads"
xdg-user-dirs-update --set DOWNLOAD "$HOME/downloads"
my:step_end

my:step_begin "create base project structure"
mkdir -p "$HOME/projects/personal"
mkdir -p "$HOME/projects/sandbox"
my:step_end

my:step_begin "move templates folder"
mv "$HOME/Templates" "${HOME}/.local/template-files"
xdg-user-dirs-update --set TEMPLATES "${HOME}/.local/template-files"
my:step_end

my:step_begin "create media folder"
mkdir -p "$HOME/media"

xdg-user-dirs-update --set MUSIC "$HOME/media"
rm -rf "$HOME/Music"

xdg-user-dirs-update --set PICTURES "$HOME/media"
rm -rf "$HOME/Pictures"

xdg-user-dirs-update --set VIDEOS "$HOME/media"
rm -rf "$HOME/Videos"
my:step_end

my:step_begin "remove non used xdg folders"
xdg-user-dirs-update --set DESKTOP "$HOME"
rm -rf "$HOME/Desktop"

xdg-user-dirs-update --set PUBLICSHARE "$(xdg-user-dir DOWNLOAD)"
rm -rf "$HOME/Public"
my:step_end

my:step_begin "create bookmark"
{
    echo "file://$HOME/documents Documents"
    echo "file://$HOME/downloads Downloads"
    echo "file://$HOME/media Media"
    echo "file://$HOME/projects Projects"
} > "$XDG_CONFIG_HOME/gtk-3.0/bookmarks"
my:step_end

my:step_begin "fix gnupg permissions"
mkdir -p "$HOME/.gnupg"
find "$HOME/.gnupg" -type d -exec chmod 700 {} \;
find "$HOME/.gnupg" -type f -exec chmod 600 {} \;
my:step_end
