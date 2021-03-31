#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install zsh"
my:dnf_install zsh
my:step_end

my:step_begin "install starship"
my:dnf_install starship
my:link_file "$ASSETS_DIR/terminal_zsh--starship.toml" "$XDG_CONFIG_HOME/starship.toml"
my:step_end

my:step_begin "install zgen"
my:git_clone https://github.com/tarjoilija/zgen.git "$ZDOTDIR/zgen"
my:step_end

my:step_begin "configure zsh"
sudo chsh -s "$(command -v zsh)" "$USER"
my:link_file "$ASSETS_DIR/base--env" "$ZDOTDIR/.zshenv"
my:link_file "$ASSETS_DIR/terminal_zsh--rc" "$ZDOTDIR/.zshrc"
my:step_end

my:step_begin "install zsh plugins"
zsh -i -c 'zgen update' &> /dev/null
my:step_end
