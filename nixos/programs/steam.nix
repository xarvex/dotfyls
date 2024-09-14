{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.steam;
  hmCfg = config.hm.dotfyls.programs.steam;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "steam"
      ]
      [
        "programs"
        "steam"
      ]
    )
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "steam"
        "gamescope"
      ]
      [
        "programs"
        "gamescope"
      ]
    )
  ];

  options.dotfyls.programs.steam = {
    enable = lib.mkEnableOption "Steam" // {
      default = hmCfg.enable;
    };
    gamescope.enable = lib.mkEnableOption "Gamescope" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.steam = {
          enable = true;
          extraCompatPackages = with pkgs; [ proton-ge-bin ];

          remotePlay.openFirewall = true;
          dedicatedServer.openFirewall = true;
        };
      }

      (lib.mkIf cfg.gamescope.enable {
        programs = {
          gamescope = {
            enable = true;
            capSysNice = true;
            args = [
              "--rt"
              "--expose-wayland"
            ];
          };

          steam.gamescopeSession.enable = true;
        };
      })
    ]
  );
}
