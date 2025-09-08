#!/bin/sh

set -o errexit
set -o nounset

if [ -n "${1:-}" ]; then
    flake=${1}
    shift
elif [ -n "${NREPL_FLAKE:-}" ]; then
    flake=${NREPL_FLAKE}
elif [ -f flake.nix ]; then
    flake=$(pwd)
else
    flake=${NREPL_FLAKE_FALLBACK:-$(pwd)}
fi

exec nix repl \
    --file "${NREPL_REPL:-repl.nix}" \
    --argstr flakePath "${flake}" \
    --argstr host "${NREPL_HOST:-$(hostname)}" \
    "${@}"
