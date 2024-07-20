{ config, lib, pkgs, user, ... }:

{
  options.dotfyls.displayManager.displayManager.sddm = {
    enable = lib.mkEnableOption "SDDM";
    theme = lib.mkOption {
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            example = "catppuccin-mocha";
            description = "Name of the theme.";
          };
          package = lib.mkOption {
            type = lib.types.package;
            example = (pkgs.catppuccin-sddm.override { flavor = "mocha"; });
            description = "Package providing the theme.";
          };
        };
      };
      default = {
        name = "catppuccin-mocha";
        package = (pkgs.catppuccin-sddm.override { flavor = "mocha"; });
      };
      example = {
        name = "catppuccin-mocha";
        package = (pkgs.catppuccin-sddm.override { flavor = "mocha"; });
      };
      description = "Theme to use for SDDM.";
    };
  };

  config = let cfg = config.dotfyls.displayManager.displayManager.sddm; in lib.mkIf (config.dotfyls.displayManager.enable && cfg.enable) {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
      theme = cfg.theme.name;
    };

    environment.systemPackages = [ cfg.theme.package ];

    systemd = {
      services."autovt@tty1".enable = false;

      tmpfiles.rules = [
        "d /var/lib/sddm 0755 root root - -"

        # Not really last, but allows specifying as default user on each boot.
        "f+ /var/lib/sddm/state.conf - - - - ${builtins.replaceStrings ["\n"] ["\\n"] (lib.generators.toINI { } { Last.User = user; })}"
      ];
    };
  };
}
