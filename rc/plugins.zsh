ZINIT_HOME=${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git

[[ -d ${ZINIT_HOME} ]] || mkdir -p "$(dirname ${ZINIT_HOME})"
[[ -d ${ZINIT_HOME}/.git ]] || git clone https://github.com/zdharma-continuum/zinit.git ${ZINIT_HOME} && (( ! ${#NOCLEAR} )) && clear

declare -A ZINIT
ZINIT[ZCOMPDUMP_PATH]=${zcompdump}
ZINIT[NO_ALIASES]=1

source ${ZINIT_HOME}/zinit.zsh

for file in ${ZDOTDIR:-${HOME}}/rc/plugins/*.zsh; do
    source ${file}
done
