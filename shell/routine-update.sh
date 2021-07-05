#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

./prepare.sh
./terminal_fish.sh

my:step_begin "update cinnamon spices"
cinnamon-spice-updater --update-all
my:step_end
