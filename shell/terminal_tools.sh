#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install neofetch"
my:dnf_install neofetch
my:step_end

my:step_begin "install speedtest"
my:dnf_install speedtest-cli
my:step_end

my:step_begin "install tldr"
my:dnf_install tealdeer
tldr tldr &> /dev/null
tldr --update
my:step_end

my:step_begin "install tokei"
my:dnf_install tokei
my:step_end

my:step_begin "install xclip"
my:dnf_install xclip
my:step_end
