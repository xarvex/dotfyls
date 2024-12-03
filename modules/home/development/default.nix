{
  config,
  inputs,
  lib,
  ...
}:

{
  imports = [
    inputs.wherenver.homeManagerModules.wherenver

    ./direnv
    ./languages
  ];

  options.dotfyls.development.enable = lib.mkEnableOption "development" // {
    default = config.dotfyls.desktops.enable;
  };
}
