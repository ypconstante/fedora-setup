#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install fish"
my:dnf_install fish
mkdir -p "$XDG_CONFIG_HOME/fish/completions"
my:step_end

my:step_begin "reset config"
rm -rf "$XDG_CONFIG_HOME/fish"
my:step_end

my:step_begin "install and configure fisher"
mkdir -p "$HOME/projects/personal/fish-local/conf.d"
mkdir -p "$HOME/projects/personal/fish-local/completions"
mkdir -p "$HOME/projects/personal/fish-local/functions"
my:link_file "$ASSETS_DIR/terminal_fish--fisher_plugins" "$XDG_CONFIG_HOME/fish/fish_plugins"

fish -c "curl -sSL https://git.io/fisher | source && fisher update"
cp -r "$ASSETS_DIR/terminal_fish--config/." "$XDG_CONFIG_HOME/fish"
my:step_end

my:step_begin "init universal config"
find "$ASSETS_DIR/terminal_fish--config/universal-conf.d/" -name '*.fish' -exec fish '{}' \;
my:step_end

my:step_begin "add starship initialization"
/usr/bin/starship init fish --print-full-init > "$XDG_CONFIG_HOME/fish/conf.d/starship.fish"
my:step_end
