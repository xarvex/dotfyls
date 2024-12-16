{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.display-managers;
  cfg = cfg'.display-managers.sddm;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "display-managers"
        "display-managers"
        "sddm"
      ]
      [
        "services"
        "displayManager"
        "sddm"
      ]
    )
  ];

  options.dotfyls.display-managers.display-managers.sddm = {
    enable = lib.mkEnableOption "SDDM";
    theme = lib.mkOption rec {
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            example = "catppuccin-mocha";
            description = "Name of the theme.";
          };
          package = lib.mkOption {
            type = lib.types.package;
            example = lib.literalExpression ''
              pkgs.catppuccin-sddm.override { flavor = "mocha"; };
            '';
            description = "Package providing the theme.";
          };
        };
      };
      default = {
        name = "catppuccin-mocha";
        package = pkgs.catppuccin-sddm.override { flavor = "mocha"; };
      };
      defaultText = lib.literalExpression ''
        {
          name = "catppuccin-mocha";
          package = pkgs.catppuccin-sddm.override { flavor = "mocha"; };
        }
      '';
      example = defaultText;
      description = "Theme to use for SDDM.";
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls = {
      display-managers.display-managers.sddm.package = lib.mkDefault pkgs.kdePackages.sddm;

      file."/var/lib/sddm" = {
        mode = "0750";
        user = "sddm";
        cache = true;
      };
    };

    environment.systemPackages = [ (self.lib.getCfgPkg cfg.theme) ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = cfg.theme.name;
    };

    systemd.services."autovt@tty1".enable = false;
  };
}
