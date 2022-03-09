#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step-begin "setup flatpak"
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

my:step-begin "configure dnf"
my:append-to-file-if-not-contains /etc/dnf/dnf.conf 'deltarpm=true'
my:append-to-file-if-not-contains /etc/dnf/dnf.conf 'max_parallel_downloads=10'

my:step-begin "add rpm fusion"
release_number=$(rpm -E %fedora)
my:dnf-install \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${release_number}.noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${release_number}.noarch.rpm"

my:step-begin "add third party repositories"
my:dnf-install fedora-workstation-repositories

my:step-begin "enable rpm fusion appstream metadata"
sudo dnf -y groupupdate core

my:step-begin "delay automatic update check"
cp /usr/share/applications/org.mageia.dnfdragora-updater.desktop "$XDG_CONFIG_HOME/autostart/"
echo 'X-GNOME-Autostart-Delay=100' >> "$XDG_CONFIG_HOME/autostart/org.mageia.dnfdragora-updater.desktop"
