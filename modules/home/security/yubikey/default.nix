{
  config,
  inputs,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.security.yubikey;
in
{
  imports = [
    inputs.yubigen.homeManagerModules.yubigen

    ./yubioath.nix

    (self.lib.mkAliasPackageModule
      [ "dotfyls" "security" "yubikey" "yubigen" ]
      [ "programs" "yubigen" ]
    )
  ];

  options.dotfyls.security.yubikey = {
    enable = lib.mkEnableOption "YubiKey" // {
      default = true;
    };
    enableGitIntegration = lib.mkEnableOption "YubiKey Git integration" // {
      default = config.dotfyls.development.git.enable;
    };
    enableSshIntegration = lib.mkEnableOption "YubiKey OpenSSH integration" // {
      default = config.dotfyls.security.ssh.enable;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        dotfyls.file.".config/Yubico" = {
          mode = "0700";
          persist = true;
        };
      }

      (lib.mkIf cfg.enableGitIntegration { dotfyls.development.git.key = "0046A18B1037C201"; })

      (lib.mkIf cfg.enableSshIntegration {
        dotfyls.file.".local/share/yubigen/ssh" = {
          mode = "0700";
          persist = true;
        };

        programs.yubigen = {
          enable = true;
          enableSshIntegration = true;
        };
      })
    ]
  );
}
