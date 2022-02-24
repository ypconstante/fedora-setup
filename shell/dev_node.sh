#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install node"
my:asdf_add_plugin nodejs
my:asdf_install_and_set_global nodejs latest:14
my:asdf_install_and_set_global nodejs latest:16

my:step_begin "configure node"
my:append_to_file_if_not_contains "$NPM_CONFIG_USERCONFIG" 'engine-strict = true'
corepack enable

my:step_begin "install yarn"
my:asdf_add_plugin yarn
my:asdf_install_and_set_global yarn latest
