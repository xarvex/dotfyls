{ config, lib, pkgs, ... }:

{
  options.dotfyls.programs.gnupg.enable = lib.mkEnableOption "GnuPG" // { default = true; };

  config = lib.mkIf config.dotfyls.programs.gnupg.enable {
    programs.gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-qt;
    };

    dotfyls.persist.directories = [ ".local/share/gnupg" ];
  };
}
