#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install tlp"
my:dnf_install tlp tlp-rdw
my:step_end

my:step_begin "configure tlp"
sudo cp "$ASSETS_DIR/battery--tlp.conf" /etc/tlp.d/custom.conf
my:step_end
