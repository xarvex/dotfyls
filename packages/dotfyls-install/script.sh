#!/bin/sh

set -o errexit
set -o nounset

ascii_reset=$(tput sgr0)
ascii_black=$(tput setaf 0)
ascii_red=$(tput setaf 1)
ascii_green=$(tput setaf 2)
ascii_yellow=$(tput setaf 3)
ascii_blue=$(tput setaf 4)
ascii_magenta=$(tput setaf 5)
ascii_cyan=$(tput setaf 6)
ascii_white=$(tput setaf 7)

runtime_dir=${XDG_RUNTIME_DIR:-/run/user/$(id -a)}/dotfyls/install

mountpoint=/mnt

nix=$(which nix)
if [ -f /run/current-system/sw/bin/nix ]; then
    nix=/run/current-system/sw/bin/nix
fi
nix() {
    "${nix}" --option warn-dirty false --extra-experimental-features 'nix-command flakes' "${@}"
}

value_bool() {
    var=${1:-}

    [ "${var}" = 1 ] || [ "${var}" = true ]
}

is_dryrunning() {
    [ -z "${dryrun:-}" ] && dryrun=${DOTFYLS_DRYRUN:-false}
    value_bool "${dryrun}"
}

# Checks if in ISO environment by testing for read status on `/iso`.
# Arguments:
#   None
# Modified variables:
#   None
# Outputs:
#   return: Boolean truthiness on ISO presence
is_iso() {
    [ -r /iso ]
}

# `printf` wrapper supporting colors.
# Arguments:
#   text: string displayed to user
#   color: string specifying an ASCII color, 'none' can be specified to skip, defaults to 'blue'
#   extra_text: string displayed to user after color sequence, defaults to '\n'
# Prerequisite variables:
#   None
# Modified variables:
#   None
# Outputs:
#   None
display() {
    text=${1}
    color=${2:-blue}
    extra_text=${3:-'\n'}

    if [ "${color}" != none ]; then
        case ${color} in
        black) color=${ascii_black} ;;
        red) color=${ascii_red} ;;
        green) color=${ascii_green} ;;
        yellow) color=${ascii_yellow} ;;
        blue) color=${ascii_blue} ;;
        magenta) color=${ascii_magenta} ;;
        cyan) color=${ascii_cyan} ;;
        white) color=${ascii_white} ;;
        *) printf '%s%s%s\n' 'Invalid color ' "${color}" ' specified, ignoring' >&2 ;;
        esac

        printf '%s%s%s%b' "${color}" "${text}" "${ascii_reset}" "${extra_text}"
    else
        printf '%s%b' "${text}" "${extra_text}"
    fi
}

# Get yes or no input from the user, repeating if invalid response given.
# Arguments:
#   prompt: string displayed to user
#   color: string specifying an ASCII color, 'none' can be specified to skip, defaults to 'magenta'
# Prerequisite variables:
#   None
# Modified variables:
#   None
# Outputs:
#   return: Boolean for yes (true) or no (false)
confirm() {
    prompt=${1}
    color=${2:-magenta}

    while :; do
        display "${prompt}" "${color}" ' [y/N]: ' >&2
        read -r response

        case ${response} in
        '' | [Nn]*) return 1 ;;
        [Yy]*) return ;;
        esac
    done
}

# Get input from the user.
# Arguments:
#   prompt: string displayed to user
#   color: string specifying an ASCII color defaulting to 'magenta', 'none' can be specified to skip
# Prerequisite variables:
#   None
# Modified variables:
#   None
# Outputs:
#   stdout: string holding user response
prompt() {
    prompt=${1}
    color=${2:-magenta}

    display "${prompt}" "${color}" ': ' >&2
    read -r response

    printf '%s' "${response}"
}

# Tracer used for commands that should be shown in output.
# Arguments:
#   Passthrough to be executed
# Prerequisite variables:
#   None
# Modified variables:
#   None
# Outputs:
#   None
run() {
    printf '%s%s%s%s\n' "${ascii_cyan}" '>' "${ascii_reset}" " ${*}" >&2
    "${@}"
}

