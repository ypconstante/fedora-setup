#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
# https://github.com/pyenv/pyenv/wiki/Common-build-problems
my:step_begin "install python dependencies"
my:toolbox-dnf-install \
    bzip2-devel \
    openssl-devel \
    readline-devel \
    sqlite-devel

my:step_begin "install python"
my:asdf_add_plugin python
my:asdf_install_and_set_global python latest:3.10

export PIP_REQUIRE_VIRTUALENV=false

my:step_begin "update pip"
pip install --upgrade pip

my:step_begin "install ipython"
pip install --user ipython

my:step_begin "install virtual envs"
pip install --user pipenv
pip install --user virtualenv
