#!/bin/sh

set -o errexit
set -o nounset

# Get yes or no input from the user, repeating if invalid response given.
# Arguments:
#   prompt: string displayed to user
# Prerequisite variables:
#   None
# Modified variables:
#   None
# Outputs:
#   return: Boolean for yes (true) or no (false)
confirm() {
    prompt=${1}

    while :; do
        printf '%s%s' "${prompt}" ' [y/N]: ' >&2
        read -r response

        case ${response} in
        '' | [Nn]*) return 1 ;;
        [Yy]*) return ;;
        esac
    done
}

config_home=${XDG_CONFIG_HOME:-${HOME}/.config}

mkdir -p "${config_home}"

# Files - 0600
# Dirs  - 0700
umask 0077

# Do not want to affect permissions of parent directories with mkdir -p.
yubico_config_home=${config_home}/Yubico
[ -d "${yubico_config_home}" ] || mkdir "${yubico_config_home}"

keys_file=${yubico_config_home}/u2f_keys

if [ ! -s "${keys_file}" ] || confirm "Existing file found at ${keys_file}, start over with new configuration?"; then
    printf '%s\n' "Setting new key..."
    pamu2fcfg -N >"${keys_file}"
fi

while confirm "Add another key?"; do
    printf '%s\n' "Adding new key..."
    pamu2fcfg -Nn >>"${keys_file}"
done
