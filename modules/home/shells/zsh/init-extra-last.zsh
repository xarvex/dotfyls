# shellcheck shell=sh disable=SC2086,SC2296

abbr import-aliases --force >/dev/null
unalias ${(k)aliases} ${(k)galiases} ${(k)saliases}
