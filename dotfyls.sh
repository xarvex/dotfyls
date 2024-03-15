#!/bin/sh

self="$(readlink -f "${0}")"
readonly self
dir="$(dirname "${self}")"
readonly dir

cd "${dir}" || exit 1

if [ "${DOTFYLS_UPDATER_ACTIVE}" = 1 ]; then
    printf '%s\n' 'Updating dotfyls repository..'
    git pull --ff-only
    DOTFYLS_UPDATER_ACTIVE=0 DOTFYLS_UPDATED=1 exec "${DOTFYLS_SCRIPT}" # re-execute original script
    exit 1 # should not reach this point
elif [ ! "${DOTFYLS_UPDATED}" = 1 ]; then
    printf '%s\n' 'Checking for updates..'
    if git remote show origin | grep 'local out of date' > /dev/null; then
        printf '%s\n' 'There are updates to fetch!'
        script="$(mktemp)"
        readonly script
        cp "${self}" "${script}"
        chmod u+x "${script}"
        DOTFYLS_UPDATER_ACTIVE=1 DOTFYLS_SCRIPT="${self}" exec "${script}"
        exit 1 # should not reach this point
    else
        printf '%s\n' 'Already up to date!'
    fi
fi

readonly bin="${HOME}"/.local/bin/dotfyls # no XDG environment variable exists

if ! [ -f "${bin}" ]; then
    ln -s "${self}" "${bin}"
fi

[ -z "${DOTFYLS_DISTRIBUTION}" ] && DOTFYLS_DISTRIBUTION="$(awk '/^ID=/' /etc/*-release | awk -F '=' '{ print tolower($2) }')"
readonly DOTFYLS_DISTRIBUTION

if [ "${DOTFYLS_DISTRIBUTION}" = fedora ]; then
    sudo dnf install -y ansible
else
    printf '%s\n' "Unsupported distribution \"${DOTFYLS_DISTRIBUTION}\" detected. Ansible could not be installed."
fi

if command -v ansible-playbook > /dev/null; then
    ANSIBLE_HOME="${XDG_CONFIG_HOME}"/ansible ansible-playbook main.yml -K
else
    printf '%s\n' 'ansible-playbook not found on system PATH. Cannot execute playbook.'
fi
