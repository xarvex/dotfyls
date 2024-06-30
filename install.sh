#!/usr/bin/env sh

set -e

confirm() {
    while true; do
        printf '%s' "${1} [y/N] "
        read -r response
        case ${response} in
            '' ) return 1;;
            [Nn]* ) return 1;;
            [Yy]* ) return;;
        esac
    done
}

cat << EOF
WARNING: the entire disk will be formatted

ZFS datasets:
    - zroot/root (mounted at / with blank snapshot)
    - zroot/nix (mounted at /nix)
    - zroot/tmp (mounted at /tmp)
    - zroot/persist (mounted at /persist)
    - zroot/persist/cache (mounted at /persist/cache)

EOF

if [ -b /dev/vda ]; then
    printf '\n%s\n' 'Virtual disk found, selecting /dev/vda'

    disk=/dev/vda
    boot_disk=${disk}3
    swap_disk=${disk}2
    zfs_disk=${disk}1
else
    while [ ! -L "${disk}" ]; do
        printf '\n%s\n\n%s' \
            "$(lsblk -pdo NAME,SIZE,VENDOR,MODEL,SERIAL,ID-LINK)" \
            'Enter disk ID to be formatted: '
        read -r disk_id

        disk=/dev/disk/by-id/"${disk_id}"
    done
    boot_disk="${disk}"-part3
    swap_disk="${disk}"-part2
    zfs_disk="${disk}"-part1
fi

confirm 'This will format the entire disk. All data will be destroyed, proceed?' || exit 2

printf '%s\n' 'Clearing partitions...'
sudo wipefs -a "${disk}"

printf '%s\n' 'Creating partitions...'
sudo sgdisk -n3:1M:+1G -t3:EF00 "${disk}"
sudo sgdisk -n2:0:+$(($(grep MemTotal /proc/meminfo | awk '{print $2}') * 2))K -t2:8200 "${disk}"
sudo sgdisk -n1:0:0 -t1:BF01 "${disk}"

printf '%s\n' 'Notifying kernel...'
sudo sgdisk -p "${disk}" > /dev/null
sleep 5

printf '%s\n' 'Enabling swap...'
sudo mkswap "${swap_disk}" --label SWAP
sudo swapon "${swap_disk}"

printf '%s\n' 'Configuring boot...'
sudo mkfs.fat -F 32 "${boot_disk}" -n NIXBOOT

printf '%s\n' 'Creating zpool...'
sudo zpool create -f \
    -o ashift=12 \
    -o autotrim=on \
    -O compression=zstd \
    -O acltype=posixacl \
    -O atime=off \
    -O xattr=sa \
    -O normalization=formD \
    -O mountpoint=none \
    zroot "${zfs_disk}"

printf '%s\n' 'Creating / (ZFS)...'
sudo zfs create -o mountpoint=legacy zroot/root
sudo zfs snapshot zroot/root@blank
printf '%s\n' 'Mounting / (ZFS)...'
sudo mount -t zfs zroot/root /mnt

printf '%s\n' 'Mounting /boot (EFI)...'
sudo mount -o umask=077 --mkdir "${boot_disk}" /mnt/boot

printf '%s\n' 'Creating /nix (ZFS)...'
printf '%s\n' 'Mounting /nix (ZFS)...'
sudo zfs create -o mountpoint=legacy zroot/nix
sudo mount --mkdir -t zfs zroot/nix /mnt/nix

printf '%s\n' 'Creating /tmp (ZFS)...'
sudo zfs create -o mountpoint=legacy zroot/tmp
printf '%s\n' 'Mounting /tmp (ZFS)...'
sudo mount --mkdir -t zfs zroot/tmp /mnt/tmp

printf '%s\n' 'Creating /cache (ZFS)...'
sudo zfs create -o mountpoint=legacy zroot/cache
printf '%s\n' 'Mounting /cache (ZFS)...'
sudo mount --mkdir -t zfs zroot/cache /mnt/cache

if confirm 'Restore from persist snapshot?'; then
    printf '%s\n' 'Enter full path to snapshot: '
    read -r snapshot_path

    printf '%s\n' 'Restoring /persist (ZFS)...'
    # sudo doesn't affect redirects.
    # shellcheck disable=SC2024
    sudo zfs receive -o mountpoint=legacy zroot/persist < "${snapshot_path}"
else
    printf '%s\n' 'Creating /persist (ZFS)...'
    sudo zfs create -o mountpoint=legacy zroot/persist
fi
printf '%s\n' 'Mounting /persist (ZFS)...'
sudo mount --mkdir -t zfs zroot/persist /mnt/persist

printf '%s' 'Specify host to install: '
read -r host

printf '%s' 'Specify rev to install (default: main): '
read -r rev

printf '%s\n' 'Running install...'
sudo nixos-install --no-root-password --flake gitlab:dotfyls/dotfyls/"${rev:-main}"#"${host}"
