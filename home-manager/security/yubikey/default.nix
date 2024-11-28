{ config, lib, ... }:

let
  cfg = config.dotfyls.security.yubikey;
in
{
  imports = [
    ./yubioath.nix
  ];

  options.dotfyls.security.yubikey = {
    enable = lib.mkEnableOption "YubiKey" // {
      default = true;
    };
    enableGitIntegration = lib.mkEnableOption "YubiKey Git integration" // {
      default = config.dotfyls.programs.git.enable;
    };
    enableSshIntegration = lib.mkEnableOption "YubiKey OpenSSH integration" // {
      default = config.dotfyls.security.ssh.enable;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        dotfyls.files.persistDirectories = [ ".config/Yubico" ];
      }

      (lib.mkIf cfg.enableGitIntegration { dotfyls.programs.git.key = "0046A18B1037C201"; })

      (lib.mkIf cfg.enableSshIntegration {
        dotfyls.files.cacheDirectories = [ ".local/share/yubigen/ssh" ];

        programs.yubigen = {
          enable = true;
          enableSshIntegration = true;
        };
      })
    ]
  );
}
