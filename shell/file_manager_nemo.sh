#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

if ! my:command_exists nemo; then
    echo 'nome not installed, skipping'
    exit 0
fi

my:step_begin "close nemo"
nemo -q
my:step_end

my:step_begin "set disabled extensions"
dconf write /org/nemo/plugins/disabled-extensions "['ChangeFolderColor+NemoPython', 'EmblemPropertyPage+NemoPython', 'NemoShare']"
my:step_end

my:step_begin "ignore folder view config"
dconf write /org/nemo/preferences/ignore-view-metadata true
my:step_end

my:step_begin "open files with single click"
dconf write /org/nemo/preferences/click-policy "'single'"
my:step_end

my:step_begin "ask what to do when opening executable file"
dconf write /org/nemo/preferences/executable-text-activation "'ask'"
my:step_end

my:step_begin "configure toolbar"
dconf write /org/nemo/preferences/show-open-in-terminal-toolbar true
# hide path mode toggle
dconf write /org/nemo/preferences/show-edit-icon-toolbar false
dconf write /org/nemo/preferences/show-search-icon-toolbar false
dconf write /org/nemo/preferences/show-compact-view-icon-toolbar false
my:step_end

my:step_begin "configure sidebar"
dconf write /org/nemo/window-state/sidebar-width 154
my:step_end

my:step_begin "configure previews"
dconf write /org/nemo/preferences/show-image-thumbnails "'local-only'"
dconf write /org/nemo/preferences/show-directory-item-counts "'never'"
my:step_end

my:step_begin "configure context menu"
dconf write /org/nemo/preferences/enable-delete false
dconf write /org/nemo/preferences/menu-config/selection-menu-scripts false
dconf write /org/nemo/preferences/menu-config/selection-menu-pin false
dconf write /org/nemo/preferences/menu-config/background-menu-scripts false
my:step_end

my:step_begin "set disabled actions"
dconf write /org/nemo/plugins/disabled-actions "['new-launcher.nemo_action', 'set-as-background.nemo_action', 'add-desklets.nemo_action', 'change-background.nemo_action', 'send-by-mail.nemo_action']"
my:step_end

my:step_begin "fix opening from terminal"
sudo mkdir -p /var/lib/samba/usershares/
my:step_end
