#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step-begin "install xdotool"
my:dnf-install xdotool

my:step-begin "add access to input events"
sudo usermod -aG input "$USER"

find . -name "peripherals_*.sh" -print0 | my:run-files
