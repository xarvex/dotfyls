{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.management.kanata;
in
{
  options.dotfyls.management.kanata.enable = lib.mkEnableOption "Kanata" // {
    default = config.dotfyls.meta.machine.isDesktop || config.dotfyls.meta.machine.isLaptop;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.management.input = {
      useUinput = true;
      useInput = true;
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
        RestartSec = 5;
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
