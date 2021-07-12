#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "update current repo"
git pull
my:step_end

./prepare.sh
./dev_asdf.sh
./terminal_fish.sh

my:step_begin "update cinnamon spices"
cinnamon-spice-updater --update-all
my:step_end
