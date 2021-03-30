#!/bin/bash

set -o nounset


if [[ -z ${FORCE_RUN_AS_ROOT+x} ]]; then
    if [[ $EUID -eq 0 ]]; then
        echo "This script must NOT be run as root"
        exit 1
    fi
else
    if [[ $EUID -ne 0 ]]; then
        echo "This script MUST BE run as root"
        exit 1
    fi
fi

set -e
sudo true
set +e

cd "$(dirname "${BASH_SOURCE[0]}")"

export ASSETS_DIR=$(realpath ../assets)
export CURRENT_SCRIPT="${BASH_SOURCE[1]}"

source /etc/os-release

source "$ASSETS_DIR/base--env"

#################################### PRINT #####################################

# my:file_run
my:file_run_begin() {
    local file="$1"
    my:file_run_echo "FILE BEGIN: ${file}"
    echo ''
}

my:file_run_end() {
    local file="$1"
    my:file_run_echo "FILE END: ${file}"
    echo ''
}

my:file_run_echo() {
    local message="$1"
    echo "$(tput setab 4)$(tput setaf 0)${message}$(tput el)$(tput sgr0)"
}

################################################################################

my:file_run_begin "$CURRENT_SCRIPT"

function on_exit {
    my:file_run_end "$CURRENT_SCRIPT"
}

trap on_exit EXIT
