#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install podman"
my:dnf_install \
    podman \
    podman-compose \
    podman-docker
my:step_end
