#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install asdf"
my:git_clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR" "last-tag"
my:step_end

my:step_begin "config asdf"
my:link_file "$ASSETS_DIR/dev_asdf--rc" "$ASDF_CONFIG_FILE"
my:step_end
