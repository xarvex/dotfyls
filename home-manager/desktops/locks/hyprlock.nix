{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg'' = config.dotfyls.desktops;
  cfg' = cfg''.locks;
  cfg = cfg'.locks.hyprlock;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "desktops"
        "locks"
        "locks"
        "hyprlock"
      ]
      [
        "programs"
        "hyprlock"
      ]
    )
  ];

  options.dotfyls.desktops.locks.locks.hyprlock = {
    enable = lib.mkEnableOption "hyprlock";
    command =
      self.lib.mkCommandOption "invoke hyprlock"
      // lib.optionalAttrs cfg.enable {
        default = pkgs.dotfyls.mkCommand {
          runtimeInputs = [
            (self.lib.getCfgPkg cfg)
            pkgs.procps
          ];
          text = "pidof hyprlock || exec hyprlock";
        };
      };
  };

  config = lib.mkIf (cfg''.enable && cfg'.enable && cfg.enable) {
    programs.hyprlock = {
      enable = true;

      settings = {
        general.disable_loading_bar = true;
        # TODO: theme
      };
    };
  };
}
