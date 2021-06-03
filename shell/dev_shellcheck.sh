#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install shellcheck"
my:asdf_add_plugin shellcheck
my:asdf_install_and_set_global shellcheck "$(asdf list-all shellcheck | tail -1)"
my:step_end
