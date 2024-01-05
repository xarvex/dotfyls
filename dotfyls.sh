#!/bin/sh

dir="$(readlink -f "$(dirname "${0}")")"
readonly dir

if [ "${DOTFYLS_UPDATER_ACTIVE}" = 1 ]; then
    printf '%s\n' 'Updating dotfyls repository..'
    git pull "${DOTFYLS_DIR}" --ff-only
    exec "${DOTFYLS_SCRIPT}" # re-execute original script
    exit 1 # should not reach this point
else
    if git remote show origin | grep 'local out of date' > /dev/null; then
        printf '%s\n' 'dotfyls repository has updates to fetch'
        script="$(mktemp)"
        readonly script
        cp "${0}" "${script}"
        chmod u+x "${script}"
        DOTFYLS_UPDATER_ACTIVE=1 DOTFYLS_SCRIPT="${0}" DOTFYLS_DIR="${dir}" exec "${script}"
        exit 1 # should not reach this point
    fi
fi

readonly bin="${HOME}"/.local/bin/dotfyls # no XDG environment variable exists

if ! [ -f "${bin}" ]; then
    ln -s "$(readlink -f "${0}")" "${bin}"
fi

[ -z "${DOTFYLS_DISTRIBUTION}" ] && DOTFYLS_DISTRIBUTION="$(awk '/^ID=/' /etc/*-release | awk -F '=' '{ print tolower($2) }')"
readonly DOTFYLS_DISTRIBUTION

if [ "${DOTFYLS_DISTRIBUTION}" = fedora ]; then
    sudo dnf install -y ansible
else
    printf '%s\n' "Unsupported distribution \"${DOTFYLS_DISTRIBUTION}\" detected. Ansible could not be installed."
fi

if command -v ansible-playbook > /dev/null; then
    ansible-playbook main.yml -K
else
    printf '%s\n' 'ansible-playbook not found on system PATH. Cannot execute playbook.'
fi
