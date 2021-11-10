#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "remove unused files"
rm -f ~/.bash_history
my:step_end

my:step_begin "add starship initialization"
sed -Ei "s|~/.bashrc.d|${XDG_CONFIG_HOME}/bashrc.d|" ~/.bashrc

mkdir -p "${XDG_CONFIG_HOME}/bashrc.d"
/usr/bin/starship init bash --print-full-init > "${XDG_CONFIG_HOME}/bashrc.d/starship.sh"
my:step_end
