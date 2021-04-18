#!/bin/bash

source "$(dirname "$0")/_base.sh"

my:step_begin "install remmina"
my:dnf_install remmina
my:step_end
