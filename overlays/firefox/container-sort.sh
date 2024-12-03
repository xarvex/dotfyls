#!/bin/sh

set -o errexit
set -o nounset

if [ -f "${HOME}/.mozilla/firefox/profiles.ini" ]; then
    cd "${HOME}/.mozilla/firefox"

    while read -r path; do
        jq --compact-output '.identities|=sort_by(.name)' "${path}/containers.json" |
            sponge "${path}/containers.json"
    done <<EOF
$(sed -n 's/^Path=\(.*\)$/\1/p' profiles.ini)
EOF
fi
