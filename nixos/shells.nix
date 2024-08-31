{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.shells;
  hmCfg = config.hm.dotfyls.shells;
in
{
  imports = [
    (self.lib.mkSelectorModule
      [
        "dotfyls"
        "shells"
      ]
      {
        inherit (hmCfg) default;

        name = "default";
        description = "Default shell to use.";
      }
      [ "zsh" ]
    )
  ];

  options.dotfyls.shells.shells = {
    zsh = {
      enable = lib.mkEnableOption "Zsh" // {
        default = hmCfg.zsh.enable;
      };
      package = lib.mkPackageOption pkgs "zsh" { };
    };
  };

  config = lib.mkMerge [
    { usr.shell = self.lib.getCfgPkg cfg.selected; }

    (lib.mkIf cfg.shells.zsh.enable { programs.zsh.enable = true; })
  ];
}
