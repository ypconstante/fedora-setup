#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

DEFAULT_CONFIG_FILE="$HOME/.gitconfig"
CONFIG_DIR=$XDG_CONFIG_HOME/git
CONFIG_FILE=$CONFIG_DIR/config
GIT_IGNORE_FILE=$CONFIG_DIR/gitignore

my:step_begin "install git"
my:dnf_install git
my:step_end

my:step_begin "make git respected xdg spec"
mkdir -p "$CONFIG_DIR"

if [ -f $DEFAULT_CONFIG_FILE ]; then
    mv $DEFAULT_CONFIG_FILE "$CONFIG_FILE"
fi

my:create_file "$CONFIG_FILE"
my:create_file "$CONFIG_DIR/credentials"
my:step_end

my:step_begin "add known ssh hosts"
mkdir -p "$HOME/.ssh"
chmod 0755 "$HOME/.ssh"
for host in 'bitbucket.org' 'github.com' 'gitlab.com'; do
    ssh-keygen -R $host 1> /dev/null
    ssh-keyscan -t rsa $host >> "$HOME/.ssh/known_hosts"
done
my:step_end

my:step_begin "create gitignore"
curl -sS https://www.toptal.com/developers/gitignore/api/dotenv,git,linux,jetbrains+all,sublimetext -o "$GIT_IGNORE_FILE"
echo -e "\n" >> "$GIT_IGNORE_FILE"
cat "$ASSETS_DIR/git--ignore" >> "$GIT_IGNORE_FILE"
git config --global core.excludesfile "$GIT_IGNORE_FILE"
my:step_end

my:step_begin "install git tools"
my:dnf_install \
    git-delta \
    meld \
    tig
mkdir -p "$XDG_DATA_HOME/tig"
my:step_end

my:step_begin "configure meld"
dconf load /org/gnome/meld/ < "$ASSETS_DIR/git--meld.dconf"
my:step_end


my:step_begin "configure git"
git config --global include.path "$ASSETS_DIR/git--config"
git config --global commit.template "$ASSETS_DIR/git--commit-template"
my:step_end

my:step_begin "configure current repo"
cd "$PROJECT_DIR"
git remote set-url origin git@github.com:ypconstante/fedora-setup.git
my:step_end
