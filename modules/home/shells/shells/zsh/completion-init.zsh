# shellcheck shell=sh disable=SC2086

autoload -U compinit && compinit -d ${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/zcompdump-${ZSH_VERSION}
