#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install gnome games"
my:dnf_install aisleriot gnome-mines
