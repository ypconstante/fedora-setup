#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install steam"
my:flatpak_install com.valvesoftware.Steam
