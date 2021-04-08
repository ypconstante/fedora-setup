#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install postman"
my:flatpak_install com.getpostman.Postman
my:step_end
