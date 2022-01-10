#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install virtualization group"
my:dnf_install '@Virtualization'

my:step_begin "install gnome-boxes"
my:dnf_install gnome-boxes

my:step_begin "configure virtualization"
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
sudo modprobe kvm
sudo modprobe kvm_intel
sudo modprobe kvm_amd
sudo usermod -aG libvirt "$USER"

my:step_begin "virtualization kernel parameters"
sudo cp "$ASSETS_DIR/virtualization--kernel-parameters.conf" /etc/sysctl.d/98-virtualization.conf
sudo chmod 644 /etc/sysctl.d/98-virtualization.conf
