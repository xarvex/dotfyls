{ config, lib, ... }:

{
  imports = [
    ./discord.nix
    ./matrix.nix
    ./signal.nix
    ./zulip.nix
  ];

  options.dotfyls.social.enable = lib.mkEnableOption "social media applications" // {
    default = config.dotfyls.desktops.enable;
  };
}
