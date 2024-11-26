#!/bin/sh

file="${XDG_CONFIG_HOME:-${HOME}/.config}/vesktop/state.json"

if [ ! -e "${file}" ]; then
    cat <<EOF >"${file}"
{
    "firstLaunch": false
}
EOF
fi
