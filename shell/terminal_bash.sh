#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "remove unused files"
rm -f ~/.bash_history
my:step_end
