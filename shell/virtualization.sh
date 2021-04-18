#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install virtualization group"
sudo dnf group install -y -q --with-optional virtualization
my:step_end

my:step_begin "configure virtualization"
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
sudo modprobe kvm
sudo modprobe kvm_intel
sudo modprobe kvm_amd
my:step_end
