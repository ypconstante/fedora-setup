#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install xdotool"
my:dnf_install xdotool

my:step_begin "add access to input events"
sudo usermod -aG input "$USER"

find . -name "peripherals_*.sh" -print0 | my:run_files
