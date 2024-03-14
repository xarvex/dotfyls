#!/bin/sh

output=.applied
while getopts "o:" opt; do
 case ${opt} in
    o)
        output="${OPTARG}"
        ;;
    *)
        ;;
 esac
done
shift $((OPTIND - 1))
: > "${output}".tmp

latest=0
for arg in "${@}"; do
    while read -r var; do
        if [ "$(printf '%s' "${var}" | cut -c 1)" != '#' ] && [ "${var#*=}" != "${var}" ]; then
            printf '%s\n' "${var}" >> "${output}".tmp
        fi
    done < "${arg}"

    timestamp="$(stat -c %Z "${arg}")"
    [ "${timestamp}" -gt "${latest}" ] && latest="${timestamp}"
done

if [ "${latest}" -lt "$(stat -c %Z /proc)" ]; then
    mv "${output}".tmp "${output}"
elif [ -f "${output}" ] && diff --brief "${output}".tmp "${output}" > /dev/null; then
    rm "${output}".tmp
else
    exit 1
fi