# Tracer used for `sudo` commands that should be shown in output.
# Arguments:
#   Passthrough to `sudo`
# Prerequisite variables:
#   None
# Modified variables:
#   None
# Outputs:
#   None
run_sudo() {
    printf '%s%s%s%s\n' "${ascii_magenta}" '>' "${ascii_reset}" " ${*}" >&2
    if ! is_dryrunning; then
        sudo "${@}"
    fi
}

command_present() {
    command=${1}

    command -v "${command}" >/dev/null
}

# Readies the flake configuration for usage, prompting the user.
# Arguments:
#   None
# Prerequisite variables:
#   None
# Modified variables:
#   flake: path to dotfyls flake config
#   rev: nullable string holding git revision, not set if `flake` was already present on filesystem
# Outputs:
#   None
get_flake() {
    if [ -z "${flake:-}" ]; then
        if [ -n "${DOTFYLS_FLAKE:-}" ]; then
            flake=${DOTFYLS_FLAKE}
        elif [ -f flake.nix ]; then
            flake=$(pwd)
        else
            flake=${HOME}/dotfyls
        fi
    fi

    if [ ! -d "${flake}" ]; then
        rev=$(prompt 'Specify flake rev to use (main)')

        display 'Pulling flake...'
        run git clone \
            --quiet ${rev:+--revision=${rev}} --depth 1 \
            --config advice.detachedHead=false \
            -- https://codeberg.org/xarvex/dotfyls.git "${flake}"
    fi
}

# Gets the relevant host for the flake configuration, prompting the user if necessary.
# Arguments:
#   None
# Prerequisite variables:
#   None
# Modified variables:
#   host: string holding user-specified host choice, or the output of `hostname` if not in an ISO environment
# Outputs:
#   None
get_host() {
    if [ -z "${host:-}" ]; then
        if is_iso; then
            host=$(prompt 'Specify host used')
        else
            host=$(hostname)
        fi
    fi
}

# Evaluate `config.dotfyls.filesystems` options from flake configuration.
# Arguments:
#   None
# Prerequisite variables:
#   flake: path to dotfyls flake config
#   host: string holding relevant host
# Modified variables:
#   filesystems: path to created JSON file outlining options
# Outputs:
#   None
get_filesystems() {
    filesystems=${runtime_dir}/filesystems.json
    mkdir -p "${runtime_dir}"
    run nix eval --json "${flake}"#nixosConfigurations."${host}".config.dotfyls.filesystems >"${filesystems}"

    filesystems_boot_label=
    filesystems_encrypt=
    filesystems_impermanence_enable=
    filesystems_main=
    filesystems_swap_enable=
    filesystems_swap_label=
    filesystems_zfs_pool=
}

# Extract option evaluated in `get_filesystems`.
# Arguments:
#   option: string referring to requested option key
#   use_rc: nullable boolean denoting whether to use `jq --exit-status`
# Prerequisite variables:
#   filesystems: path to JSON file outlining options
# Modified variables:
#   None
# Outputs:
#   rc: 2 if `jq` not present, may also be used along with `use_rc`
#   stdout: nullable any config result from `option` key, empty if `use_rc` is true
_get_filesystems_option() {
    option=${1}
    use_rc=${2:-}

    if command_present jq; then
        if value_bool "${use_rc}"; then
            run jq --raw-output --exit-status ".${option}" <"${filesystems}" >/dev/null
        else
            run jq --raw-output ".${option}" <"${filesystems}"
        fi
    else
        return 2
    fi
}

get_filesystems_boot_label() {
    if [ -z "${filesystems_boot_label:-}" ]; then
        filesystems_boot_label=$(_get_filesystems_option bootLabel || prompt 'Enter boot label')
    fi

    printf '%s' "${filesystems_boot_label}"
}

get_filesystems_encrypt() {
    if [ -z "${filesystems_encrypt:-}" ]; then
        filesystems_encrypt=1
        if _get_filesystems_option encrypt 1; then
            filesystems_encrypt=0
        elif [ "${?}" = 2 ] && confirm 'Encryption enabled?'; then
            filesystems_encrypt=0
        fi
    fi

    return "${filesystems_encrypt}"
}

get_filesystems_impermanence_enable() {
    if [ -z "${filesystems_impermanence_enable:-}" ]; then
        filesystems_impermanence_enable=1
        if _get_filesystems_option impermanence.enable 1; then
            filesystems_impermanence_enable=0
        elif [ "${?}" = 2 ] && confirm 'Impermanence enabled?'; then
            filesystems_impermanence_enable=0
        fi
    fi

    return "${filesystems_impermanence_enable}"
}

