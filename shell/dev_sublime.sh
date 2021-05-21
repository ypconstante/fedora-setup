#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

sublime_config_dir=$HOME/.config/sublime-text-3
preferences_file="$sublime_config_dir/Packages/User/Preferences.sublime-settings"
package_control_file="$sublime_config_dir/Installed Packages/Package Control.sublime-package"
package_control_config_file="$sublime_config_dir/Packages/User/Package Control.sublime-settings"

my:step_begin "add sublime repository"
my:dnf_add_key https://download.sublimetext.com/sublimehq-rpm-pub.gpg
my:dnf_add_repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
my:step_end

my:step_begin "install sublime text"
my:dnf_install sublime-text
my:link_file "$ASSETS_DIR/dev_sublime--preferences.sublime-settings" "$preferences_file"
my:step_end

my:step_begin "install package control"
mkdir -p "$(dirname "$package_control_file")"
curl -sSL "https://packagecontrol.io/Package Control.sublime-package" -o "$package_control_file"

mkdir -p "$(dirname "$package_control_config_file")"
my:link_file "$ASSETS_DIR/dev_sublime--package-control.sublime-settings" "$package_control_config_file"
my:step_end

my:step_begin "install sublime merge"
my:dnf_install sublime-merge
my:step_end
