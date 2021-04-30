#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install dependencies"
my:dnf_install acpid playerctl
sudo systemctl enable acpid
my:step_end

my:step_begin "install service"
mkdir -p "${XDG_DATA_HOME}/systemd/user"
bin_file="${HOME}/.local/bin/events-monitor"

my:link_file "${ASSETS_DIR}/events--monitor.sh" "$bin_file"
chmod +x "$bin_file"

my:link_file "${ASSETS_DIR}/events--monitor.service" "${XDG_DATA_HOME}/systemd/user/events-monitor.service"

systemctl --user daemon-reload
systemctl --user enable events-monitor.service
my:step_end
