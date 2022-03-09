#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

PROFILE_NAME='default-release'
PROFILE_DIR="$([ -d "$HOME/.mozilla/firefox" ] && find "$HOME/.mozilla/firefox" -maxdepth 1 -name "*.$PROFILE_NAME" | head -n 1)"

if [[ ! -d "$PROFILE_DIR" ]]; then
    my:echo-error 'no firefox profile available, skipping'
    exit 0
fi

if pgrep firefox > /dev/null; then
    my:echo-error 'firefox is running, skipping'
    exit 0
fi

my:step-begin "config firefox"
my:link-file "$ASSETS_DIR/browser_firefox--search.json.mozlz4" "$PROFILE_DIR/search.json.mozlz4"
my:link-file "$ASSETS_DIR/browser_firefox--user.js" "$PROFILE_DIR/user.js"

mkdir -p "$PROFILE_DIR/chrome"
my:link-file "$ASSETS_DIR/browser_firefox--userChrome.css" "$PROFILE_DIR/chrome/userChrome.css"
my:link-file "$ASSETS_DIR/browser_firefox--userContent.css" "$PROFILE_DIR/chrome/userContent.css"

my:step-begin "add temporary firefox to menu"
bin_file="$HOME/.local/bin/firefox-temp"
menu_file="$XDG_DATA_HOME/applications/firefox-temp.desktop"
my:link-file "$ASSETS_DIR/browser_firefox--temp-profile.sh" "$bin_file"
chmod +x "$bin_file"
my:link-file "$ASSETS_DIR/browser_firefox--temp-profile.desktop" "$menu_file"
chmod +x "$menu_file"

my:step-begin "enable h264 codec"
# https://docs.fedoraproject.org/en-US/quick-docs/openh264/
my:dnf-install gstreamer1-plugin-openh264 mozilla-openh264