get_filesystems_main() {
    if [ -z "${filesystems_main:-}" ]; then
        filesystems_main=$(_get_filesystems_option main || prompt 'Enter main filesystem')
    fi

    printf '%s' "${filesystems_main}"
}

get_filesystems_swap_enable() {
    if [ -z "${filesystems_swap_enable:-}" ]; then
        filesystems_swap_enable=1
        if _get_filesystems_option swap.enable 1; then
            filesystems_swap_enable=0
        elif [ "${?}" = 2 ] && confirm 'Swap enabled?'; then
            filesystems_swap_enable=0
        fi
    fi

    return "${filesystems_swap_enable}"
}

get_filesystems_swap_label() {
    if [ -z "${filesystems_swap_label:-}" ]; then
        filesystems_swap_label=$(_get_filesystems_option swap.label || confirm 'Enter swap label')
    fi

    printf '%s' "${filesystems_swap_label}"
}

get_filesystems_zfs_pool() {
    if [ -z "${filesystems_zfs_pool:-}" ]; then
        filesystems_zfs_pool=$(_get_filesystems_option zfs.pool || confirm 'Enter ZFS pool')
    fi

    printf '%s' "${filesystems_zfs_pool}"
}

# Get disk and its partitions from the user, repeating if invalid response given. Will first try to guess with confirmation.
# Arguments:
#   None
# Prerequisite variables:
#   See `get_filesystems`
# Modified variables:
#   disk: path to selected block device, or `/dev/vda` if found
#   label_boot: string holding the label of the boot partition
#   label_main: string holding the label of the main partition
#   label_swap: string holding the label of the swap partition
#   part_boot: path to boot partition of `disk`
#   part_main: path to main partition of `disk`
#   part_swap: nullable path to swap partition of `disk`, unset if swap is not enabled, unless guessed
# Outputs:
#   None
select_disk() {
    num_main=1
    if get_filesystems_swap_enable; then
        num_boot=3
        num_swap=2
    else
        num_boot=2
    fi

    case "$(get_filesystems_main)" in
    zfs) label_main=$(get_filesystems_zfs_pool) ;;
    esac
    get_filesystems_swap_enable && label_swap=$(get_filesystems_swap_label)
    label_boot=$(get_filesystems_boot_label)

    if [ -b "/dev/disk/by-label/${label_main}" ]; then
        part_main=$(readlink -f "/dev/disk/by-label/${label_main}")
        display "Main partition found, selecting ${part_main}"
        disk_main=$(lsblk --nodeps --noheadings --output pkname "/dev/disk/by-label/${label_main}" --paths)

        if [ -b "/dev/disk/by-label/${label_boot}" ]; then
            part_boot=$(readlink -f "/dev/disk/by-label/${label_boot}")
            display "Boot partition found, selecting ${part_boot}"
            disk_boot=$(lsblk --nodeps --noheadings --output pkname "/dev/disk/by-label/${label_boot}" --paths)
        fi
        if [ -b "/dev/disk/by-label/${label_swap}" ]; then
            part_swap=$(readlink -f "/dev/disk/by-label/${label_swap}")
            display "Swap partition found, selecting ${part_swap}"
            disk_swap=$(lsblk --nodeps --noheadings --output pkname "/dev/disk/by-label/${label_swap}" --paths)
        fi

        if { [ "${disk_main:-}" != "" ] && [ "${disk_boot:-}" != "" ] && [ "${disk_main}" != "${disk_boot}" ]; } ||
            { [ "${disk_main:-}" != "" ] && [ "${disk_swap:-}" != "" ] && [ "${disk_main}" != "${disk_swap}" ]; } ||
            { [ "${disk_boot:-}" != "" ] && [ "${disk_swap:-}" != "" ] && [ "${disk_boot}" != "${disk_swap}" ]; }; then
            display 'Multi-disk system setups are not currently supported, aborting.' red >&2
            exit 1
        fi
        disk=${disk_main}
    elif [ -b /dev/vda ]; then
        display 'Virtual disk found, selecting /dev/vda' green

        disk=/dev/vda
        part_main=${disk}${num_main}
        part_boot=${disk}${num_boot}
        get_filesystems_swap_enable && part_swap=${disk}${num_swap}
    fi

    if [ -n "${disk:-}" ]; then
        display "Disk ${disk} resolved and selected" green
        printf '\n'
        lsblk --output NAME,SIZE,VENDOR,MODEL,SERIAL,ID-LINK "${disk}"
    fi

    while [ -z "${disk:-}" ] || ! confirm "Confirm? Certain operations may be destructive."; do
        while [ ! -L "${disk:-}" ]; do
            printf '\n'
            lsblk --nodeps --output NAME,SIZE,VENDOR,MODEL,SERIAL,ID-LINK
            disk_id=$(prompt 'Enter disk ID')

            disk=/dev/disk/by-id/${disk_id}
        done
        part_main=${disk}-part${num_main}
        part_boot=${disk}-part${num_boot}
        get_filesystems_swap_enable && part_swap=${disk}-part${num_swap}

        printf '\n'
        lsblk --output NAME,SIZE,VENDOR,MODEL,SERIAL,ID-LINK "${disk}"
    done
}

