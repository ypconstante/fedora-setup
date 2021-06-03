#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install retroarch"
my:dnf_install retroarch
my:step_end
