#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step-begin "install emacs"
my:dnf-install emacs emacs-terminal

my:step-begin "install spacemacs"
my:git-clone https://github.com/syl20bnr/spacemacs "$XDG_CONFIG_HOME/emacs"
mkdir "$SPACEMACSDIR"
