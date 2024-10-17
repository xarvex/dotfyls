{ config, lib, ... }:

let
  cfg = config.dotfyls.security.yubikey;
in
{
  imports = [
    ./yubioath.nix
  ];

  options.dotfyls.security.yubikey.enable = lib.mkEnableOption "YubiKey" // {
    default = true;
  };

  config = lib.mkIf cfg.enable { dotfyls.persist.directories = [ ".config/Yubico" ]; };
}
