zinit load zsh-users/zsh-history-substring-search
zinit ice wait atload=_history_substring_search_config

HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd K history-substring-search-up
bindkey -M vicmd J history-substring-search-down
