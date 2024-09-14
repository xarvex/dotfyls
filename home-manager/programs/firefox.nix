{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.firefox;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "firefox"
      ]
      [
        "programs"
        "firefox"
      ]
    )
  ];

  options.dotfyls.programs.firefox.enable = lib.mkEnableOption "Firefox" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.directories = [
      ".cache/mozilla"
      ".mozilla"
    ];

    programs.firefox = {
      enable = true;
    };
  };
}
