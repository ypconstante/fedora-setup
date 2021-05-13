#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

./package-managers.sh
./prepare.sh
./environment.sh
./cli-tools.sh
./git.sh

./terminal.sh
./battery.sh
./bluetooth.sh
./browser.sh
./certificates.sh
./communication.sh
./desktop.sh
./dev.sh
./file-manager.sh
./file-system.sh
./graphics.sh
./grub.sh
./media.sh
./memory.sh
./peripherals.sh
./screen-capture.sh
./sound.sh
./system-monitor.sh
./utility.sh
./virtualization.sh
