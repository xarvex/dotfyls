zmodload zsh/parameter
setopt extendedglob

# From: https://github.com/starship/starship/pull/4205
_starship-zle-line-init() {
    [[ $CONTEXT == start ]] || return 0

    # Start regular line editor
    (( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[1]
    zle .recursive-edit
    local -i ret=$?
    (( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[2]

    is_prompt_transient=true
    zle .reset-prompt
    is_prompt_transient=false

    # If we received EOT, we exit the shell
    if [[ $ret == 0 && $KEYS == $'\4' ]]; then
        exit
    fi

    # Ctrl-C
    if (( ret )); then
        zle .send-break
    else
        # Enter
        zle .accept-line
    fi
    return ret
}

function enable_transience {
    # Enabling this function is known to trigger the following bugs:
    # - The shell behaves as if `notify` option was always off.
    # - The exit status from the shell on Ctrl-D is aways 0.
    # See more at https://github.com/starship/starship/pull/4205
    zle -N zle-line-init _starship-zle-line-init
}

function disable_transience {
    zle -D zle-line-init
}

function starship_left_prompt {
    if [ "$is_prompt_transient" = true ] ; then
        if whence -w starship_transient_prompt_func >/dev/null; then
            starship_transient_prompt_func
        else
            echo "%{\e[1;32m%}❯%{\e[0m%} "
        fi
    else
        starship prompt --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT"
    fi
}

function starship_right_prompt {
    if [ "$is_prompt_transient" = true ] ; then
        echo ""
    else
        starship prompt --right --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT"
    fi
}

is_prompt_transient=false

PROMPT='$(starship_left_prompt)'
RPROMPT='$(starship_right_prompt)'

enable_transience