part_main_create() {
    display 'Creating main partition...'
    run_sudo sgdisk "-n${num_main}:0:0" "-t${num_main}:BF01" "${disk}"
}

part_main_erase() {
    display 'Erasing main partition...'

    label_real=${label_main}
    [ ! -b "/dev/disk/by-label/${label_real}" ] && label_real=$(prompt 'Enter label used for main partition')

    part_boot=$(readlink -f "/dev/disk/by-label/${label_real}")

    display 'Wiping main partition...'
    run_sudo wipefs --all "/dev/disk/by-label/${label_real}"
}

_part_main_format_zfs() {
    run_sudo zpool create -f \
        -o ashift=12 \
        -o autotrim=on \
        -O compression=zstd \
        -O acltype=posixacl \
        -O atime=off \
        -O xattr=sa \
        -O normalization=formD \
        -O mountpoint=none \
        "${@}" zroot "${part_main}"
}

part_main_format() {
    do_mount=${1:-}

    filesystem=$(get_filesystems_main)
    case ${filesystem} in
    zfs)
        if get_filesystems_encrypt; then
            _part_main_format_zfs -O encryption=aes-256-gcm -O keyformat=passphrase -O keylocation=prompt
        else
            _part_main_format_zfs
        fi

        display 'Creating ZFS volume /nix...'
        run_sudo zfs create -o mountpoint=legacy "${label_main}/nix"

        display 'Creating ZFS volume /persist...'
        run_sudo zfs create -o mountpoint=legacy "${label_main}/persist"

        display 'Creating ZFS volume /cache...'
        run_sudo zfs create -o mountpoint=legacy "${label_main}/cache"
        ;;
    *)
        display "Invalid filesystem ${filesystem} specified, aborting." red >&2
        exit 1
        ;;
    esac

    if value_bool "${do_mount:-}" || confirm 'Mount main partition now?'; then
        part_main_mount
    fi
}

part_main_mount() {
    display 'Mounting main partition...'
    filesystem=$(get_filesystems_main)
    case ${filesystem} in
    zfs)
        display 'Mounting ZFS volume /nix...'
        run_sudo mount --mkdir -t zfs "${label_main}/nix" "${mountpoint}/nix"
        display 'Mounting ZFS volume /persist...'
        run_sudo mount --mkdir -t zfs "${label_main}/persist" "${mountpoint}/persist"
        display 'Mounting ZFS volume /cache...'
        run_sudo mount --mkdir -t zfs "${label_main}/cache" "${mountpoint}/cache"
        ;;
    esac
}

part_boot_create() {
    display 'Creating boot partition...'
    run_sudo sgdisk "-n${num_boot}:1M:+1G -t${num_boot}:EF00" "${disk}"
}

part_boot_erase() {
    display 'Erasing boot partition...'

    label_real=${label_boot}
    [ ! -b "/dev/disk/by-label/${label_real}" ] &&
        label_real=$(prompt 'Enter label used for boot partition')

    part_boot=$(readlink -f "/dev/disk/by-label/${label_real}")

    display 'Wiping boot partition...'
    run_sudo wipefs --all "/dev/disk/by-label/${label_real}"
}

