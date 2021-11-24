#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "move history file"
rm -f "$HOME/.bash_history"
mkdir -p "$XDG_STATE_HOME"/bash
my:step_end

my:step_begin "add starship initialization"
sed -Ei "s|~/.bashrc.d|$XDG_CONFIG_HOME/bashrc.d|" "$HOME/.bashrc"

mkdir -p "$XDG_CONFIG_HOME/bashrc.d"
/usr/bin/starship init bash --print-full-init > "$XDG_CONFIG_HOME/bashrc.d/starship.sh"
my:step_end
