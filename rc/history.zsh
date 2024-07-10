HISTSIZE=10000
SAVEHIST=10000
HISTFILE=${XDG_STATE_HOME:-${HOME}/.local/share}/zsh/history

[[ -d "$(dirname ${HISTFILE})" ]] || mkdir -p "$(dirname ${HISTFILE})"

setopt sharehistory histignoredups histignorealldups histignorespace
