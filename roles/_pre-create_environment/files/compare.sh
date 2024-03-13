#!/bin/sh

systemd_env="$(systemctl --user show-environment)"
readonly systemd_env

for arg in "${@}"; do
    while read -r var; do
        if [ ! "$(printf '%s' "${var}" | cut -c 1)" = '#' ]; then
            grep -x "$(eval "printf '%s' \"${var}\"")" > /dev/null << EOF || exit 1
${systemd_env}
EOF
        fi
    done < "${arg}"
done
