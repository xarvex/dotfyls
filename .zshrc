# shellcheck disable=SC1090,SC1091,SC1094,SC2034,SC2086,SC2231,SC2296

zcompdump=${XDG_CACHE_HOME:-${HOME}/.local/cache}/zsh/zcompdump-${ZSH_VERSION}

source ${ZDOTDIR:-${HOME}}/rc/plugins.zsh
(( ${#NOCLEAR} )) || clear # TODO: implement for NixOS

source ${ZDOTDIR:-${HOME}}/common/init-extra-first.zsh

source ${ZDOTDIR:-${HOME}}/common/init-extra-before-comp-init.zsh
autoload -U compinit && compinit -d ${zcompdump} && zinit cdreplay -q

unset zcompdump

source ${ZDOTDIR:-${HOME}}/rc/history.zsh
setopt autocd

source ${ZDOTDIR:-${HOME}}/common/init-extra.zsh

source ${ZDOTDIR:-${HOME}}/rc/alias.zsh

(( ${+commands[fastfetch]} )) && fetch

# TODO: implement for NixOS
autoload -U convert
autoload -U reload
