#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step-begin "install tlp"
my:dnf-install tlp tlp-rdw

my:step-begin "configure tlp"
sudo cp "$ASSETS_DIR/battery--tlp.conf" /etc/tlp.d/98-fedora-setup.conf

my:step-begin "configure upower"
sudo sed -Ei 's/^(PercentageCritical)=.*$/\1=15/' /etc/UPower/UPower.conf
sudo sed -Ei 's/^(PercentageAction)=.*$/\1=10/' /etc/UPower/UPower.conf
