ffmpeg_convert_mp3() {
    if [[ -z ${1} ]]; then
        print 'Input argument needs to be given'
        return 1
    fi
    if [[ -n ${2} ]]; then
        print 'Only one argument expected'
        return 1
    fi

    ffmpeg -i ${1} -codec:a libmp3lame -q:a 0 -map_metadata 0 -id3v2_version 3 -write_id3v1 1 ${1%.*}.mp3
}

ffmpeg_convert_mp4() {
    if [[ -z ${1} ]]; then
        print 'Input argument needs to be given'
        return 1
    fi
    if [[ -n ${2} ]]; then
        print 'Only one argument expected'
        return 1
    fi

    ffmpeg -i ${1} -vsync vfr -vf 'crop=trunc(iw/2)*2:trunc(ih/2)*2' ${1%.*}.mp4
}
