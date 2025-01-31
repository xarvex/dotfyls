{
  config,
  lib,
  osConfig ? null,
  ...
}:

{
  imports = [ ./applet.nix ];

  options.dotfyls.networking.enable = lib.mkEnableOption "networking" // {
    default =
      if (osConfig == null) then config.dotfyls.desktops.enable else osConfig.dotfyls.networking.enable;
  };
}
