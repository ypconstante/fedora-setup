#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

config_dir=${XDG_CONFIG_HOME}/nano

my:step_begin "configure"
mkdir -p "${config_dir}"
my:link_file "${ASSETS_DIR}/terminal_nano--rc" "${config_dir}/nanorc"
my:git_clone https://github.com/scopatz/nanorc.git "${config_dir}/syntax"
my:step_end
