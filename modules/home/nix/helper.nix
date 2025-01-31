{ config, lib, ... }:

let
  cfg = config.dotfyls.nix.helper;
in
{
  options.dotfyls.nix.helper.enable = lib.mkEnableOption "nh" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = lib.optionalAttrs config.dotfyls.files.sync.enable {
      FLAKE = "${config.xdg.userDirs.documents}/Projects/dotfyls";
    };

    programs.nh.enable = true;
  };
}
