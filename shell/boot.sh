#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "configure grub"
sudo grub2-editenv /boot/efi/EFI/fedora/grubenv create
sudo cp "$ASSETS_DIR/boot--grub-config.sh" /etc/grub.d/99_custom
sudo chmod +x /etc/grub.d/99_custom
my:append_to_file_if_not_contains /etc/default/grub 'GRUB_CMDLINE_LINUX_DEFAULT="fbcon=nodefer"'
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
my:step_end

my:step_begin "change plymouth theme"
my:dnf_install plymouth-theme-spinner
sudo plymouth-set-default-theme spinner -R
my:step_end