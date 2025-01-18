for alias in (alias)
    set alias (string split --no-empty ' ' -- $alias)
    set -e alias[1]
    functions -e $alias[1]
    if test $alias[1] != ..
        eval abbr -a -- $alias
    end
end

fish_vi_key_bindings

function dumb_history_reset_variables --on-event fish_prompt
    set -g dumb_history_position 0
    set -g dumb_commandline ""
end

function dumb_history --argument-names reverse
    if test $reverse = true
        if test $dumb_history_position -eq 0
            set -g dumb_commandline (commandline)
        end
        set -g dumb_history_position (math $dumb_history_position + 1)
    else if test $dumb_history_position -gt 0
        set -g dumb_history_position (math $dumb_history_position - 1)
    end

    if test $dumb_history_position -gt 0
        commandline --replace (history search "*" --max $dumb_history_position | sed -n {$dumb_history_position}"p")
    else
        commandline --replace $dumb_commandline
    end

    commandline -f repaint
end

function dumb_history_backward
    dumb_history true
end

function dumb_history_forward
    dumb_history false
end

bind -M insert \e\[1\;5A dumb_history_backward
bind -M insert \e\[1\;5B dumb_history_forward

function starship_transient_prompt_func
    starship module character
end
