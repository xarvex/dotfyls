# shellcheck shell=bash

declare -A direnv_layout_dirs
direnv_layout_dir() {
    printf '%s\n' "${direnv_layout_dirs[${PWD}]:=${XDG_CACHE_HOME:-${HOME}/.cache}/direnv/layouts/$(sha1sum - <<<"${PWD}" | head -c40)${PWD//[^a-zA-Z0-9]/-}}"
}
