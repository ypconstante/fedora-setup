#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "configure sound kernel module"
my:link_file "$ASSETS_DIR/sound--kernel-module.conf" /etc/modprobe.d/sound.conf
my:step_end

find . -name "sound_*.sh" -print0 | my:run_files
