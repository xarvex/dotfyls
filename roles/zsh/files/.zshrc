autoload -Uz compinit

[ -d "${XDG_CACHE_HOME}"/zsh ] || mkdir -p "${XDG_CACHE_HOME}"/zsh
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}"/zsh/zcompcache
compinit -d "${XDG_CACHE_HOME}"/zsh/zcompdump-"${ZSH_VERSION}"

HISTFILE="${XDG_STATE_HOME}"/zsh/history
HISTSIZE=1000
SAVEHIST=1000
[ -d "$(dirname "${HISTFILE}")" ] || mkdir -p "$(dirname "${HISTFILE}")"

bindkey -v

if command -v nvim > /dev/null; then
    nvim() {
        command nvim "${1:-${PWD}}" "${@:2}"
    }
    alias vim=nvim
fi

if command -v ffmpeg > /dev/null; then
    ffmpeg_convert_mp4() {
        if [ -z "${1}" ]; then
            echo 'Input argument needs to be given'
            return 1
        fi
        if [ -n "${2}" ]; then
            echo 'Only one argument expected'
            return 1
        fi

        ffmpeg -i "${1}" -vsync vfr -vf 'crop=trunc(iw/2)*2:trunc(ih/2)*2' "${1%.*}.mp4"
    }


    ffmpeg_convert_mp3() {
        if [ -z "${1}" ]; then
            echo 'Input argument needs to be given'
            return 1
        fi
        if [ -n "${2}" ]; then
            echo 'Only one argument expected'
            return 1
        fi

        ffmpeg -i "${1}" -codec:a libmp3lame -q:a 0 -map_metadata 0 -id3v2_version 3 -write_id3v1 1 "${1%.*}.mp3"
    }
fi

if command -v fastfetch > /dev/null; then
    alias neofetch=fastfetch
    fastfetch
fi
