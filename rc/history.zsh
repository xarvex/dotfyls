HISTSIZE=10000
SAVEHIST=${HISTSIZE}
HISTFILE=${XDG_STATE_HOME:-${HOME}/.local/share}/zsh/history

[[ -d "$(dirname ${HISTFILE})" ]] || mkdir -p "$(dirname ${HISTFILE})"

setopt histfcntllock
setopt sharehistory histignoredups histignorealldups histignorespace
