#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

if ! my:command-exists nemo; then
    echo 'nemo not installed, skipping'
    exit 0
fi

my:step-begin "close nemo"
nemo -q

my:step-begin "configure nemo"
dconf load /org/nemo/ < "$ASSETS_DIR/file-manager_nemo.dconf"

my:step-begin "fix opening from terminal"
sudo mkdir -p /var/lib/samba/usershares/
