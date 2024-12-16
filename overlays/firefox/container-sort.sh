#!/bin/sh

set -o errexit
set -o nounset

if [ -f "${HOME}/.mozilla/firefox/profiles.ini" ]; then
    cd "${HOME}/.mozilla/firefox" || exit 0

    while read -r path; do
        jq --compact-output \
            '.identities |= (map(select(.name // "tmp" | startswith("tmp") | not)) | sort_by(.name))' \
            "${path}/containers.json" |
            sponge "${path}/containers.json" || exit 0
    done <<EOF
$(sed -n 's/^Path=\(.*\)$/\1/p' profiles.ini)
EOF
fi
