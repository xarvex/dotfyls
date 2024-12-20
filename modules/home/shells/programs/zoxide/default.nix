{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.shells.programs;
  cfg = cfg'.zoxide;
in
{
  imports = [
    (self.lib.mkAliasPackageModule [ "dotfyls" "shells" "programs" "zoxide" ] [ "programs" "zoxide" ])
  ];

  options.dotfyls.shells.programs.zoxide.enable = lib.mkEnableOption "zoxide" // {
    default = cfg'.enableUseful;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file.".local/share/zoxide" = {
      mode = "0700";
      persist = true;
    };

    programs.zoxide = {
      enable = true;

      options = [ "--cmd cd" ];
    };
  };
}
