#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install tlp"
my:dnf_install tlp tlp-rdw
my:step_end
