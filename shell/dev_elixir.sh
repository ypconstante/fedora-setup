#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install erlang"
my:asdf_add_plugin erlang
my:dnf_install automake gcc-c++
my:asdf_install_and_set_global erlang "$(asdf list-all erlang | grep 24 | tail -1)"
my:step_end

my:step_begin "install elixir"
my:asdf_add_plugin elixir
my:asdf_install_and_set_global elixir "$(asdf list-all elixir | grep otp-24 | grep -v rc | grep -v master | tail -1)"
my:step_end
