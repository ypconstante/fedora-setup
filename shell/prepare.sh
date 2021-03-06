#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step-begin "remove unused packages"
sudo dnf remove -y \
    hexchat \
    onboard \
    paper-icon-theme \
    pidgin \
    rhythmbox \
    shotwell \
    thunderbird \
    xawtv \
    xfburn \
    simple-scan \
    sane-airscan

my:step-begin "update flatpak packages"
sudo flatpak uninstall -y --unused
sudo flatpak update -y

my:step-begin "update dnf packages"
sudo dnf autoremove -y -q
sudo dnf update -y --refresh

my:step-begin "update firmwares"
my:dnf-install fwupd
sudo fwupdmgr refresh --force -y
sudo fwupdmgr get-devices -y
sudo fwupdmgr update -y

my:step-begin "create common folders"
mkdir -p "$HOME/.local/bin/"
mkdir -p "$XDG_DATA_HOME/applications"
mkdir -p "$XDG_DATA_HOME/systemd/user"
mkdir -p "$XDG_STATE_HOME"
