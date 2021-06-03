#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install vscodium"
my:flatpak_install com.vscodium.codium
my:step_end
