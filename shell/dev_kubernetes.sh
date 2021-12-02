#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install packages"
my:dnf_install kubernetes-client
my:step_end
