#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install docker"
my:dnf_add_repo https://download.docker.com/linux/fedora/docker-ce.repo
my:dnf_install docker-ce docker-ce-cli containerd.io
my:step_end


my:step_begin "configure docker"
my:dnf_install fuse-overlayfs iptables

## workaround - https://github.com/moby/moby/issues/41230
my:dnf_install policycoreutils-python-utils && sudo semanage permissive -a iptables_t

dockerd-rootless-setuptool.sh install

my:link_file "$ASSETS_DIR/dev_containers--docker-daemon.json" /etc/docker/daemon.json
systemctl --user enable docker.service
sudo loginctl enable-linger "$USER"
my:step_end

my:step_begin "install docker compose"
docker_compose_file=$HOME/.local/bin/docker-compose
latest_release_json=/tmp/docker-compose-release.json
curl -sSL https://api.github.com/repos/docker/compose/releases/latest > $latest_release_json
docker_compose_url=$( \
    jq '[ .assets[].browser_download_url ]' $latest_release_json \
    | jq '[ .[] | select(endswith("Linux-x86_64")) ]' \
    | jq -r 'first' \
)
docker_compose_version=$(jq -r '.tag_name' $latest_release_json)
curl -L "$docker_compose_url" -o "$docker_compose_file"
chmod +x "$docker_compose_file"

curl -sSL "https://raw.githubusercontent.com/docker/compose/${docker_compose_version}/contrib/completion/fish/docker-compose.fish" \
    -o ~/projects/personal/fish-local/completions/docker-compose.fish
my:step_end
