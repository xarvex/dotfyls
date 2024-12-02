{
  config,
  lib,
  pkgs,
  self,
  user,
  ...
}:

let
  cfg = config.dotfyls.programs.wireshark;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "wireshark"
      ]
      [
        "programs"
        "wireshark"
      ]
    )
  ];

  options.dotfyls.programs.wireshark.enable = lib.mkEnableOption "Wireshark" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.programs.wireshark.package = lib.mkDefault pkgs.wireshark;

    programs.wireshark.enable = true;

    users.users.${user}.extraGroups = [ "wireshark" ];
  };
}