part_boot_format() {
    do_mount=${1:-}

    display 'Formatting boot partition...'
    run_sudo mkfs.fat -F 32 -n "${label_boot}" "${part_boot}"

    if value_bool "${do_mount:-}" || confirm 'Mount boot partition now?'; then
        part_boot_mount
    fi
}

part_boot_mount() {
    display 'Mounting boot partition...'
    run_sudo mount -o umask=0077 --mkdir "${part_boot}" "${mountpoint}/boot"
}

part_swap_create() {
    display 'Creating swap partition...'
    run_sudo sgdisk \
        "-n${num_swap}:0:+$(($(grep '^MemTotal:' /proc/meminfo | awk '{print $2}') * 2))K" \
        "-t${num_swap}:8200" "${disk}"
}

part_swap_erase() {
    display 'Erasing swap partition...'

    label_real=${label_swap}
    [ ! -b "/dev/disk/by-label/${label_real}" ] &&
        label_real=$(prompt 'Enter label used for swap partition')

    part_swap=$(readlink -f "/dev/disk/by-label/${label_real}")

    if sudo cryptsetup isLuks "${part_swap}"; then
        label_mapped=${label_real}
        [ ! -b "/dev/mapper/${label_mapped}" ] &&
            label_mapped=$(prompt 'Enter label used for mapped swap device')

        display 'Disabling swap...'
        run_sudo swapoff "/dev/mapper/${label_mapped}" || :
        run_sudo cryptsetup close "${label_mapped}"
    else
        display 'Disabling swap...'
        run_sudo swapoff -L "${label_real}" || :
    fi

    display 'Wiping swap partition...'
    run_sudo wipefs --all "/dev/disk/by-label/${label_real}"
}

part_swap_format() {
    do_mount=${1:-}

    display 'Formatting swap partition...'

    if get_filesystems_encrypt; then
        display 'Using encrypted swap...'

        cryptsetup_keys=/etc/cryptsetup-keys.d
        get_filesystems_impermanence_enable && cryptsetup_keys=/persist${cryptsetup_keys}
        [ -n "${mountpoint:-}" ] && cryptsetup_keys=${mountpoint}${cryptsetup_keys}

        cryptsetup_swap_key=${cryptsetup_keys}/${label_swap}.key
        if sudo [ ! -r "${cryptsetup_swap_key}" ] || confirm 'Create new swap encryption key?'; then
            display 'Creating swap encryption key...'
            old_umask=$(umask)

            # Files - 0600
            # Dirs  - 0700
            umask 0077

            run_sudo mkdir -p "${cryptsetup_keys}"
            run_sudo dd bs=4096 count=1 iflag=fullblock status=none if=/dev/random of="${cryptsetup_swap_key}"

            umask "${old_umask}"
        fi

        display 'Formatting swap for LUKS...'
        run_sudo cryptsetup luksFormat --batch-mode --label="${label_swap}" --use-random "${part_swap}" "${cryptsetup_swap_key}"
        run_sudo cryptsetup open --key-file="${cryptsetup_swap_key}" "/dev/disk/by-label/${label_swap}" "${label_swap}"

        display 'Creating mapped swap...'
        device_swap=/dev/mapper/${label_swap}
        run_sudo mkswap "${device_swap}"
    else
        display 'Formatting swap...'
        device_swap=/dev/disk/by-label/${label_swap}
        run_sudo mkswap --label "${label_swap}" "${part_swap}"
    fi

    if value_bool "${do_mount:-}" || confirm 'Mount swap partition now?'; then
        part_swap_mount
    fi
}

part_swap_mount() {
    display 'Enabling swap...'
    run_sudo swapon "${device_swap}"
}

parts_erase() {
    display 'Wiping partitions...'
    run_sudo wipefs --all "${disk}"
}

parts_create() {
    display 'Creating partitions...'
    part_boot_create
    get_filesystems_swap_enable && part_swap_create
    part_main_create

    parts_notify
}

parts_notify() {
    display 'Notifying kernel of partitions...'
    run_sudo sgdisk -p "${disk}" >/dev/null
    sleep 5
}

parts_format() {
    do_mount=${1:-}
    if [ -z "${do_mount}" ]; then
        do_mount=false
        confirm 'Mount each partition after formatting?' && do_mount=true
    fi

    display 'Formatting partitions...'
    part_boot_format "${do_mount}"
    part_main_format "${do_mount}"
    get_filesystems_swap_enable && part_swap_format "${do_mount}"
}

