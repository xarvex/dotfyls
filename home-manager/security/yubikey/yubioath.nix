{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.security.yubikey;
  cfg = config.dotfyls.security.yubikey.yubioath;
in
{
  options.dotfyls.security.yubikey.yubioath = {
    enable = lib.mkEnableOption "Yubico Authenticator" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "Yubico Authenticator" { default = "yubioath-flutter"; };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) { home.packages = [ (self.lib.getCfgPkg cfg) ]; };
}
