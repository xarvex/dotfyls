{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.displayManager;
  cfg = cfg'.displayManager.greetd;
in
{
  imports = [
    ./greeter

    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "displayManager"
        "displayManager"
        "greetd"
      ]
      [
        "services"
        "greetd"
      ]
    )

    (self.lib.mkSelectorModule
      [
        "dotfyls"
        "displayManager"
        "displayManager"
        "greetd"
        "greeter"
      ]
      {
        name = "provider";
        default = "tuigreet";
        example = "agreety";
        description = "Greeter to use for greetd.";
      }
    )
  ];

  options.dotfyls.displayManager.displayManager.greetd.enable = lib.mkEnableOption "greetd";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
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
