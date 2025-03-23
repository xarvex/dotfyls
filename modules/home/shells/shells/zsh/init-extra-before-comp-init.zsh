# shellcheck shell=sh disable=SC2034,SC2086,SC2296,SC3010,SC3030

zle_highlight=(paste:none)

[[ -d ${XDG_CACHE_HOME:-${HOME}/.cache}/zsh ]] || mkdir -p ${XDG_CACHE_HOME:-${HOME}/.cache}/zsh

zstyle ':completion:*' cache-path ${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/zcompcache
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
