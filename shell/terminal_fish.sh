#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install fish"
my:dnf_install fish
mkdir -p "$XDG_CONFIG_HOME/fish/completions"
my:step_end

if fish -c "! functions --query fisher"; then
    my:step_begin "install fisher"
    mkdir -p "$HOME/projects/personal/fish-local/conf.d"
    mkdir -p "$HOME/projects/personal/fish-local/completions"
    mkdir -p "$HOME/projects/personal/fish-local/functions"

    fish -c "curl -sSL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
    my:step_end
fi

my:step_begin "add starship initialization"
/usr/bin/starship init fish --print-full-init > "$HOME/projects/personal/fish-local/conf.d/starship.fish"
my:step_end

my:step_begin "install fisher plugins"
# disable conflict check
sed -Ei '/#/!s|(.*set --append conflict_files)|#\1|' "$XDG_CONFIG_HOME/fish/functions/fisher.fish"

my:link_file "$ASSETS_DIR/terminal_fish--fisher_plugins" "$XDG_CONFIG_HOME/fish/fish_plugins"
fish -c "fisher update"
my:step_end
