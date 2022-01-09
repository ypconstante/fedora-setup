#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install dconf editor"
my:dnf_install dconf-editor

my:step_begin "config dconf editor"
dconf write /ca/desrt/dconf-editor/show-warning false
