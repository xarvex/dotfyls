#!/bin/sh

set -o errexit
set -o nounset

runtime_dir=${XDG_RUNTIME_DIR:-/run/user/$(id -a)}/dotfyls/nm-radio-toggle

radio_wifi_file="${runtime_dir}/wifi"
radio_wwan_file="${runtime_dir}/wwan"

radio_wifi=$(nmcli radio wifi)
radio_wwan=$(nmcli radio wwan)

if [ "${radio_wifi}" = disabled ] && [ "${radio_wwan}" = disabled ]; then
    old_radio_wifi=$(if cat "${radio_wifi_file}" 2>/dev/null; then
        rm "${radio_wifi_file}" >/dev/null 2>&1
    fi)
    old_radio_wwan=$(if cat "${radio_wwan_file}" 2>/dev/null; then
        rm "${radio_wwan_file}" >/dev/null 2>&1
    fi)
    old_radio_wifi=${old_radio_wifi:-enabled}
    old_radio_wwan=${old_radio_wwan:-enabled}

    if [ "${old_radio_wifi}" = enabled ] && [ "${old_radio_wwan}" = enabled ]; then
        nmcli radio all on
    else
        [ "${old_radio_wifi}" = enabled ] && nmcli radio wifi on
        [ "${old_radio_wwan}" = enabled ] && nmcli radio wwan on
    fi
else
    nmcli radio all off

    if [ "${radio_wifi}" != enabled ] || [ "${radio_wwan}" != enabled ]; then
        mkdir -p "${runtime_dir}"
        printf '%s\n' "${radio_wifi}" >"${radio_wifi_file}"
        printf '%s\n' "${radio_wwan}" >"${radio_wwan_file}"
    fi
fi
