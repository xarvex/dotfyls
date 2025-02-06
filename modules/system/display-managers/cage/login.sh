#!/bin/sh

if [ -z "${DOTFYLS_CAGED}" ]; then
    export DOTFYLS_CAGED=1
    if command -v xdg-terminal-exec >/dev/null; then
        exec xdg-terminal-exec
    elif command -v foot >/dev/null; then
        exec foot
    fi
fi
