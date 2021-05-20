#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install fish"
my:dnf_install fish
mkdir -p ~/.config/fish/completions
sudo chsh -s "$(command -v fish)" "$USER"
my:step_end

my:step_begin "add asdf completion"
my:link_file "$ASDF_DIR/completions/asdf.fish" ~/.config/fish/completions/asdf.fish
my:step_end

my:step_begin "install and configure fisher"
my:link_file "$ASSETS_DIR/terminal_fish--fisher_plugins" "${XDG_CONFIG_HOME}/fish/fish_plugins"

fish -c "curl -sSL https://git.io/fisher | source && fisher update"
my:step_end
