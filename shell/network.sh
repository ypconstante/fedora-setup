#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "configure NetworkManager"
sudo cp "$ASSETS_DIR/network--NetworkManager.conf" /etc/NetworkManager/conf.d/custom.conf
my:step_end

my:step_begin "configure systemd-resolved"
sudo mkdir -p /etc/systemd/resolved.conf.d
sudo cp "$ASSETS_DIR/network--systemd-resolved.conf" /etc/systemd/resolved.conf.d/custom.conf
my:step_end
