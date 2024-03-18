# shellcheck disable=SC1090,SC1091,SC1094,SC2034,SC2086,SC2231,SC2296

stty stop undef # disable Ctrl-S freezing

zcompdump=${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}

ZINIT_HOME=${XDG_DATA_HOME}/zinit/zinit.git
[[ -d ${ZINIT_HOME} ]] || mkdir -p "$(dirname ${ZINIT_HOME})"
[[ -d ${ZINIT_HOME}/.git ]] || git clone https://github.com/zdharma-continuum/zinit.git ${ZINIT_HOME} && (( ! ${#NOCLEAR} )) && clear
declare -A ZINIT
ZINIT[ZCOMPDUMP_PATH]=${zcompdump}
ZINIT[NO_ALIASES]=1
source ${ZINIT_HOME}/zinit.zsh

zinit ice depth'1'
zinit light romkatv/powerlevel10k
[[ -r ${ZDOTDIR}/p10k.zsh ]] && source ${ZDOTDIR}/p10k.zsh

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

zinit load zsh-users/zsh-history-substring-search
zinit ice wait atload'_history_substring_search_config'
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd K history-substring-search-up
bindkey -M vicmd J history-substring-search-down

zinit ice depth'1'
zinit load MichaelAquilina/zsh-you-should-use

zinit wait lucid for \
    atinit'ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay' zdharma-continuum/fast-syntax-highlighting \
    blockf zsh-users/zsh-completions \
    atload'!_zsh_autosuggest_start' zsh-users/zsh-autosuggestions

(( ${#NOCLEAR} )) || clear

setopt warncreateglobal # only warn for my own code

for file in ${ZDOTDIR}/commands/**/*.zsh; do
    (( ${+commands[${file:t:r}]} )) && source ${file}
done

unsetopt warncreateglobal

[[ -r ${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh ]] &&
    source ${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh

HISTFILE=${XDG_STATE_HOME}/zsh/history
HISTSIZE=10000
SAVEHIST=10000
[[ -d "$(dirname ${HISTFILE})" ]] || mkdir -p "$(dirname ${HISTFILE})"
setopt histignorealldups histignorespace histreduceblanks incappendhistory

zle_highlight=( 'paste:none' )

[[ -d ${XDG_CACHE_HOME}/zsh ]] || mkdir -p ${XDG_CACHE_HOME}/zsh
zstyle ':completion:*' cache-path ${XDG_CACHE_HOME}/zsh/zcompcache
autoload -U compinit
compinit -d ${zcompdump}

unset zcompdump

zinit cdreplay -q

autoload -U reload
