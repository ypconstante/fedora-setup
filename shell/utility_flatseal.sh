#!/bin/bash

source "$(dirname "$0")/_base.sh"

my:step_begin "install flatseal"
my:flatpak_install com.github.tchx84.Flatseal
my:step_end
