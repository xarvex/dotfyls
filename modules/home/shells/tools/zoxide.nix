{ config, lib, ... }:

let
  cfg' = config.dotfyls.shells.tools;
  cfg = cfg'.zoxide;
in
{
  options.dotfyls.shells.tools.zoxide.enable = lib.mkEnableOption "zoxide" // {
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
