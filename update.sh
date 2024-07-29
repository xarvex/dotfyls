#!/bin/sh

# IMPORTANT: this script is not maintained anymore, and is only used
# on the off chance I have to use a system without Nix or Home Manager.

dir="$(dirname "$(readlink -f "$0")")"
readonly dir

readonly USEROVERRIDES="${dir}"/user-overrides.js

readonly ARKENFOX="${dir}"/arkenfox
readonly ARKENFOX_UPDATER="${ARKENFOX}"/updater.sh
readonly ARKENFOX_CLEANER="${ARKENFOX}"/prefsCleaner.sh

readonly GEN="${dir}"/generated
readonly GEN_ARKENFOX_CLEANER="${GEN}"/arkenfox-prefsCleaner.sh

read_profile() {
    profiles=~/.mozilla/firefox/profiles.ini

    if [ "$(grep -c '^\[Profile' "${profiles}")" -eq '1' ]; then
        found_ini="$(grep '^\[Profile' -A 4 "${profiles}")"
    else
        grep --color=never -E '^Default=[^1]|^\[Profile[0-9]*\]|^Name=|^Path=' "${profiles}"
        printf 'Select profile number: '
        read -r profile_number
        printf '\n'
        if expr "${profile_number}" : '^(0|[1-9][0-9]*)$' > /dev/null; then
            if ! found_ini="$(grep "^\[Profile${profile_number}" -A 4 "${profiles}")"; then
                printf 'Profile %s did not exist!\n' "${profile_number}"
                exit 1
            fi
        else
            printf 'Invalid selection!\n'
            exit 1
        fi
    fi

    profile_path=$(sed -n 's/^Path=\(.\+\)$/\1/p' << EOF
${found_ini}
EOF
)
    [ "$(sed -n 's/^IsRelative=\([01]\)$/\1/p' << EOF
${found_ini}
EOF
)" = '1' ] && profile_path="$(dirname "${profiles}")/${profile_path}"

    printf '%s\n' "${profile_path}"
}



if ! [ -d "${ARKENFOX}" ]; then
    mkdir -p "${ARKENFOX}"
    curl -sL "$(curl -s https://api.github.com/repos/arkenfox/user.js/releases/latest | jq -r .tarball_url)" | tar -xz -C "${ARKENFOX}" --strip-components 1
fi

silent="$([ -n "${DOTFYLS_NONINTERACTIVE}" ] && [ "${DOTFYLS_NONINTERACTIVE}" -eq '1' ] && printf -- '-s')"

mkdir -p "${GEN}"
profile="$(read_profile)"
"${ARKENFOX_UPDATER}" -p "${profile}" -o "${USEROVERRIDES}" "${silent}"
sed 's/{BASH_SOURCE\[0\]}/{DOTFYLS_ARKENFOX_CLEANER}\/prefsCleaner.sh/g' "${ARKENFOX_CLEANER}"\
    | sed 's/(pwd)/{DOTFYLS_ARKENFOX_CLEANER}/g'\
    > "${GEN_ARKENFOX_CLEANER}"
chmod u+x "${GEN_ARKENFOX_CLEANER}"
DOTFYLS_ARKENFOX_CLEANER="${profile}" "${GEN_ARKENFOX_CLEANER}" -d "${silent}"
