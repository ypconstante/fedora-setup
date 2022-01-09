#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install spotify"
my:flatpak_install com.spotify.Client

my:step_begin "install vlc"
my:dnf_install vlc
