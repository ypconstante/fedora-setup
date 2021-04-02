#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install node"
my:asdf_add_plugin nodejs
my:echo_substep "Importing node keys"
$ASDF_DATA_DIR/plugins/nodejs/bin/import-release-team-keyring &> /dev/null
my:asdf_install_and_set_global nodejs "$(asdf list-all nodejs | grep '^12' | tail -1)"
my:asdf_install_and_set_global nodejs "$(asdf list-all nodejs | grep '^14' | tail -1)"
my:step_end

my:step_begin "install yarn"
my:asdf_add_plugin yarn
my:asdf_install_and_set_global yarn "$(asdf list-all yarn | grep -v '[a-z]' | tail -1)"
my:step_end
