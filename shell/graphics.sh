#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step-begin "install vulkan"
my:dnf-install \
    mesa-vulkan-drivers \
    mesa-vulkan-drivers.i686 \
    vulkan \
    vulkan-loader \
    vulkan-loader.i686 \
    vulkan-tools

my:step-begin "enable vaapi"
my:dnf-install \
    ffmpeg \
    libva \
    libva-vdpau-driver \
    libva-utils \
    vdpauinfo


my:step-begin "install gpu viewer"
my:flatpak-install io.github.arunsivaramanneo.GPUViewer

intel_gpus=$(lspci | grep -i VGA | grep -i Intel)
if [ -n "$intel_gpus" ]; then

    my:step-begin "instal and configure intel"
    my:dnf-install intel-media-driver
fi

nvidia_gpus=$(lspci | grep -i VGA | grep -i NVIDIA)
if [ -n "$nvidia_gpus" ]; then

    my:step-begin "install and configure nvidia"
    # https://rpmfusion.org/Howto/NVIDIA#Installing_the_drivers
    my:dnf-install \
        akmod-nvidia \
        xorg-x11-drv-nvidia-cuda \
        xorg-x11-drv-nvidia-cuda-libs \
        xorg-x11-drv-nvidia-libs \
        xorg-x11-drv-nvidia-libs.i686 \
        xorg-x11-drv-nvidia-power
    sudo systemctl enable nvidia-suspend nvidia-resume nvidia-hibernate

    my:dnf-install \
        nv-codec-headers
fi
