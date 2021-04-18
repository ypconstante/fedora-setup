#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "configure redshift"
my:link_file "$ASSETS_DIR/utility_redshift.conf" "$XDG_CONFIG_HOME/redshift.conf"
cp /usr/share/applications/redshift-gtk.desktop "$XDG_CONFIG_HOME/autostart/"
my:append_to_file_if_not_contains "$XDG_CONFIG_HOME/autostart/redshift-gtk.desktop" 'X-GNOME-Autostart-enabled=true'
my:append_to_file_if_not_contains "$XDG_CONFIG_HOME/autostart/redshift-gtk.desktop" 'Hidden=false'
my:step_end
