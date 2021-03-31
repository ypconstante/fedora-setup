#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install base cli tools"
my:dnf_install jq
my:dnf_install inotify-tools
my:step_end
