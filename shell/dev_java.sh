#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install java"
my:asdf_add_plugin java
my:asdf_install_and_set_global java "$(asdf list-all java | grep openjdk-8 | grep -v 'openj9' | tail -1)"
my:step_end

my:step_begin "install maven"
my:asdf_add_plugin maven
my:asdf_install_and_set_global maven "$(asdf list-all maven | grep -v '[a-z]' | tail -1)"
my:step_end

my:step_begin "fish config"
my:link_file "$ASDF_DATA_DIR/plugins/java/set-java-home.fish" "${HOME}/projects/personal/fish-local/conf.d/asdf-java.fish"
my:step_end
