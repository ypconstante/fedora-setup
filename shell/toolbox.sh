#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install toolbox"
my:dnf_install toolbox

if ! podman container exists "$TOOLBOX_CONTAINER"; then
    my:step_begin "create '$TOOLBOX_CONTAINER' container"
    toolbox create -y "$TOOLBOX_CONTAINER"
fi

./toolbox_update.sh

my:step_begin "install toolbox container dependencies"
my:toolbox-dnf-install \
    glibc-langpack-en \
    '@Development Tools' \
    '@C Development Tools and Libraries'
