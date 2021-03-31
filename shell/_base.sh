#!/usr/bin/env bash

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

source "${ASSETS_DIR}/base--env"

#################################### FILE #####################################

my:create_file() {
    local file="$1"
    touch "$file" 2> /dev/null || sudo touch "$file"
}

my:link_file() {
    local from="$1"
    local to="$2"

    rm -f "${to}" 2> /dev/null || sudo rm -f "${to}"
    ln -s "${from}" "${to}" 2> /dev/null || sudo ln -s "${from}" "${to}"
}

my:run_files() {
    sort -zn | xargs -0 -I '{}' bash '{}' \;
}


################################### INSTALL ###################################

my:dnf_install() {
    my:echo_substep "Installing '$1'"
    sudo dnf install -y -q "$@"
    my:echo_substep "Installed '$1'"
}

my:git_clone() {
    local repository="$1"
    local directory="$2"

    if [ -d "${directory}" ]; then
        local previous_dir="$PWD"
        cd "${directory}"
        my:echo_substep "Updating repo '${directory}'"
        git remote set-url origin "${repository}"
        if [ "$(git symbolic-ref --short -q HEAD)" ]; then
            git pull --rebase
        else
            git fetch
        fi
        cd "$previous_dir"
    else
        git clone "${repository}" "${directory}"
    fi
}

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

# my:step
my:step_begin() {
    local step="$1"

    if [ -z "${step-}" ]; then
        my:echo_error 'step name not given'
    fi

    if [ -z "${current_step-}" ]; then
        current_step="${step}"
        my:step_echo "start: ${current_step}"
    else
        my:echo_error "can't start step '${step}', step '${current_step}' not ended"
    fi
}

my:step_end() {
    if [ -n "${current_step-}" ]; then
        my:step_echo "done: ${current_step}"
        echo ''
        unset current_step
    else
        my:echo_error "no step to end"
    fi
}


my:step_echo() {
    local message="$1"
    echo "$(tput setab 7)$(tput setaf 0)${message}$(tput el)$(tput sgr0)"
}


# my:echo
my:echo_substep() {
    local message="$1"
    echo "$(tput bold)$(tput setaf 4)${message}$(tput el)$(tput sgr0)"
}

my:echo_error() {
    local message="$1"
    echo "$(tput setab 1)$(tput setaf 0)${message}$(tput el)$(tput sgr0)"
}

#################################### CHECK #####################################

my:command_exists () {
    local command="$1"
    type "${command}" &> /dev/null
}


################################################################################

my:file_run_begin "$CURRENT_SCRIPT"

function on_exit {
    my:file_run_end "$CURRENT_SCRIPT"
}

trap on_exit EXIT
