#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install asdf"
my:git_clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR" "last-tag"
asdf update --head
my:step_end

my:step_begin "config asdf"
my:link_file "$ASSETS_DIR/dev_asdf--rc" "$ASDF_CONFIG_FILE"
my:step_end

my:step_begin "update plugins"
mkdir -p "$ASDF_DIR/plugins"
asdf plugin-update --all
my:step_end

my:step_begin "fish config"
my:link_file "$ASDF_DIR/completions/asdf.fish" "${HOME}/projects/personal/fish-local/completions/asdf.fish"
my:step_end
