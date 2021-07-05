#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install fish"
my:dnf_install fish
mkdir -p ~/.config/fish/completions
my:step_end

my:step_begin "reset config"
rm -rf "${XDG_CONFIG_HOME}/fish"
my:step_end

my:step_begin "install starship"
my:dnf_install starship
my:link_file "$ASSETS_DIR/terminal_fish--starship.toml" "$XDG_CONFIG_HOME/starship.toml"
my:step_end

my:step_begin "add asdf"
my:link_file "$ASDF_DIR/completions/asdf.fish" "${XDG_CONFIG_HOME}/fish/completions/asdf.fish"
my:link_file "$ASDF_DATA_DIR/plugins/java/set-java-home.fish" "${XDG_CONFIG_HOME}/fish/conf.d/asdf-java.fish"
my:step_end

my:step_begin "install and configure fisher"
mkdir -p ~/projects/personal/fish-local/functions
my:link_file "$ASSETS_DIR/terminal_fish--fisher_plugins" "${XDG_CONFIG_HOME}/fish/fish_plugins"

fish -c "curl -sSL https://git.io/fisher | source && fisher update"
cp -r "$ASSETS_DIR/terminal_fish--config/." "${XDG_CONFIG_HOME}/fish"
my:step_end

my:step_begin "init universal config"
find "$ASSETS_DIR/terminal_fish--config/universal-conf.d/" -name '*.fish' -exec fish '{}' \;
my:step_end

my:step_begin "add starfish initialization"
/usr/bin/starship init fish --print-full-init > "${XDG_CONFIG_HOME}/fish/conf.d/starfish.fish"
my:step_end
