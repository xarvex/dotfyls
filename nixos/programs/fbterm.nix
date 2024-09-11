{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.fbterm;
in
{
  options.dotfyls.programs.fbterm = {
    enable = lib.mkEnableOption "fbterm";
    package = lib.mkPackageOption pkgs "fbterm" { };
  };

  config = lib.mkIf cfg.enable {
    services.getty.loginProgram = pkgs.dotfyls.mkCommandExe ''
      ${self.lib.getCfgExe cfg} -- ${pkgs.dotfyls.mkCommandExe "TERM=fbterm ${lib.getExe' pkgs.shadow "login"} -p"}
    '';
  };
}
