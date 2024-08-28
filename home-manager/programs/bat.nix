{ config, lib, pkgs, self, ... }:

let
  cfg = config.dotfyls.programs.bat;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "programs" "bat" ]
      [ "programs" "bat" ])
  ];

  options.dotfyls.programs.bat = {
    enable = lib.mkEnableOption "bat" // { default = true; };
    batman = {
      enable = lib.mkEnableOption "batman" // { default = true; };
      package = lib.mkPackageOption pkgs "batman" { default = [ "bat-extras" "batman" ]; };
    };
  };

  config = lib.mkIf cfg.enable {
    home.shellAliases = {
      cat = "bat";
      man = lib.mkIf cfg.batman.enable "batman";
    };

    programs.bat = {
      enable = true;
      extraPackages = [ ]
        ++ lib.optional cfg.batman.enable (self.lib.getCfgPkg cfg.batman);
    };
  };
}
