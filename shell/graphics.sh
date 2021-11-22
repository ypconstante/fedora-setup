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
    ffmpeg \
    libva \
    libva-vdpau-driver \
    libva-utils \
    vdpauinfo
my:step_end


my:step_begin "install gpu viewer"
my:flatpak_install io.github.arunsivaramanneo.GPUViewer
my:step_end

intel_gpus=$(lspci | grep -i VGA | grep -i Intel)
if [ -n "$intel_gpus" ]; then

    my:step_begin "instal and configure intel"
    my:dnf_install intel-media-driver
    my:step_end
fi

nvidia_gpus=$(lspci | grep -i VGA | grep -i NVIDIA)
if [ -n "$nvidia_gpus" ]; then

    my:step_begin "install and configure nvidia"
    # https://rpmfusion.org/Howto/NVIDIA#Installing_the_drivers
    my:dnf_install \
        akmod-nvidia \
        xorg-x11-drv-nvidia-cuda \
        xorg-x11-drv-nvidia-cuda-libs \
        xorg-x11-drv-nvidia-power
    sudo systemctl enable nvidia-suspend nvidia-resume nvidia-hibernate

    my:dnf_install \
        nv-codec-headers
    my:step_end
fi
