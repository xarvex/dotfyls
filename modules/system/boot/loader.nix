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
      maxGenerations = 10;

      additionalFiles."efi/memtest86/memtest86.efi" = pkgs.memtest86plus.efi;
      extraEntries = ''
        /Tools
        //Ventoy
          protocol: efi
          comment: ${pkgs.ventoy.meta.description}
          path: fslabel(VTOYEFI):/EFI/BOOT/BOOTX64.EFI
        //Memtest86+
          protocol: efi
          comment: ${pkgs.memtest86plus.meta.description}
          path: boot():/limine/efi/memtest86/memtest86.efi
      '';
    };
  };
}
