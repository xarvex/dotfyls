unalias ${(k)aliases} ${(k)galiases} ${(k)saliases}

if (( ${+commands[bat]} )); then
    alias cat=bat
fi

if (( ${+commands[eza]} )); then
    alias ls='eza --icons=auto'
    alias ll='eza -la --git'
    alias tree='eza -TL 2 --icons=auto'
fi

if (( ${+commands[fastfetch]} )); then
    alias neofetch=fastfetch
    alias fetch=fastfetch

    autoload -U distrobox-inactive distrobox-start
    alias fastfetch='( (( ! ${#DISTROBOX_ENTER_PATH} )) && distrobox-inactive fastfetch && distrobox-start fastfetch 2> /dev/null ); ${commands[fastfetch]}'
fi

if (( ${+commands[git]} )); then
    alias ga='git add'
    alias gc='git commit'
    alias gd='git diff'
    alias gds='git diff --staged'
    alias gp='git push'
    alias gs='git status'
    alias gup='git log -p @{push}.. $@'
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
    autoload -U distrobox-inactive distrobox-start
    alias zoxide='( (( ! ${#DISTROBOX_ENTER_PATH} )) && distrobox-inactive zoxide && distrobox-start zoxide 2> /dev/null ); ${commands[zoxide]}'

    eval "$(zoxide init "$(basename ${SHELL})" --cmd cd)"
fi
