#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install fish"
my:dnf_install fish
mkdir -p ~/.config/fish/completions
sudo chsh -s "$(command -v fish)" "$USER"
my:step_end

my:step_begin "reset config"
rm -rf "${XDG_CONFIG_HOME}/fish"
my:step_end

my:step_begin "install starship"
my:dnf_install starship
my:link_file "$ASSETS_DIR/terminal_fish--starship.toml" "$XDG_CONFIG_HOME/starship.toml"
my:step_end

my:step_begin "add asdf completion"
my:link_file "$ASDF_DIR/completions/asdf.fish" "${XDG_CONFIG_HOME}/fish/completions/asdf.fish"
my:step_end

my:step_begin "install and configure fisher"
my:link_file "$ASSETS_DIR/terminal_fish--fisher_plugins" "${XDG_CONFIG_HOME}/fish/fish_plugins"

fish -c "curl -sSL https://git.io/fisher | source && fisher update"
my:step_end

my:step_begin "init universal config"
find "$ASSETS_DIR/terminal_fish--config/universal-conf.d/" -name '*.fish' -exec fish '{}' \;
my:step_end

my:step_begin "add starfish initialization"
/usr/bin/starship init fish --print-full-init > "${XDG_CONFIG_HOME}/fish/conf.d/starfish.fish"
my:step_end
