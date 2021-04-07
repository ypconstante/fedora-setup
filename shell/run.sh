#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

./package-managers.sh
./prepare.sh
./environment.sh
./cli-tools.sh
./git.sh

./terminal.sh
./bluetooth.sh
./browser.sh
./certificates.sh
./desktop.sh
./dev.sh
./file-manager.sh
./peripherals.sh
./sound.sh
