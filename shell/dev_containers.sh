#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install docker"
my:dnf_add_repo https://download.docker.com/linux/fedora/docker-ce.repo
my:dnf_install docker-ce docker-ce-cli docker-compose containerd.io
my:step_end


my:step_begin "configure docker"
# https://docs.docker.com/engine/security/rootless/
my:dnf_install fuse-overlayfs iptables

## workaround - https://github.com/moby/moby/issues/41230
my:dnf_install policycoreutils-python-utils && sudo semanage permissive -a iptables_t

dockerd-rootless-setuptool.sh install

my:link_file "$ASSETS_DIR/dev_containers--docker-daemon.json" /etc/docker/daemon.json
systemctl --user enable docker.service
sudo loginctl enable-linger "$USER"
my:step_end

my:step_begin "fish config"
cp /usr/share/fish/vendor_completions.d/docker-compose.fish \
    "$HOME/projects/personal/fish-local/completions/docker-compose.fish"
my:step_end
