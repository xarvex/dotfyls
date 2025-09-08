{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.games;
  cfg = cfg'.steam;
  hmCfg = config.hm.dotfyls.games.steam;
in
{
  options.dotfyls.games.steam = {
    enable = lib.mkEnableOption "Steam" // {
      default = hmCfg.enable;
    };
    gamescope.enable = lib.mkEnableOption "Gamescope" // {
      default = true;
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    programs = {
      gamescope = lib.mkIf cfg.gamescope.enable {
        enable = true;
        capSysNice = true;
        args = [
          "--expose-wayland"
          "--rt"
        ];
      };
      steam = {
        enable = true;
        extraCompatPackages = with pkgs; [ proton-ge-bin ];

        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };
    };
  };
}
