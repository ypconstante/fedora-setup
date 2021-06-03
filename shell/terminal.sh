#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

find . -name "terminal_*.sh" -print0 | my:run_files
