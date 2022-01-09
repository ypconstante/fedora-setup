#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "setup flatpak"
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

my:step_begin "configure dnf"
my:append_to_file_if_not_contains /etc/dnf/dnf.conf 'deltarpm=true'
my:append_to_file_if_not_contains /etc/dnf/dnf.conf 'max_parallel_downloads=10'

my:step_begin "add rpm fusion"
release_number=$(rpm -E %fedora)
my:dnf_install \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${release_number}.noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${release_number}.noarch.rpm"

my:step_begin "add third party repositories"
my:dnf_install fedora-workstation-repositories

my:step_begin "enable rpm fusion appstream metadata"
sudo dnf -y groupupdate core

my:step_begin "delay automatic update check"
cp /usr/share/applications/org.mageia.dnfdragora-updater.desktop "$XDG_CONFIG_HOME/autostart/"
echo 'X-GNOME-Autostart-Delay=100' >> "$XDG_CONFIG_HOME/autostart/org.mageia.dnfdragora-updater.desktop"
