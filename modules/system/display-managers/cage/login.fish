#!/usr/bin/env fish

if test -z $DOTFYLS_CAGED
    set -x DOTFYLS_CAGED 1
    if command -v xdg-terminal-exec >/dev/null
        exec xdg-terminal-exec
    else if command -v foot >/dev/null
        exec foot
    end
end
