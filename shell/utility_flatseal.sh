#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step-begin "install flatseal"
my:flatpak-install com.github.tchx84.Flatseal
