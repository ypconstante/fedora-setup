#!/bin/bash

FORCE_RUN_AS_ROOT=1 source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

source /etc/os-release

set -euxo pipefail

read -r -p 'install id: ' os_install_id
if [ -z "$os_install_id" ]; then
    my:echo_error "os_install_id is mandatory"
    exit 1
fi

read -r -p 'partition size: ' os_partition_size
if [ -z "$os_partition_size" ]; then
    my:echo_error "os_partition_size is mandatory"
    exit 1
fi

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
    echo "${result:-2}"
}

global_efi_partition_id=1
lvm_partition_id=2
os_efi_partition_id=$(("$(highest_partition_id)" + 1))
boot_partition_id=$(("$(highest_partition_id)" + 2))

global_efi_partition_path="${disk_partition_path_prefix}${global_efi_partition_id}"
lvm_partition_path="${disk_partition_path_prefix}${lvm_partition_id}"
os_efi_partition_path="${disk_partition_path_prefix}${os_efi_partition_id}"
boot_partition_path="${disk_partition_path_prefix}${boot_partition_id}"

# lvm
main_vg='main_vg'
encrypted_volume_name="${os_install_id}_encrypted_lv"
encrypted_volume_path="/dev/mapper/${main_vg}-${encrypted_volume_name}"
decrypted_partition_name="${os_install_id}-decrypted"
decrypted_partition_path="/dev/mapper/${decrypted_partition_name}"

create_common_partition() {
    if [ -e $global_efi_partition_path ]; then
        echo 'common partitions already created, skipping'
        return 0
    fi

    # create a new GPT partition table
    sgdisk -g $disk_path
    partprobe $disk_path

    # global efi partition
    sgdisk \
        --new "${global_efi_partition_id}::+128M" \
        --typecode "${global_efi_partition_id}:ef00" \
        --change-name "${global_efi_partition_id}:Global EFI" \
        $disk_path
    partprobe $disk_path

    mkfs.fat -F32 $global_efi_partition_path -n 'GLOBAL_EFI'

    # lvm partition
    sgdisk \
        --new "${lvm_partition_id}:3G:" \
        --change-name "${lvm_partition_id}:LVM" \
        $disk_path
    partprobe $disk_path

    pvcreate $lvm_partition_path
    vgcreate $main_vg $lvm_partition_path
}

create_os_partition() {
    vgchange -ay $main_vg

    # root
    lvcreate --size "${os_partition_size}" --name $encrypted_volume_name $main_vg
    cryptsetup luksFormat --type luks2 -v -y $encrypted_volume_path
    cryptsetup luksOpen -v $encrypted_volume_path $decrypted_partition_name
    mkfs.btrfs -L "${decrypted_partition_name}" $decrypted_partition_path

    # os efi
    sgdisk \
        --new "${os_efi_partition_id}::+128M" \
        --typecode "${os_efi_partition_id}:ef00" \
        --change-name "${os_efi_partition_id}:${capitalized_os_install_id} EFI" \
        $disk_path
    partprobe $disk_path

    mkfs.fat -F32 $os_efi_partition_path -n "${capitalized_os_install_id}"

    # boot
    sgdisk \
        --new "${boot_partition_id}::+512M" \
        --change-name "${boot_partition_id}:${capitalized_os_install_id} Boot" \
        $disk_path
    partprobe $disk_path

    mkfs.ext4 $boot_partition_path -L "${capitalized_os_install_id} Boot"
}

run_install() {
    echo "
        installation config

        partition
            - advanced custom

            - ${os_efi_partition_path} - /boot/efi
            - ${boot_partition_path} - /boot

            - select ${decrypted_partition_name}
            - add subvolume
                - name root
                - mountpoint /
    "

    liveinst
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
        | sort -z -k 1,1 -t .\
        | xargs -0 cat \
        > /boot/efi/EFI/refind/refind-menu.conf
}

create_common_partition
create_os_partition
run_install
install_refind
