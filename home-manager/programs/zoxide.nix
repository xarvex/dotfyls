{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.zoxide;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "zoxide"
      ]
      [
        "programs"
        "zoxide"
      ]
    )
  ];

  options.dotfyls.programs.zoxide.enable = lib.mkEnableOption "zoxide" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.directories = [ ".local/share/zoxide" ];

    programs.zoxide = {
      enable = true;

      options = [ "--cmd cd" ];
    };
  };
}
