_: prev:

prev.discord.overrideAttrs (o: {
  nativeBuildInputs = o.nativeBuildInputs ++ [ prev.makeShellWrapper ];
  postInstall =
    (o.postInstall or "")
    + ''
      wrapProgramShell $out/opt/Discord/Discord \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+\
          --enable-accelerated-mjpeg-decode \
          --enable-accelerated-video \
          --enable-features=UseOzonePlatform \
          --enable-features=VaapiVideoDecoder \
          --enable-gpu-rasterization \
          --enable-native-gpu-memory-buffers \
          --enable-wayland-ime \
          --enable-zero-copy \
          --ignore-gpu-blocklist \
        }}"
    '';
})
