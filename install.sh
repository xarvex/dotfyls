#!/usr/bin/env sh

set -o errexit
set -o nounset
set -o pipefail

reset=$(tput sgr0)
# black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
# white=$(tput setaf 7)

confirm() {
    while true; do
        printf "${red}%s${reset}" "${1} [y/N] "
        read -r response
        case ${response} in
            '' ) return 1;;
            [Nn]* ) return 1;;
            [Yy]* ) return;;
        esac
    done
}

printf "${yellow}%s${reset}\n\n" "WARNING: the entire disk will be formatted"

cat << EOF
${cyan}ZFS datasets:
    - zroot/root (mounted at / with blank snapshot)
    - zroot/nix (mounted at /nix)
    - zroot/tmp (mounted at /tmp)
    - zroot/persist (mounted at /persist)
    - zroot/persist/cache (mounted at /persist/cache)${reset}

EOF

if [ -b /dev/vda ]; then
    printf "\n${green}%s${reset}\n" 'Virtual disk found, selecting /dev/vda'

    disk=/dev/vda
    boot_disk=${disk}3
    swap_disk=${disk}2
    zfs_disk=${disk}1
else
    while [ ! -L "${disk:-}" ]; do
        printf "\n%s\n\n${magenta}%s${reset}" \
            "$(lsblk -pdo NAME,SIZE,VENDOR,MODEL,SERIAL,ID-LINK)" \
            'Enter disk ID to be formatted: '
        read -r disk_id

        disk=/dev/disk/by-id/"${disk_id}"
    done
    boot_disk="${disk}"-part3
    swap_disk="${disk}"-part2
    zfs_disk="${disk}"-part1
fi

encryption_options=()
if confirm 'Use disk encryption?'; then
    encryption_options=(-O encryption=aes-256-gcm -O keyformat=passphrase -O keylocation=prompt)
fi

confirm 'This will format the entire disk. All data will be destroyed, proceed?' || exit 2

printf "${blue}%s${reset}\n" 'Clearing partitions...'
sudo wipefs -a "${disk}"

printf "${blue}%s${reset}\n" 'Creating partitions...'
sudo sgdisk -n3:1M:+1G -t3:EF00 "${disk}"
sudo sgdisk -n2:0:+$(($(grep MemTotal /proc/meminfo | awk '{print $2}') * 2))K -t2:8200 "${disk}"
sudo sgdisk -n1:0:0 -t1:BF01 "${disk}"

printf "${blue}%s${reset}\n" 'Notifying kernel...'
sudo sgdisk -p "${disk}" > /dev/null
sleep 5

printf "${blue}%s${reset}\n" 'Enabling swap...'
sudo mkswap "${swap_disk}" --label SWAP
sudo swapon "${swap_disk}"

printf "${blue}%s${reset}\n" 'Configuring boot...'
sudo mkfs.fat -F 32 "${boot_disk}" -n NIXBOOT

printf "${blue}%s${reset}\n" 'Creating zpool...'
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
    zroot "${zfs_disk}"

printf "${blue}%s${reset}\n" 'Creating / (ZFS)...'
sudo zfs create -o mountpoint=legacy zroot/root
sudo zfs snapshot zroot/root@blank
printf "${blue}%s${reset}\n" 'Mounting / (ZFS)...'
sudo mount -t zfs zroot/root /mnt

printf "${blue}%s${reset}\n" 'Mounting /boot (EFI)...'
sudo mount -o umask=077 --mkdir "${boot_disk}" /mnt/boot

printf "${blue}%s${reset}\n" 'Creating /nix (ZFS)...'
printf "${blue}%s${reset}\n" 'Mounting /nix (ZFS)...'
sudo zfs create -o mountpoint=legacy zroot/nix
sudo mount --mkdir -t zfs zroot/nix /mnt/nix

printf "${blue}%s${reset}\n" 'Creating /tmp (ZFS)...'
sudo zfs create -o mountpoint=legacy zroot/tmp
printf "${blue}%s${reset}\n" 'Mounting /tmp (ZFS)...'
sudo mount --mkdir -t zfs zroot/tmp /mnt/tmp

printf "${blue}%s${reset}\n" 'Creating /cache (ZFS)...'
sudo zfs create -o mountpoint=legacy zroot/cache
printf "${blue}%s${reset}\n" 'Mounting /cache (ZFS)...'
sudo mount --mkdir -t zfs zroot/cache /mnt/cache

if confirm 'Restore from persist snapshot?'; then
    printf "${magenta}%s${reset}" 'Enter full path to snapshot: '
    read -r snapshot_path

    printf "${blue}%s${reset}\n" 'Restoring /persist (ZFS)...'
    # sudo doesn't affect redirects.
    # shellcheck disable=SC2024
    sudo zfs receive -o mountpoint=legacy zroot/persist < "${snapshot_path}"
else
    printf "${blue}%s${reset}\n" 'Creating /persist (ZFS)...'
    sudo zfs create -o mountpoint=legacy zroot/persist
fi
printf "${blue}%s${reset}\n" 'Mounting /persist (ZFS)...'
sudo mount --mkdir -t zfs zroot/persist /mnt/persist

printf "${magenta}%s${reset}" 'Specify host to install: '
read -r host

printf "${magenta}%s${reset}" 'Specify rev to install (default: main): '
read -r rev

printf "${blue}%s${reset}\n" 'Running install...'
nix-shell --extra-experimental-features 'nix-command flakes' -p git --command "sudo nixos-install --flake gitlab:dotfyls/dotfyls/${rev:-main}#${host}"
