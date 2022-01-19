#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install emacs"
my:dnf_install emacs emacs-terminal

my:step_begin "install spacemacs"
my:git_clone https://github.com/syl20bnr/spacemacs "$XDG_CONFIG_HOME/emacs"
mkdir "$SPACEMACSDIR"
