#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step-begin "configure redshift"
my:link-file "$ASSETS_DIR/utility_redshift.conf" "$XDG_CONFIG_HOME/redshift.conf"
cp /usr/share/applications/redshift-gtk.desktop "$XDG_CONFIG_HOME/autostart/"
my:append-to-file-if-not-contains "$XDG_CONFIG_HOME/autostart/redshift-gtk.desktop" 'X-GNOME-Autostart-enabled=true'
my:append-to-file-if-not-contains "$XDG_CONFIG_HOME/autostart/redshift-gtk.desktop" 'Hidden=false'
