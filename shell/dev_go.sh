#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install go"
my:asdf_add_plugin golang
my:asdf_install_and_set_global golang latest
