#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

default_config_file=~/.gitconfig
config_dir=${XDG_CONFIG_HOME}/git
config_file=${config_dir}/config
git_ignore_file=${config_dir}/gitignore

my:step_begin "install git"
my:dnf_install git
my:step_end

my:step_begin "make git respected xdg spec"
mkdir -p "${config_dir}"

if [ -f $default_config_file ]; then
    mv $default_config_file "${config_file}"
fi

my:create_file "${config_file}"
my:create_file "${config_dir}/credentials"
my:step_end

my:step_begin "add known ssh hosts"
mkdir -p ~/.ssh
chmod 0755 ~/.ssh
for host in 'bitbucket.org' 'github.com' 'gitlab.com'; do
    ssh-keygen -R $host 1> /dev/null
    ssh-keyscan -t rsa $host >> ~/.ssh/known_hosts
done
my:step_end

my:step_begin "create gitignore"
curl -sS https://www.toptal.com/developers/gitignore/api/dotenv,git,linux,jetbrains+all,sublimetext,visualstudiocode -o "${git_ignore_file}"
echo -e "\n" >> "${git_ignore_file}"
cat "${ASSETS_DIR}/git--ignore" >> "${git_ignore_file}"
git config --global core.excludesfile "${git_ignore_file}"
my:step_end


my:step_begin "install delta"
my:dnf_install git-delta
my:step_end

my:step_begin "install tig"
my:dnf_install tig
mkdir -p "${XDG_DATA_HOME}/tig"
my:step_end

my:step_begin "configure git"
git config --global include.path "${ASSETS_DIR}/git--config"
git config --global commit.template "${ASSETS_DIR}/git--commit-template"
my:step_end

my:step_begin "configure current repo"
git config core.filemode false
git remote set-url origin git@github.com:ypconstante/fedora-setup.git
my:step_end
