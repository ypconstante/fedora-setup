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

sudo true || exit

if [ "${#BASH_SOURCE[@]}" == 1 ]; then
    # _base not called by another script, for example my:toolbox-run
    export CURRENT_SCRIPT=""
else
    export CURRENT_SCRIPT_PATH=$(realpath "${BASH_SOURCE[1]}")
    export CURRENT_SCRIPT=$(basename "$CURRENT_SCRIPT_PATH")
fi

export BASE_FILE_PATH=$(realpath "${BASH_SOURCE[0]}")
export SCRIPTS_DIR=$(dirname "$BASE_FILE_PATH")
export PROJECT_DIR=$(realpath "$SCRIPTS_DIR/..")
export ASSETS_DIR=$(realpath "$PROJECT_DIR/assets")

cd "$SCRIPTS_DIR"

source "$ASSETS_DIR/base--env"

#################################### FILE #####################################

my:append-to-file-if-not-contains() {
    local file="$1"
    local content="$2"

    my:create-file "$file"

    if ! my:file-contains-line "$file" "$content"; then
        if [ -w "$file" ]; then
            echo "$content" | tee -a "$file" 1> /dev/null
        else
            echo "$content" | sudo tee -a "$file" 1> /dev/null
        fi
    fi
}


my:create-file() {
    local file="$1"
    my:create-parent-dirs "${file}"
    touch "$file" 2> /dev/null || sudo touch "$file"
}

my:create-parent-dirs() {
    local file="$1"
    local parents=$(dirname "${file}")
    mkdir -p "${parents}" 2> /dev/null || sudo mkdir -p "${parents}"
}

my:file-contains-line() {
    local file="$1"
    local content="$2"
    grep -Fxq "$content" "$file" 2> /dev/null || sudo grep -Fxq "$content" "$file"
}

my:link-file() {
    local FROM="$1"
    local TO="$2"

    my:create-parent-dirs "$TO"

    ln -f "$FROM" "$TO" \
        || cp "$FROM" "$TO" 2> /dev/null \
        || cp "$FROM" "$TO"
}

my:copy-file() {
    local FROM="$1"
    local TO="$2"

    my:create-parent-dirs "$TO"

    cp "$FROM" "$TO" 2> /dev/null \
        || sudo cp "$FROM" "$TO" 2> /dev/null \
        || sudo cp "$FROM" "$TO"
}

my:run-files() {
    sort -zn | xargs -0 -I '{}' bash '{}' \;
}

my:wait-file() {
    local file="$1"
    local time_waiting=0;

    until [ -f "$file" ]; do
        sleep 1
        ((time_waiting++))
        if [[ $time_waiting -gt 20 ]]; then
            echo ''
            my:echo-error 'File not created after 20 seconds'
            return 1
        elif [[ $time_waiting -eq 2 ]]; then
            my:echo-without-line-break "Waiting for file '$file' to be created "
        elif [[ $time_waiting -gt 2 ]]; then
            my:echo-without-line-break "#"
        fi
    done

    if [[ $time_waiting -ge 2 ]]; then
        echo ''
        echo 'File created'
    fi
}


################################### INSTALL ###################################

# my:dnf
my:dnf-install() {
    sudo dnf install -y -q "$@"
}

my:dnf-add-key() {
    local url="$1"
    sudo rpm -v --import "$url"
}

my:dnf-add-repo() {
    local url="$1"
    sudo dnf config-manager --add-repo "$url"
}

my:dnf-remove() {
    sudo dnf remove -y -q "$@"
}

# my:flatpak
my:flatpak-install() {
    flatpak install -y flathub "$@"
    sleep 0.5
    echo ''
}

# my:asdf
my:asdf-add-plugin() {
    local plugin="$1"

    source "$ASDF_DIR/asdf.sh"

    asdf plugin-add "${plugin}"
    asdf list-all "${plugin}" 1> /dev/null
}

my:asdf-install-and-set-global() {
    my:toolbox-run my:asdf-install-and-set-global-local "$@"
}

my:asdf-install-and-set-global-local() {
    local plugin="$1"
    local version="$2"

    source "$ASDF_DIR/asdf.sh"

    # avoid permission error with plugins using current dir as temporary dir
    previous_dir="$PWD"
    cd /tmp

    my:echo-substep "Installing version $version"
    asdf install "$plugin" "$version"
    asdf global "$plugin" "$version"

    cd "$previous_dir"
}

# my:git
my:git-clone() {
    local REPOSITORY="$1"
    local DIRECTORY="$2"

    if [ -d "$DIRECTORY" ]; then
        my:echo-substep "Updating repo '$DIRECTORY'"
        git -C "$DIRECTORY" remote set-url origin "$REPOSITORY"
        local CURRENT_BRANCH=$(git -C "$DIRECTORY" symbolic-ref --short -q HEAD)
        if [ -n "$CURRENT_BRANCH" ]; then
            echo "Pulling changes"
            git -C "$DIRECTORY" pull --rebase --prune
        else
            echo "Fetching changes"
            git -C "$DIRECTORY" fetch --prune
        fi
    else
        git clone "$REPOSITORY" "$DIRECTORY"
    fi
}

################################### TOOLBOX ####################################

my:toolbox-run() {
    SCRIPT="source '$SCRIPTS_DIR/_base.sh';${*@Q};"

    toolbox run -c "$TOOLBOX_CONTAINER" bash -c "$SCRIPT"

    podman container stop "$TOOLBOX_CONTAINER" 1> /dev/null
}

my:toolbox-dnf-install() {
    my:toolbox-run my:dnf-install "$@"
}

#################################### PRINT #####################################

# my:file-run
my:file-run-begin() {
    local file="$1"
    my:file-run-echo "FILE BEGIN: ${file}"
}

my:file-run-end() {
    local file="$1"
    echo ''
    my:file-run-echo "FILE END: ${file}"
    echo ''
}

my:file-run-echo() {
    local message="$1"
    echo "$(tput setab 4)$(tput setaf 0)${message}$(tput el)$(tput sgr0)"
}

# my:step
my:step-begin() {
    local step="$1"

    if [ -z "${step-}" ]; then
        my:echo-error 'step name not given'
    else
        echo ''
        my:echo-step "step: ${step}"
    fi
}

# my:echo
my:echo-step() {
    local message="$1"
    echo "$(tput setab 7)$(tput setaf 0)${message}$(tput el)$(tput sgr0)"
}

my:echo-substep() {
    local message="$1"
    echo "$(tput bold)$(tput setaf 4)${message}$(tput el)$(tput sgr0)"
}

my:echo-error() {
    local message="$1"
    echo "$(tput setab 1)$(tput setaf 0)${message}$(tput el)$(tput sgr0)"
}

my:echo-without-line-break() {
    local message="$1"
    echo -n "$message"
}

#################################### CHECK #####################################

my:command-exists () {
    local command="$1"
    type "${command}" &> /dev/null
}

my:should-skip-file() {
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

if [ -n "$CURRENT_SCRIPT" ]; then
    my:file-run-begin "$CURRENT_SCRIPT"

    function on_exit {
        my:file-run-end "$CURRENT_SCRIPT"
    }

    trap on_exit EXIT

    skip_cause=$(my:should-skip-file "$CURRENT_SCRIPT")
    if [ -n "$skip_cause" ]; then
        echo "${skip_cause}, skipping"
        exit 0
    fi
fi