parts_mount() {
    display 'Mounting partitions...'
    part_main_mount
    part_boot_mount
    get_filesystems_swap_enable && part_swap_mount
}

execute_install() {
    display 'Executing install...'
    # Set the build dir as the mounted system.
    # Otherwise, may run into cases where the build is too big for the ISO's tmpfs.
    build_dir=${mountpoint}/nix/var/nix/builds
    mkdir -p "${build_dir}"
    run_sudo nixos-install --root "${mountpoint}" --flake "${flake}#${host}" --no-root-password --option build-dir "${build_dir}"

    display 'Executing persistwd for initial population...'
    run_sudo nixos-enter --root "${mountpoint}" -- persistwd populate-hashes --passwd
}

# Get numbered input from the user referring to a partition choice, repeating if invalid response given.
# Arguments:
#   None
# Prerequisite variables:
#   None
# Modified variables:
#   None
# Outputs:
#   stdout: string holding user response, may be 'b' for 'Back'
menu_partition() {
    cat >&2 <<EOF

${ascii_cyan}1) Main partition
2) Boot partition
3) Swap partition
a) All partitions
b) Back${ascii_reset}
EOF
    prompt 'Select the partition number'
}

# Installing the system.
# Arguments:
#   None
# Prerequisite variables:
#   None
# Modified variables:
#   None
# Outputs:
#   None
install_system() {
    display 'Installing system...'

    if ! is_dryrunning && ! is_iso; then
        display 'This is not an ISO environment. Dry run assumed.' yellow >&2

        if confirm 'Do you want to do a real install?'; then
            display 'THIS IS NOT AN ISO ENVIRONMENT!' red >&2
            confirm 'You are probably on an established system, are you sure you want to continue?' red >&2 || return 0
            confirm 'ARE YOU SURE?' red >&2 || return 0

            if [ "$(hostname)" != "$(prompt 'Enter the host to confirm')" ]; then
                display 'Incorrect host, cancelling.' yellow >&2
                return
            fi
        else
            dryrun=true
        fi

        display 'Proceeding...' green
    fi

    if [ -n "${mountpoint:-}" ] && [ -d "${mountpoint}/boot" ] && confirm 'It looks like partitions are created and mounted, proceed with ONLY executing the flake install?'; then
        get_flake
        get_host
        execute_install
    else
        get_flake
        get_host
        get_filesystems
        select_disk

        parts_erase
        parts_create
        parts_format 1

        execute_install
    fi

    display 'Operation complete.' green
}

# Creating the partitions.
# Arguments:
#   None
# Prerequisite variables:
#   None
# Modified variables:
#   None
# Outputs:
#   None
create_partitions() {
    while :; do
        case $(menu_partition) in
        1)
            get_flake
            get_host
            get_filesystems
            select_disk

            part_main_create
            parts_notify

            display 'Operation complete.' green
            return
            ;;
        2)
            get_flake
            get_host
            get_filesystems
            select_disk

            part_boot_create
            parts_notify

            display 'Operation complete.' green
            return
            ;;
        3)
            get_flake
            get_host
            get_filesystems
            if ! get_filesystems_swap_enable; then
                display 'Swap is not in use for this host, cancelling.' yellow
                return
            fi
            select_disk

            part_swap_create
            parts_notify

            display 'Operation complete.' green
            return
            ;;
        b) return ;;
        esac
    done
}

# Formatting the partitions.
# Arguments:
#   None
# Prerequisite variables:
#   None
# Modified variables:
#   None
# Outputs:
#   None
format_partitions() {
    while :; do
        case $(menu_partition) in
        1)
            get_flake
            get_host
            get_filesystems
            select_disk

            part_main_erase
            part_main_format

            display 'Operation complete.' green
            return
            ;;
        2)
            get_flake
            get_host
            get_filesystems
            select_disk

            part_boot_erase
            part_boot_format

            display 'Operation complete.' green
            return
            ;;
        3)
            get_flake
            get_host
            get_filesystems
            if ! get_filesystems_swap_enable; then
                display 'Swap is not in use for this host, cancelling.' yellow
                return
            fi
            select_disk

            part_swap_erase
            part_swap_format
            if ! value_bool "${do_mount:-}" && get_filesystems_encrypt; then
                run_sudo cryptsetup close "${label_swap}"
            fi

            display 'Operation complete.' green
            return
            ;;
        a)
            get_flake
            get_host
            get_filesystems
            select_disk

            parts_erase
            parts_format
            if ! value_bool "${do_mount:-}" && get_filesystems_swap_enable && get_filesystems_encrypt; then
                run_sudo cryptsetup close "${label_swap}"
            fi

            display 'Operation complete.' green
            return
            ;;
        b) return ;;
        esac
    done
}

