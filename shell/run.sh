#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

./package-managers.sh
./prepare.sh
./environment.sh
./git.sh
./toolbox.sh

./terminal.sh
./backup.sh
./battery.sh
./bluetooth.sh
./boot.sh
./browser.sh
./communication.sh
./desktop.sh
./dev.sh
./events-monitor.sh
./file-manager.sh
./file-system.sh
./graphics.sh
./media.sh
./memory.sh
./network.sh
./peripherals.sh
./screen-capture.sh
./sound.sh
./system-monitor.sh
./systemd.sh
./utility.sh
./virtualization.sh
