{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.display-managers;
  cfg = cfg'.greetd;
in
{
  imports = [
    ./agreety.nix
    ./tuigreet.nix
  ];

  options.dotfyls.display-managers.greetd = {
    enable = lib.mkEnableOption "greetd";
    provider = lib.mkOption {
      type = lib.types.enum [
        "agreety"
        "tuigreet"
      ];
      default = "tuigreet";
      example = "agreety";
      description = "Greeter to use for greetd.";
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.display-managers.greetd.greeter = self.lib.enableSelected cfg.provider [
      "agreety"
      "tuigreet"
    ];

    services.greetd.enable = true;

    security.pam.services.greetd.u2fAuth = config.security.pam.services.login.u2fAuth;

    # https://github.com/apognu/tuigreet/issues/68#issuecomment-1586359960
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
