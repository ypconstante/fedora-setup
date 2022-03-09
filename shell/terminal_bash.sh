#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step-begin "move history file"
rm -f "$HOME/.bash_history"
mkdir -p "$XDG_STATE_HOME/bash"

my:step-begin "add starship initialization"
sed -Ei "s|~/.bashrc.d|$XDG_CONFIG_HOME/bashrc.d|" "$HOME/.bashrc"

mkdir -p "$XDG_CONFIG_HOME/bashrc.d"
echo "if [ ! -f /usr/bin/starship ]; then return 0; fi" > "$XDG_CONFIG_HOME/bashrc.d/starship.sh"
/usr/bin/starship init bash --print-full-init >> "$XDG_CONFIG_HOME/bashrc.d/starship.sh"

my:step-begin "ensure profile is sourced when opening"
echo "source $HOME/.profile" > "$XDG_CONFIG_HOME/bashrc.d/profile.sh"
