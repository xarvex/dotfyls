#!/bin/sh

set -o errexit
set -o nounset

temperature_current=$(hyprctl hyprsunset temperature)
while [ "${temperature_current}" != "${1}" ]; do
    if [ "${temperature_current}" -gt "${1}" ]; then
        temperature_diff=$((temperature_current - ${1}))
        step_operand=-
    else
        temperature_diff=$((${1} - temperature_current))
        step_operand=+
    fi
    if [ "${2}" -lt "${temperature_diff}" ]; then
        step_value=${2}
    else
        step_value=${temperature_diff}
    fi

    hyprctl -q hyprsunset temperature "${step_operand}${step_value}"
    sleep 1

    temperature_current=$(hyprctl hyprsunset temperature)
done
