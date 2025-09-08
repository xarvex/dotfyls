{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.security.wireshark;
in
{
  options.dotfyls.security.wireshark = {
    enable = lib.mkEnableOption "Wireshark" // {
      default = true;
    };

    desktopApplication = lib.mkEnableOption "Wireshark application" // {
      default = config.dotfyls.desktops.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
      package = lib.mkIf cfg.desktopApplication (lib.mkDefault pkgs.wireshark);
    };

    users.groups.wireshark.members = [ config.dotfyls.meta.user ];
  };
}
