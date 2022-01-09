#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install backup tools"
sudo dnf copr enable -y luminoso/vorta
my:dnf_install borgbackup vorta
