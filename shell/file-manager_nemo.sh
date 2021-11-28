#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

if ! my:command_exists nemo; then
    echo 'nemo not installed, skipping'
    exit 0
fi

my:step_begin "close nemo"
nemo -q
my:step_end

my:step_begin "configure nemo"
dconf load /org/nemo/ < "$ASSETS_DIR/file-manager_nemo.dconf"
my:step_end

my:step_begin "fix opening from terminal"
sudo mkdir -p /var/lib/samba/usershares/
my:step_end
