#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "close file managers"
my:command_exists nemo && nemo -q
my:step_end

./file-system_user.sh
./file-system_os.sh
