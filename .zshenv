# shellcheck disable=SC2034,SC2086,SC2206

source ${ZDOTDIR:-${HOME}}/common/env-extra.zsh

skip_global_compinit=1

fpath=( ${ZDOTDIR:-${HOME}}/functions ${fpath[@]} )
