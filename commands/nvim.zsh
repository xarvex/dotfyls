alias vim=nvim
nvim() {
    ${commands[nvim]} ${1:-${PWD}} ${@:2}
}
