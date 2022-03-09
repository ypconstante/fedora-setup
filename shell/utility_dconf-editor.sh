#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step-begin "install dconf editor"
my:dnf-install dconf-editor

my:step-begin "config dconf editor"
dconf write /ca/desrt/dconf-editor/show-warning false
