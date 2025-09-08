#!/bin/sh

set -o errexit
set -o nounset

port_file=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/Proton/VPN/forwarded_port

# https://stackoverflow.com/a/16444570
is_number() {
    case ${1#[-+]} in
    '' | *[!0-9]*) return 1 ;;
    *) return 0 ;;
    esac
}

printf '%s\n' 'Clearing proton0 forwarded ports...'
nft flush set inet nixos-fw proton0-forwarded-ports

if [ -r "${port_file}" ]; then
    port=$(cat "${port_file}")

    if is_number "${port}" && [ "${port}" -ge 1024 ] && [ "${port}" -le 65535 ]; then
        printf '%s%s%s\n' 'Allowing ' "'${port}'" ' as forwarded port...'
        nft add element inet nixos-fw proton0-forwarded-ports \{ "${port}" \}
    else
        printf '%s%s%s\n' 'Invalid port ' "'${port}'" ' given, ignoring.'
    fi
else
    printf '%s%s%s\n' 'Cannot read ' "'${port_file}'" ', ignoring.'
fi
