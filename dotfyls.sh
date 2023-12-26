#!/bin/sh

XDG_BIN_HOME="${HOME}"/.local/bin # no environment variable exists

if ! [ -f "${XDG_BIN_HOME}"/dotfyls ]; then
    ln -s "$(readlink -f "${0}")" "${XDG_BIN_HOME}"/dotfyls
fi

[ -z "${DOTFYLS_DISTRIBUTION}" ] && DOTFYLS_DISTRIBUTION="$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower(${2) }')"

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
