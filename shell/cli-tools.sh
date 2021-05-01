#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install base cli tools"
my:dnf_install jq
my:dnf_install inotify-tools
my:step_end

my_step_begin "fix wget to follow xdg"
my_append_to_file_if_not_contains "$XDG_CONFIG_HOME/wgetrc" "hsts-file = ${XDG_CACHE_HOME}/wget-hsts"
rm -f "$HOME/.wget-hsts"
my_step_end
