{
  config,
  inputs,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.desktops.dotpanel;
in
{
  imports = [
    inputs.dotpanel.homeManagerModules.dotpanel

    (self.lib.mkAliasPackageModule [ "dotfyls" "desktops" "dotpanel" ] [ "programs" "dotpanel" ])
  ];

  options.dotfyls.desktops.dotpanel.enable = lib.mkEnableOption "dotpanel";

  config = lib.mkIf cfg.enable { programs.dotpanel.enable = true; };
}
