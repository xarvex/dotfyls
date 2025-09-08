{ config, pkgs, ... }:

{
  boot.loader = {
    efi.canTouchEfiVariables = true;

    timeout = 3;
    limine = {
      enable = true;

      enableEditor = false;
      style = {
        interface.branding = config.dotfyls.meta.name;
        wallpaperStyle = "centered";
      };

      additionalFiles."efi/memtest86/memtest86.efi" = pkgs.memtest86plus.efi;
      extraEntries = ''
        /Memtest86+
          protocol: efi
          comment: ${pkgs.memtest86plus.meta.description}
          path: boot():/limine/efi/memtest86/memtest86.efi
      '';
    };
  };
}
