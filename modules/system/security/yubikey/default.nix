{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.security.yubikey;
  hmCfg = config.hm.dotfyls.security.yubikey;
in
{
  imports = [
    inputs.yubigen.nixosModules.yubigen
  ];

  options.dotfyls.security.yubikey = {
    enable = lib.mkEnableOption "YubiKey" // {
      default = hmCfg.enable;
    };
    enableSshIntegration = lib.mkEnableOption "YubiKey OpenSSH integration" // {
      default = hmCfg.enableSshIntegration;
    };
    login = {
      enable = lib.mkEnableOption "login with YubiKey" // {
        default = true;
      };
      lock = lib.mkEnableOption "lock on YubiKey disconnect";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.yubigen.enableUdevRules = lib.mkIf cfg.enableSshIntegration true;

        services = {
          pcscd.enable = true;
          udev.packages = with pkgs; [ yubikey-personalization ];
        };
      }

      (lib.mkIf cfg.login.enable (
        lib.mkMerge [
          {
            environment.systemPackages = [ self.packages.${pkgs.system}.dotfyls-pamu2fcfg ];

            security.pam.services = {
              login.u2fAuth = true;
              sudo.u2fAuth = true;
            };
          }

          (lib.mkIf cfg.login.lock {
            # HACK: currently, this locks all sessions if any YubiKey is disconnected.
            services.udev.extraRules = ''
              ACTION=="remove", \
                ENV{ID_BUS}=="usb", \
                ENV{DEVTYPE}=="usb_device", \
                ENV{ID_VENDOR_ID}=="1050", \
                ENV{ID_MODEL_ID}=="0407", \
                RUN+="${lib.getExe' pkgs.systemd "loginctl"} lock-sessions"
            '';
          })
        ]
      ))
    ]
  );
}
