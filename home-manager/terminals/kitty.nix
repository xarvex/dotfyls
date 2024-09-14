{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.terminals.terminals.kitty;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "terminals"
        "terminals"
        "kitty"
      ]
      [
        "programs"
        "kitty"
      ]
    )
  ];

  config = lib.mkIf cfg.enable {
    dotfyls.persist.cacheDirectories = [ ".config/kitty" ];

    programs.kitty = {
      enable = true;

      font = {
        inherit (config.dotfyls.fonts.monospace) name;

        size = config.dotfyls.terminals.fontSize;
      };
      settings = {
        update_check_interval = 0;
        scrollback_lines = 10000;
        background_opacity = toString 0.85;
      };
      extraConfig = ''
        include themes.conf
      '';
    };
  };
}
