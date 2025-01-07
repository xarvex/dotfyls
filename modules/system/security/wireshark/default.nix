{
  config,
  lib,
  pkgs,
  self,
  user,
  ...
}:

let
  cfg = config.dotfyls.security.wireshark;
in
{
  imports = [
    (self.lib.mkAliasPackageModule [ "dotfyls" "security" "wireshark" ] [ "programs" "wireshark" ])
  ];

  options.dotfyls.security.wireshark.enable = lib.mkEnableOption "Wireshark" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.security.wireshark.package = lib.mkDefault pkgs.wireshark;

    programs.wireshark.enable = true;

    users.users.${user}.extraGroups = [ "wireshark" ];
  };
}
