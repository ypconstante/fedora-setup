#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "update toolbox container dependencies"
my:toolbox-run sudo dnf update -y
