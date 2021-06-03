#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install vulkan"
my:dnf_install \
    mesa-vulkan-drivers \
    mesa-vulkan-drivers.i686 \
    vulkan \
    vulkan-loader \
    vulkan-loader.i686 \
    vulkan-tools
my:step_end

my:step_begin "enable vaapi"
my:dnf_install \
    vdpauinfo \
    libva-vdpau-driver \
    libva-utils
my:step_end
