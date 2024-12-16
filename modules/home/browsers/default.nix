{
  config,
  lib,
  self,
  ...
}:

{
  imports = [
    ./firefox

    (self.lib.mkSelectorModule
      [
        "dotfyls"
        "browsers"
      ]
      {
        name = "default";
        default = "firefox";
        example = "firefox";
        description = "Default browser to use.";
      }
    )
  ];

  options.dotfyls.browsers.enable = lib.mkEnableOption "browsers" // {
    default = config.dotfyls.desktops.enable;
  };
}
