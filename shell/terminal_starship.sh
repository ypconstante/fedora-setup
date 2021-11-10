#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install starship"
my:dnf_install starship
my:link_file "$ASSETS_DIR/terminal_starship.toml" "$XDG_CONFIG_HOME/starship.toml"
my:step_end
