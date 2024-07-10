unalias ${(k)aliases} ${(k)galiases} ${(k)saliases}

if (( ${+commands[bat]} )); then
    alias cat=bat
fi

if (( ${+commands[eza]} )); then
    alias ls='eza --icons=auto'
    alias ll='eza -la --git'
    alias l.='eza -d .* --icons=auto'
    alias tree='eza -TL 2 --icons=auto'
fi

if (( ${+commands[fastfetch]} )); then
    alias neofetch=fastfetch
    alias fetch=fastfetch
fi

if (( ${+commands[git]} )); then
    alias ga='git add'
    alias gc='git commit'
    alias gd='git diff'
    alias gds='git diff --staged'
    alias gdup='git log -p @{push}..'
    alias gp='git push'
    alias gs='git status'
    alias gl='git log'
    alias glup='git log @{push}..'

    gpr() {
        git fetch ${2:-origin} pull/${1}/head && git checkout FETCH_HEAD
    }
fi

if (( ${+commands[nvim]} )); then
    alias vim=nvim

    nvim() {
        local fallback
        if [[ -t 0 ]]; then
            fallback=${PWD} # only use fallback when no stdin
        fi

        ${commands[nvim]} ${1:-${fallback}} ${@:2} <&0
        return $?
    }
fi

if (( ${+commands[thefuck]} )); then
    eval "$(thefuck --alias)"
fi

if (( ${+commands[zoxide]} )); then
    eval "$(zoxide init "$(basename ${SHELL})" --cmd cd)"
fi
