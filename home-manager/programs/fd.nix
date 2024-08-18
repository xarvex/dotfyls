{ config, lib, self, ... }:

let
  cfg = config.dotfyls.programs.fd;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "programs" "fd" ]
      [ "programs" "fd" ])
  ];

  options.dotfyls.programs.fd.enable = lib.mkEnableOption "fd" // { default = true; };

  config = lib.mkIf cfg.enable {
    programs.fd = {
      enable = true;

      hidden = true;
    };
  };
}
