#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "configure grub"
sudo grub2-editenv /boot/efi/EFI/fedora/grubenv create
sudo cp "$ASSETS_DIR/grub--config.sh" /etc/grub.d/99_custom
sudo chmod +x /etc/grub.d/99_custom
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
my:step_end
