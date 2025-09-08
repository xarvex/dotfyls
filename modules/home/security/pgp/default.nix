{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.security.pgp;
in
{
  options.dotfyls.security.pgp = {
    enable = lib.mkEnableOption "GnuPG" // {
      default = config.dotfyls.desktops.enable;
    };
    agent.enable = lib.mkEnableOption "GnuPG agent" // {
      default = config.dotfyls.desktops.enable;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        dotfyls.file.".local/share/gnupg" = {
          mode = "0700";
          persist = true;
        };

        programs.gpg = {
          enable = true;
          homedir = "${config.xdg.dataHome}/gnupg";

          scdaemonSettings.disable-ccid = true;
          publicKeys = [
            {
              source = ./0046A18B1037C201.asc;
              trust = 5;
            }
          ];
        };
      }

      (lib.mkIf cfg.agent.enable {
        services.gpg-agent = {
          enable = true;
          pinentry.package = pkgs.pinentry-qt;

          maxCacheTtl = 0;
          maxCacheTtlSsh = 0;
        };

        wayland.windowManager.hyprland.settings.windowrule = [
          "tag +important-prompt, class:${lib.escapeRegex "org.gnupg.pinentry-"}.+"

          "noscreenshare, class:${lib.escapeRegex "org.gnupg.pinentry-"}.+"
          "dimaround, class:${lib.escapeRegex "org.gnupg.pinentry-"}.+, floating:1"
        ];
      })
    ]
  );
}