# Mounting the partitions.
# Arguments:
#   None
# Prerequisite variables:
#   None
# Modified variables:
#   None
# Outputs:
#   None
mount_partitions() {
    while :; do
        case $(menu_partition) in
        1)
            get_flake
            get_host
            get_filesystems
            select_disk

            part_main_mount

            display 'Operation complete.' green
            return
            ;;
        2)
            get_flake
            get_host
            get_filesystems
            select_disk

            part_boot_mount

            display 'Operation complete.' green
            return
            ;;
        3)
            get_flake
            get_host
            get_filesystems
            if ! get_filesystems_swap_enable; then
                display 'Swap is not in use for this host, cancelling.' yellow
                return
            fi
            select_disk

            part_swap_mount

            display 'Operation complete.' green
            return
            ;;
        a)
            get_flake
            get_host
            get_filesystems
            select_disk

            parts_mount

            display 'Operation complete.' green
            return
            ;;
        b) return ;;
        esac
    done
}

configure() {
    while :; do
        print_dryrun=no
        is_dryrunning && print_dryrun=yes
        cat >&2 <<EOF

dry-running:    ${ascii_blue}${print_dryrun}${ascii_reset}
flake:          ${ascii_blue}${flake:-}${ascii_reset}
host:           ${ascii_blue}${host:-}${ascii_reset}
disk:           ${ascii_blue}${disk:-}${ascii_reset}

${ascii_cyan}1) Toggle dry-running
2) Set flake
3) Set host
4) Set disk
b) Back${ascii_reset}
EOF
        case $(prompt 'Select a choice') in
        1)
            if is_dryrunning; then
                dryrun=false
            else
                dryrun=true
            fi
            ;;
        2) flake=$(prompt 'Specify flake used') ;;
        3) host=$(prompt 'Specify host used') ;;
        4)
            get_flake
            get_host
            select_disk
            ;;
        b) return ;;
        esac
    done
}

create_iso() {
    display 'Creating ISO...'

    get_flake
    if command_present nixos-generate; then
        run nixos-generate --flake "${flake}#installer" --format iso --out-link result --option warn-dirty false
    else
        run nix build "${flake}#nixosConfigurations.installer.config.system.build.isoImage"
    fi

    display 'Operation complete.' green
}

interaction() {
    while :; do
        cat >&2 <<EOF

${ascii_cyan}1) Install system
2) Rescue system
3) Rescue data
4) Create partitions
5) Format partitions
6) Mount partitions
7) Create ISO
c) Configure
p) Poweroff
r) Reboot
q) Quit${ascii_reset}
EOF
        case $(prompt 'Select a choice') in
        1) install_system ;;
        2) display "This is very much todo, hopefully I don't need this now." ;;
        3) display "This is very much todo, hopefully I don't need this now." ;;
        4) create_partitions ;;
        5) format_partitions ;;
        6) mount_partitions ;;
        7) create_iso ;;
        c) configure ;;
        p) exec systemctl poweroff ;;
        r) exec systemctl reboot ;;
        q) return ;;
        esac
    done
}

printf '%s' "${ascii_magenta}" >&2
cat >&2 <<EOF
       oooo             o8     o888o           o888
  ooooo888   ooooooo  o888oo o888oo oooo   oooo 888   oooooooo8
888    888 888     888 888    888    888   888  888  888ooooooo
888    888 888     888 888    888     888 888   888          888
  88ooo888o  88ooo88    888o o888o      8888   o888o 88oooooo88
                                     o8o888
EOF
printf '%s' "${ascii_reset}" >&2

is_iso || printf '\n%s%s%s%s\n' 'You are on host ' "${ascii_blue}" "$(hostname)" "${ascii_reset}" >&2

interaction
