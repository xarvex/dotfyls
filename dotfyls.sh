#!/bin/sh

readonly bin="${HOME}"/.local/bin/dotfyls # no XDG environment variable exists

if ! [ -f "${bin}" ]; then
    ln -s "$(readlink -f "${0}")" "${bin}"
fi

[ -z "${DOTFYLS_DISTRIBUTION}" ] && DOTFYLS_DISTRIBUTION="$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower(${2) }')"
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
