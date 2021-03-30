#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

find . -name "de_${DESKTOP_SESSION}_*.sh" -print0 | my:run_files
