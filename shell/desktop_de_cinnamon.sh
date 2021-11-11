#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

menu_applet_id=42
menu_config_file=~/.cinnamon/configs/menu@cinnamon.org/$menu_applet_id.json

my:step_begin "update cinnamon spices"
cinnamon-spice-updater --update-all
my:step_end

my:step_begin "hide desktop icons"
dconf write /org/nemo/desktop/desktop-layout "'false::false'"
# still used by nemo to define if desktop will be shown in nemo's sidebar
dconf write /org/nemo/desktop/show-desktop-icons false
my:step_end

my:step_begin "change theme"
dconf write /org/cinnamon/desktop/wm/preferences/theme "'Mint-Y-Dark'"
dconf write /org/cinnamon/desktop/interface/gtk-theme "'Mint-Y-Darker'"
dconf write /org/cinnamon/desktop/interface/icon-theme "'Mint-Y'"
dconf write /org/cinnamon/theme/name "'Mint-Y-Dark'"
my:step_end

my:step_begin "modify taskbar"
# position
dconf write /org/cinnamon/panels-enabled "['1:0:right']"

# size
dconf write /org/cinnamon/panels-height "['1:40']"

# taskbar elements
dconf write /org/cinnamon/enabled-applets "[
 'panel1:left:0:menu@cinnamon.org:$menu_applet_id',
 'panel1:left:10:grouped-window-list@cinnamon.org',
 'panel1:right:0:workspace-switcher@cinnamon.org',
 'panel1:right:5:spacer@cinnamon.org',
 'panel1:right:10:systray@cinnamon.org',
 'panel1:right:15:xapp-status@cinnamon.org',
 'panel1:right:20:network@cinnamon.org',
 'panel1:right:30:sound@cinnamon.org',
 'panel1:right:40:power@cinnamon.org',
 'panel1:right:50:notifications@cinnamon.org',
 'panel1:right:60:calendar@cinnamon.org'
]"
# hide taskbar
dconf write /org/cinnamon/panels-autohide "['1:intel']"
my:step_end

my:step_begin "modify background"
dconf write /org/cinnamon/desktop/background/picture-uri "'file:///usr/share/backgrounds/tiles/default_blue.jpg'"
dconf write /org/cinnamon/desktop/background/picture-options "'zoom'"
my:step_end

my:step_begin "modify windows"
dconf write /org/cinnamon/desktop/wm/preferences/button-layout "'close,minimize:'"
dconf write /org/cinnamon/desktop/wm/preferences/focus-mode "'click'"
dconf write /org/cinnamon/prevent-focus-stealing true
dconf write /org/cinnamon/desktop-effects false
my:step_end

my:step_begin "modify alt tab switcher"
dconf write /org/cinnamon/alttab-switcher-style "'icons+preview'"
dconf write /org/cinnamon/alttab-minimized-aware true
dconf write /org/cinnamon/alttab-switcher-enforce-primary-monitor true
my:step_end

my:step_begin "modify workspaces"
dconf write /org/cinnamon/desktop/wm/preferences/num-workspaces 3
dconf write /org/cinnamon/muffin/workspace-cycle true
dconf write /org/cinnamon/workspace-osd-visible false
my:step_end

my:step_begin "modify screen lock"
dconf write /org/cinnamon/desktop/screensaver/allow-keyboard-shortcuts false
dconf write /org/cinnamon/desktop/screensaver/allow-media-control false
dconf write /org/cinnamon/desktop/screensaver/show-album-art false
dconf write /org/cinnamon/desktop/screensaver/show-info-panel false
dconf write /org/cinnamon/desktop/screensaver/floating-widgets false
my:step_end

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

my:link_file "$ASSETS_DIR/desktop_de_cinnamon--menu.menu" "$HOME/.config/menus/cinnamon-applications.menu"
my:step_end

my:step_begin "disable recent files"
dconf write /org/cinnamon/desktop/privacy/remember-recent-files false
my:step_end
