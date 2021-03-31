#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "config environment variables"
my:link_file "${ASSETS_DIR}/base--env" ~/.profile
my:step_end
