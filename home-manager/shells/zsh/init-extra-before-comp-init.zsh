zle_highlight=(paste:none)

[[ -d ${XDG_CACHE_HOME:-${HOME}/.cache}/zsh ]] || mkdir -p ${XDG_CACHE_HOME:-${HOME}/.cache}/zsh

zstyle ':completion:*' cache-path ${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/zcompcache
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
