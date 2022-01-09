#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

CONFIG_DIR=$XDG_CONFIG_HOME/nano

my:step_begin "configure"
mkdir -p "$CONFIG_DIR"
my:link_file "$ASSETS_DIR/terminal_nano--rc" "$CONFIG_DIR/nanorc"
my:git_clone https://github.com/scopatz/nanorc.git "$CONFIG_DIR/syntax"
