alias vim=nvim
nvim() {
    command nvim "${1:-${PWD}}" "${@:2}"
}
