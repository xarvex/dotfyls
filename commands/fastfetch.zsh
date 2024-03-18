alias neofetch=fastfetch

(( ! ${#NOCLEAR} && ${+commands[distrobox-enter]} && ${+commands[distrobox-list]} )) && \
    distrobox-list | grep 'fastfetch[ |]\+Exited' > /dev/null && \
    distrobox-enter -n fastfetch -- 'true' && \
    clear

fastfetch
