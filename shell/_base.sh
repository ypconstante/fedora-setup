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
export CURRENT_SCRIPT_PATH=$(realpath "${BASH_SOURCE[1]}")
export CURRENT_SCRIPT=$(basename "$CURRENT_SCRIPT_PATH")

source /etc/os-release

source "${ASSETS_DIR}/base--env"

#################################### FILE #####################################

my:append_to_file_if_not_contains() {
    local file="$1"
    local content="$2"

    my:create_file "$file"

    if ! my:file_contains_line "$file" "$content"; then
        if [ -w "$file" ]; then
            echo "$content" | tee -a "$file" 1> /dev/null
        else
            echo "$content" | sudo tee -a "$file" 1> /dev/null
        fi
    fi
}


my:create_file() {
    local file="$1"
    my:create_parent_dirs "${file}"
    touch "$file" 2> /dev/null || sudo touch "$file"
}

my:create_parent_dirs() {
    local file="$1"
    local parents=$(dirname "${file}")
    mkdir -p "${parents}" 2> /dev/null || sudo mkdir -p "${parents}"
}

my:file_contains_line() {
    local file="$1"
    local content="$2"
    grep -Fxq "$content" "$file"
}

my:link_file() {
    local from="$1"
    local to="$2"

    my:create_parent_dirs "${to}"

    rm -f "${to}" 2> /dev/null || sudo rm -f "${to}"
    ln "${from}" "${to}" 2> /dev/null \
        || sudo ln "${from}" "${to}" 2> /dev/null \
        || cp "${from}" "${to}" 2> /dev/null \
        || sudo cp "${from}" "${to}"
}

my:run_files() {
    sort -zn | xargs -0 -I '{}' bash '{}' \;
}

my:wait_file() {
    local file="$1"
    local time_waiting=0;

    until [ -f "$file" ]; do
        sleep 1
        ((time_waiting++))
        if [[ $time_waiting -eq 2 ]]; then
            my:echo_without_line_break "Waiting file '$file' to be created "
        elif [[ $time_waiting -gt 2 ]]; then
            my:echo_without_line_break "#"
        fi
        if [[ $time_waiting -gt 20 ]]; then
            echo ''
            my_echo_error 'File still not created after 20 '
            return 1
        fi
    done

    if [[ $time_waiting -ge 2 ]]; then
        echo ''
        echo 'File created'
    fi
}


################################### INSTALL ###################################

my:dnf_install() {
    my:echo_substep "Installing '$1'"
    sudo dnf install -y -q "$@"
    my:echo_substep "Installed '$1'"
}

my:dnf_remove() {
    my:echo_substep "Removing '$1'"
    sudo dnf remove -y -q "$@"
    my:echo_substep "Removed '$1'"
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

my:echo_without_line_break() {
    local message="$1"
    echo -n "$message"
}

#################################### CHECK #####################################

my:command_exists () {
    local command="$1"
    type "${command}" &> /dev/null
}

my:should_skip_file() {
    local path="$1"
    local filename=$(basename "$path")

    if [[ "$filename" == *"_de_"* ]]; then
        local wanted_de=$(echo "$filename" | cut -d '.' -f 1 | rev | cut -d '_' -f 1 | rev)
        local current_de="$DESKTOP_SESSION"

        if [ "$wanted_de" != "$current_de" ]; then
            echo "current desktop is ${current_de}"
        fi
    fi
}

################################################################################


my:file_run_begin "$CURRENT_SCRIPT"

function on_exit {
    my:file_run_end "$CURRENT_SCRIPT"
}

trap on_exit EXIT

skip_cause=$(my:should_skip_file "$CURRENT_SCRIPT")
if [ -n "$skip_cause" ]; then
    echo "${skip_cause}, skipping"
    exit 0
else
    echo ''
fi
