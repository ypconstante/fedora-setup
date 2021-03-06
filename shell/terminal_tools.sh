#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step-begin "install cli tools"
my:dnf-install \
    inotify-tools \
    jq \
    neofetch \
    speedtest-cli \
    tealdeer \
    tokei \
    toolbox \
    xclip

my:step-begin "configure tldr"
my:link-file "$ASSETS_DIR/terminal_tools--tealdeer.toml" "$XDG_CONFIG_HOME/tealdeer/config.toml"
tldr tldr &> /dev/null
tldr --update

my:step-begin "configure wget to follow xdg"
my:append-to-file-if-not-contains "$WGETRC" "hsts-file = $XDG_STATE_HOME/wget-hsts"
rm -f "$HOME/.wget-hsts"
