#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "configure journald"
sudo mkdir -p /etc/systemd/journald.conf.d
sudo cp "$ASSETS_DIR/systemd--journald.conf" /etc/systemd/journald.conf.d/custom.conf
my:step_end
