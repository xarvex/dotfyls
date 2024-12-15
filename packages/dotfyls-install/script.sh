#!/bin/sh

set -o errexit
set -o nounset

confirm() {
    while :; do
        printf '%s %s ' "${1}" '[y/N]:'
        read -r response

        case ${response} in
        [Nn]* | '') return 1 ;;
        [Yy]*) return ;;
        esac
    done
}

reset=$(tput sgr0)
# black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
# white=$(tput setaf 7)

printf '%s%s%s\n\n' "${yellow}" 'WARNING: the entire disk will be formatted' "${reset}"

cat <<EOF
${cyan}ZFS datasets:
    - zroot/root (mounted at / with blank snapshot)
    - zroot/nix (mounted at /nix)
    - zroot/tmp (mounted at /tmp)
    - zroot/persist (mounted at /persist)
    - zroot/cache (mounted at /cache)${reset}

EOF

if [ -b /dev/vda ]; then
    printf '\n%s%s%s\n' "${green}" 'Virtual disk found, selecting /dev/vda' "${reset}"

    disk=/dev/vda
    boot_part=${disk}3
    swap_part=${disk}2
    main_part=${disk}1
else
    while [ ! -L "${disk:-}" ]; do
        printf '\n%s\n\n%s%s%s ' \
            "$(lsblk -pdo NAME,SIZE,VENDOR,MODEL,SERIAL,ID-LINK)" \
            "${magenta}" 'Enter disk ID to be formatted:' "${reset}"
        read -r disk_id

        disk="/dev/disk/by-id/${disk_id}"
    done
    boot_part="${disk}-part3"
    swap_part="${disk}-part2"
    main_part="${disk}-part1"
fi

encryption_options=()
if confirm "${red}Use disk encryption?${reset}"; then
    encryption_options=(-O encryption=aes-256-gcm -O keyformat=passphrase -O keylocation=prompt)
fi

confirm "${red}This will format the entire disk. All data will be destroyed, proceed?${reset}" || exit 2

printf '%s%s%s\n' "${blue}" 'Clearing partitions...' "${reset}"
sudo wipefs -a "${disk}"

printf '%s%s%s\n' "${blue}" 'Creating partitions...' "${reset}"
sudo sgdisk -n3:1M:+1G -t3:EF00 "${disk}"
sudo sgdisk -n2:0:+$(($(grep MemTotal /proc/meminfo | awk '{print $2}') * 2))K -t2:8200 "${disk}"
sudo sgdisk -n1:0:0 -t1:BF01 "${disk}"

printf '%s%s%s\n' "${blue}" 'Notifying kernel...' "${reset}"
sudo sgdisk -p "${disk}" >/dev/null
sleep 5

printf '%s%s%s\n' "${blue}" 'Enabling swap...' "${reset}"
sudo mkswap "${swap_part}" --label SWAP
sudo swapon "${swap_part}"

printf '%s%s%s\n' "${blue}" 'Configuring boot...' "${reset}"
sudo mkfs.fat -F 32 "${boot_part}" -n NIXBOOT

printf '%s%s%s\n' "${blue}" 'Creating zpool...' "${reset}"
sudo zpool create -f \
    -o ashift=12 \
    -o autotrim=on \
    -O compression=zstd \
    -O acltype=posixacl \
    -O atime=off \
    -O xattr=sa \
    -O normalization=formD \
    -O mountpoint=none \
    "${encryption_options[@]}" \
    zroot "${main_part}"

printf '%s%s%s\n' "${blue}" 'Creating / (ZFS)...' "${reset}"
sudo zfs create -o mountpoint=legacy zroot/root
sudo zfs snapshot zroot/root@blank
printf '%s%s%s\n' "${blue}" 'Mounting / (ZFS)...' "${reset}"
sudo mount -t zfs zroot/root /mnt

printf '%s%s%s\n' "${blue}" 'Mounting /boot (ZFS)...' "${reset}"
sudo mount -o umask=077 --mkdir "${boot_part}" /mnt/boot

printf '%s%s%s\n' "${blue}" 'Creating /nix (ZFS)...' "${reset}"
sudo zfs create -o mountpoint=legacy zroot/nix
printf '%s%s%s\n' "${blue}" 'Mounting /nix (ZFS)...' "${reset}"
sudo mount --mkdir -t zfs zroot/nix /mnt/nix

printf '%s%s%s\n' "${blue}" 'Creating /tmp (ZFS)...' "${reset}"
sudo zfs create -o mountpoint=legacy zroot/tmp
printf '%s%s%s\n' "${blue}" 'Mounting /tmp (ZFS)...' "${reset}"
sudo mount --mkdir -t zfs zroot/tmp /mnt/tmp

printf '%s%s%s\n' "${blue}" 'Creating /cache (ZFS)...' "${reset}"
sudo zfs create -o mountpoint=legacy zroot/cache
printf '%s%s%s\n' "${blue}" 'Mounting /cache (ZFS)...' "${reset}"
sudo mount --mkdir -t zfs zroot/cache /mnt/cache

if confirm "${red}Restore from persist snapshot?${reset}"; then
    printf '%s%s%s ' "${magenta}" 'Enter full path to snapshot:' "${reset}"
    read -r snapshot_path

    printf '%s%s%s\n' "${blue}" 'Restoring /persist (ZFS)...' "${reset}"
    # sudo doesn't affect redirects.
    # shellcheck disable=SC2024
    sudo zfs receive -o mountpoint=legacy zroot/persist <"${snapshot_path}"
else
    printf '%s%s%s\n' "${blue}" 'Creating /persist (ZFS)...' "${reset}"
    sudo zfs create -o mountpoint=legacy zroot/persist
fi
printf '%s%s%s\n' "${blue}" 'Mounting /persist (ZFS)...' "${reset}"
sudo mount --mkdir -t zfs zroot/persist /mnt/persist

printf '%s%s%s ' "${magenta}" 'Specify host to install:' "${reset}"
read -r host

printf '%s%s%s ' "${magenta}" 'Specify rev to install (main):' "${reset}"
read -r rev

printf '$%s%s%s\n' "${blue}" 'Running install...' "${reset}"
sudo nixos-install --flake "gitlab:dotfyls/dotfyls/${rev:-main}#${host}"
nixos-enter --root /mnt -- persistwd populate-hashes
