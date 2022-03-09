#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step-begin "install decoder"
my:flatpak-install com.belmoussaoui.Decoder
