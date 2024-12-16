{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.games;
  cfg = cfg'.steam;
  hmCfg = config.hm.dotfyls.games.steam;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "games"
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
        "games"
        "steam"
        "gamescope"
      ]
      [
        "programs"
        "gamescope"
      ]
    )
  ];

  options.dotfyls.games.steam = {
    enable = lib.mkEnableOption "Steam" // {
      default = hmCfg.enable;
    };
    gamescope.enable = lib.mkEnableOption "Gamescope" // {
      default = true;
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) (
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
