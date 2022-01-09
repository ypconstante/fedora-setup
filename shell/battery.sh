#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install tlp"
my:dnf_install tlp tlp-rdw

my:step_begin "configure tlp"
sudo cp "$ASSETS_DIR/battery--tlp.conf" /etc/tlp.d/98-fedora-setup.conf

my:step_begin "configure upower"
sudo sed -Ei 's/^(PercentageCritical)=.*$/\1=15/' /etc/UPower/UPower.conf
sudo sed -Ei 's/^(PercentageAction)=.*$/\1=10/' /etc/UPower/UPower.conf
