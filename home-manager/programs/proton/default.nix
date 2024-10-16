{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.proton;
in
{
  imports = [
    ./mail
    ./pass
    ./vpn

    (self.lib.mkCommonModules
      [
        "dotfyls"
        "programs"
        "proton"
      ]
      (service: _: {
        enable = lib.mkEnableOption "Proton ${service.name}" // {
          default = true;
        };
        package = lib.mkPackageOption pkgs "Proton ${service.name}" { default = service.packageName; };
      })
      {
        mail = {
          name = "Mail";
          packageName = "protonmail-desktop";
        };
        pass = {
          name = "Pass";
          packageName = "proton-pass";
        };
        vpn = {
          name = "VPN";
          packageName = "protonvpn-gui";
        };
      }
    )
  ];

  options.dotfyls.programs.proton.enable = lib.mkEnableOption "Proton services" // {
    default = true;
  };

  config = lib.mkIf cfg.enable { dotfyls.persist.cacheDirectories = [ ".cache/Proton" ]; };
}
