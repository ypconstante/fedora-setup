#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install java"
my:asdf_add_plugin java
my:asdf_install_and_set_global java latest:temurin-8

my:step_begin "install maven"
my:asdf_add_plugin maven
my:asdf_install_and_set_global maven latest

my:step_begin "fish config"
my:link_file "$ASDF_DATA_DIR/plugins/java/set-java-home.fish" "$HOME/projects/personal/fish-local/conf.d/asdf-java.fish"
