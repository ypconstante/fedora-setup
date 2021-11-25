#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install cli tools"
my:dnf_install \
    inotify-tools \
    jq \
    neofetch \
    speedtest-cli \
    tealdeer \
    tokei \
    toolbox \
    xclip
my:step_end

my:step_begin "configure tldr"
my:link_file "$ASSETS_DIR/terminal_tools--tealdeer.toml" "$XDG_CONFIG_HOME/tealdeer/config.toml"
tldr tldr &> /dev/null
tldr --update
my:step_end

my:step_begin "configure wget to follow xdg"
my:append_to_file_if_not_contains "$XDG_CONFIG_HOME/wgetrc" "hsts-file = $XDG_STATE_HOME/wget-hsts"
rm -f "$HOME/.wget-hsts"
my:step_end
