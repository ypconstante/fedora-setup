#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install dependencies"
my:toolbox-dnf-install \
    ncurses-devel \
    openssl-devel \
    wxGTK3-devel

my:dnf_install \
    wxGTK3 \
    wxGTK3-gl \
    wxGTK3-webview

my:step_begin "install erlang"
my:asdf_add_plugin erlang
my:asdf_install_and_set_global erlang latest:24

my:step_begin "install elixir"
my:asdf_add_plugin elixir
my:asdf_install_and_set_global elixir "$(asdf list-all elixir 1.12 | grep otp-24 | grep -v rc | tail -1)"
