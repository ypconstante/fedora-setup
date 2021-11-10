#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

install_dir=$XDG_DATA_HOME/JetBrains/Toolbox
installer_compressed_file=/tmp/jetbrains-toolbox.tar.gz
installer_dir=/tmp/jetbrains-toolbox

if [ -d "$install_dir" ]; then
    echo 'toolbox already installed, skipping'
    exit 0
fi

my:step_begin "download toolbox"
curl -L 'https://data.services.jetbrains.com/products/download?platform=linux&code=TBA' -o "$installer_compressed_file"
my:step_end

my:step_begin "extract installer"
mkdir -p $installer_dir
tar -xzf $installer_compressed_file -C $installer_dir --strip-components=1
my:step_end

my:step_begin "config toolbox"
mkdir -p "$install_dir"
cp "$ASSETS_DIR/dev_jetbrains-toolbox--settings.json" "$install_dir/.settings.json"
my:step_end

my:step_begin "install toolbox"
$installer_dir/jetbrains-toolbox

my:wait_file "$install_dir/statistics/events.log"
sleep 10

pkill jetbrains-toolb
my:step_end

my:step_begin "remove installer"
rm $installer_compressed_file
rm -r $installer_dir
my:step_end
