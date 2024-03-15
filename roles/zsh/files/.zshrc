autoload -Uz compinit

[ -d "${XDG_CACHE_HOME}"/zsh ] || mkdir -p "${XDG_CACHE_HOME}"/zsh
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}"/zsh/zcompcache
compinit -d "${XDG_CACHE_HOME}"/zsh/zcompdump-"${ZSH_VERSION}"

HISTFILE="${XDG_STATE_HOME}"/zsh/history
HISTSIZE=1000
SAVEHIST=1000
[ -d "$(dirname "${HISTFILE}")" ] || mkdir -p "$(dirname "${HISTFILE}")"

bindkey -v

if command -v nvim > /dev/null; then
    nvim() {
        command nvim "${1:-${PWD}}" "${@:2}"
    }
    alias vim=nvim
fi

if command -v fastfetch > /dev/null; then
    alias neofetch=fastfetch
    fastfetch
fi
