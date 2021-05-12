#!/bin/bash

FORCE_RUN_AS_ROOT=1 source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

source /etc/os-release

set -euxo pipefail

os_install_id=''
os_partition_size=''

capitalized_os_install_id=$(echo "$os_install_id" | sed 's/[^ _-]*/\u&/g')

# disk variables
disk_name='nvme0n1'
disk_partition_id_prefix='p'

if [ ! -e "/dev/${disk_name}" ]; then
    disk_name='sda'
    disk_partition_id_prefix=''
fi

disk_path="/dev/${disk_name}"
disk_partition_name_prefix="${disk_name}${disk_partition_id_prefix}"
disk_partition_path_prefix="/dev/${disk_partition_name_prefix}"

# partitions
highest_partition_id() {
    local result=$(
        find /dev -maxdepth 1 -name "${disk_partition_name_prefix}*" -not -name "${disk_partition_name_prefix}" \
            | sort -n \
            | tail -n1 \
            | sed "s|^${disk_partition_path_prefix}||"
    )
    echo "${result:-1}"
}

os_efi_partition_id=$(("$(highest_partition_id)" + 1))
boot_partition_id=$(("$(highest_partition_id)" + 2))
encrypted_partition_id=$(("$(highest_partition_id)" + 3))

global_efi_partition_path="${disk_partition_path_prefix}1"
os_efi_partition_path="${disk_partition_path_prefix}${os_efi_partition_id}"

if [ -z "$os_install_id" ]; then
    my:echo_error "os_install_id is mandatory"
    exit 1
fi

if [ -z "$os_partition_size" ]; then
    my:echo_error "os_partition_size is mandatory"
    exit 1
fi

setup_efi_partition() {
    if [ -e $global_efi_partition_path ]; then
        echo 'efi partition already created, skipping'
        return 0
    fi

    # create a new GPT partition table
    sgdisk -g $disk_path

    # efi partition
    sgdisk \
        --new 1::+128M \
        --typecode 1:ef00 \
        --change-name '1:Global EFI' \
        $disk_path
    partprobe "$disk_path"

    mkfs.fat -F32 $global_efi_partition_path -n 'GLOBAL_EFI'
}

setup_os_efi_partition() {
    sgdisk \
        --new "${os_efi_partition_id}::+128M" \
        --typecode "${os_efi_partition_id}:ef00" \
        --change-name "${os_efi_partition_id}:${capitalized_os_install_id} EFI" \
        $disk_path
    partprobe "$disk_path"

    mkfs.fat -F32 $os_efi_partition_path -n "${capitalized_os_install_id}"
}

run_install() {
    echo "
        installation config

        partition
            - custom

            - encrypt my data
            - create automatically

            - select root
            - modify volume
            - size fixed - ${os_partition_size}

            - select boot
            - size 512M
            - label '${capitalized_os_install_id} Boot'

            - change /boot/efi to ${os_efi_partition_path}
    "

    liveinst
}

setup_os_partitions() {
    sgdisk \
        --change-name "${boot_partition_id}:${capitalized_os_install_id} Boot" \
        --change-name "${encrypted_partition_id}:${capitalized_os_install_id} Crypt" \
        $disk_path
}

install_refind() {
    installer=/tmp/refind.rpm
    curl -L https://sourceforge.net/projects/refind/files/0.13.2/refind-0.13.2-1.x86_64.rpm/download -o $installer
    rpm -U $installer --force
    rm -f $installer

    theme_zip=/tmp/theme.zip
    curl -L https://github.com/bobafetthotmail/refind-theme-regular/archive/refs/heads/master.zip -o $theme_zip
    unzip -q $theme_zip -d /tmp
    rm -f $theme_zip

    theme_dir=/boot/efi/EFI/refind/refind-theme-regular
    rm -rf $theme_dir
    mv /tmp/refind-theme-regular-master $theme_dir
    rm -rf $theme_dir/src

    cp "${ASSETS_DIR}/install--refind.conf" /boot/efi/EFI/refind/refind.conf

    echo "
      menuentry \"Fedora\" {
        ostype Linux
        icon /EFI/refind/refind-theme-regular/icons/128-48/os_fedora.png
        volume ${capitalized_os_install_id}
        loader /EFI/fedora/grubx64.efi
      }
    " > "/boot/efi/EFI/refind/refind-menu-item-${os_install_id}.conf"

    rm -f /boot/efi/EFI/refind/refind-menu.conf

    find /boot/efi/EFI/refind -name 'refind-menu-item-*.conf' -print0 \
        | sort -zn \
        | xargs -0 cat \
        > /boot/efi/EFI/refind/refind-menu.conf
}

setup_efi_partition
setup_os_efi_partition
run_install
setup_os_partitions
install_refind
