{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.input;
  cfg = cfg'.kanata;
in
{
  options.dotfyls.input.kanata.enable = lib.mkEnableOption "Kanata" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.input.uinput = {
      enable = true;
      inputGroup = true;
    };

    home.packages = with pkgs; [ kanata ];

    xdg.configFile."kanata/kanata.kbd".source = ./kanata.kbd;

    systemd.user.services.kanata = {
      Unit = {
        Description = "Kanata keyboard remapper";
        Documentation = "https://github.com/jtroo/kanata";
      };

      Service = {
        Type = "simple";
        ExecStart = lib.getExe pkgs.kanata;
        Restart = "on-failure";
        RestartSec = "5";
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
