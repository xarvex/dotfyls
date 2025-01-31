{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.display-managers;
  cfg = cfg'.display-managers.sddm;
in
{
  options.dotfyls.display-managers.display-managers.sddm.enable = lib.mkEnableOption "SDDM";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file."/var/lib/sddm" = {
      mode = "0750";
      user = "sddm";
      cache = true;
    };

    environment.systemPackages = with pkgs; [ (catppuccin-sddm.override { flavor = "mocha"; }) ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;

      theme = "catppuccin-mocha";
    };

    systemd.services."autovt@tty1".enable = false;
  };
}
