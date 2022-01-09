#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

menu_applet_id=42
menu_config_file="$HOME/.cinnamon/configs/menu@cinnamon.org/$menu_applet_id.json"

my:step_begin "hide desktop icons"
dconf write /org/nemo/desktop/desktop-layout "'false::false'"
# still used by nemo to define if desktop will be shown in nemo's sidebar
dconf write /org/nemo/desktop/show-desktop-icons false

my:step_begin "load config"
dconf load /org/cinnamon/ < "$ASSETS_DIR/desktop_de_cinnamon--config.dconf"

my:step_begin "modify menu"
my:wait_file $menu_config_file
jq 'setpath(["search-filesystem", "value"]; false)' < "$menu_config_file" \
    | jq 'setpath(["menu-custom", "value"]; true)' \
    | jq 'setpath(["menu-label", "value"]; "")' \
    | jq 'setpath(["menu-icon", "value"]; "start-here-symbolic")' \
    | jq 'setpath(["show-places", "value"]; false)' \
    | jq 'setpath(["show-recents", "value"]; false)' \
    > "$menu_config_file.tmp"
mv "$menu_config_file.tmp" "$menu_config_file"

my:link_file "$ASSETS_DIR/desktop_de_cinnamon--menu.menu" "$XDG_CONFIG_HOME/menus/cinnamon-applications.menu"
