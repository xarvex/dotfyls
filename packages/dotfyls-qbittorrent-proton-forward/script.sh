#!/bin/sh

set -o errexit
set -o nounset

conf_file=${XDG_CONFIG_HOME:-${HOME}/.config}/qBittorrent/qBittorrent.conf
port_file=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/Proton/VPN/forwarded_port

# https://stackoverflow.com/a/16444570
is_number() {
    case ${1#[-+]} in
    '' | *[!0-9]*) return 1 ;;
    *) return 0 ;;
    esac
}

crudini() {
    command crudini --ini-options nospace "${@}"
}

conf_session_port_remove() {
    crudini --del "${conf_file}" BitTorrent 'Session\Port'
}

_conf_session_port_set() {
    crudini --set "${conf_file}" BitTorrent 'Session\Port' "${session_port}" "${@}"
}

conf_session_port_set() {
    session_port=${1}
    webui_port=${2:-}

    if [ -n "${webui_port}" ]; then
        _conf_session_port_set --set "${conf_file}" Preferences 'WebUI\Port' "${webui_port}"
    else
        _conf_session_port_set
    fi
}

if [ -r "${port_file}" ]; then
    port=$(cat "${port_file}")

    port_min=1024
    port_max=65535
    if is_number "${port}" && [ "${port}" -ge "${port_min}" ] && [ "${port}" -le "${port_max}" ]; then
        printf '%s%s%s\n' 'Setting ' "'${port}'" ' as session port...'

        new_webui_port() {
            while [ "${port}" = "${new_conf_webui_port:-${port}}" ]; do
                new_conf_webui_port=$(awk -v min=${port_min} -v max=${port_max} 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
            done
        }

        conf_webui_port=$(crudini --get "${conf_file}" Preferences 'WebUI\Port' || :)
        if [ -z "${conf_webui_port}" ]; then
            printf '%s\n' 'qBittorrent has no WebUI port, creating one...'
            new_webui_port
        elif [ "${port}" = "${conf_webui_port}" ]; then
            printf '%s%s%s\n' 'Port ' "'${port}'" ' is same as WebUI port, creating new WebUI port...'
            new_webui_port
        fi

        if pidof -q qbittorrent; then
            if [ -n "${conf_webui_port}" ]; then
                printf '%s\n' 'qBittorrent is running with WebUI, sending request..'
                wget --tries 5 --retry-connrefused --output-document - \
                    --post-data "json={\"listen_port\":${port}${new_conf_webui_port:+,\"web_ui_port\":${new_conf_webui_port}}}" \
                    "http://localhost:${conf_webui_port}/api/v2/app/setPreferences"
            else
                printf '%s\n' 'qBittorrent is running with no WebUI, mutating conf...'
                conf_session_port_set "${port}" "${new_conf_webui_port:-}"
            fi
        else
            printf '%s\n' 'qBittorrent is not running, mutating conf...'
            conf_session_port_set "${port}" "${new_conf_webui_port:-}"
        fi
    else
        printf '%s%s%s\n' 'Invalid port ' "'${port}'" ' given, removing session port...'
        conf_session_port_remove
    fi
else
    printf '%s%s%s\n' 'Cannot read ' "'${port_file}'" ', removing session port...'
    conf_session_port_remove
fi
