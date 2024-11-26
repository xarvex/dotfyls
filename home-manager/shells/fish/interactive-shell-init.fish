for alias in (alias)
    set alias (string split --no-empty ' ' -- $alias)
    set -e alias[1]
    functions -e $alias[1]
    if test $alias[1] != ..
        eval abbr -a -- $alias
    end
end

fish_vi_key_bindings
