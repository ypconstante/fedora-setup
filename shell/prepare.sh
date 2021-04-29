#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "remove unused packages"
sudo dnf remove -y \
    hexchat \
    paper-icon-theme \
    pidgin \
    rhythmbox \
    shotwell \
    thunderbird \
    xawtv \
    xfburn \
    simple-scan \
    sane-airscan
my:step_end

my:step_begin "update flatpak packages"
sudo flatpak uninstall -y --unused
sudo flatpak update -y
sudo flatpak uninstall -y --unused
my:step_end

my:step_begin "update dnf packages"
sudo dnf autoremove -y -q
sudo dnf update -y
sudo dnf autoremove -y -q
my:step_end

my:step_begin "update firmwares"
my:dnf_install fwupd
sudo fwupdmgr get-devices
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates
sudo fwupdmgr update
my:step_end

my:step_begin "create common folders"
mkdir -p "$HOME/.local/bin/"
mkdir -p "$XDG_DATA_HOME/applications"
my:step_end
