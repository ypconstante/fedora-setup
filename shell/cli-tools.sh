#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install base cli tools"
my:dnf_install jq
my:dnf_install inotify-tools
my:step_end

my:step_begin "fix wget to follow xdg"
my:append_to_file_if_not_contains "$XDG_CONFIG_HOME/wgetrc" "hsts-file = $XDG_STATE_HOME/wget-hsts"
rm -f "$HOME/.wget-hsts"
my:step_end
