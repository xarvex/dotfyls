{ config, lib, pkgs, self, user, ... }:

let
  cfg = config.dotfyls.displayManager.displayManager.sddm;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "displayManager" "displayManager" "sddm" ]
      [ "services" "displayManager" "sddm" ])
  ];

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

  config = lib.mkIf (config.dotfyls.displayManager.enable && cfg.enable) {
    environment.systemPackages = [ (self.lib.getCfgPkg cfg.theme) ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      package = lib.mkDefault pkgs.kdePackages.sddm;
      theme = cfg.theme.name;
    };

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
