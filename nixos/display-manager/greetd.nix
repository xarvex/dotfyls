{ config, lib, pkgs, self, ... }:

let
  cfg = config.dotfyls.displayManager.displayManager.greetd;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "displayManager" "displayManager" "greetd" ]
      [ "services" "greetd" ])

    (self.lib.mkSelectorModule [ "dotfyls" "displayManager" "displayManager" "greetd" "greeter" ]
      {
        name = "provider";
        default = "tuigreet";
        description = "Greeter to use for greetd.";
      }
      {
        agreety = "agreety";
        tuigreet = "tuigreet";
      })

    (self.lib.mkCommonModules [ "dotfyls" "displayManager" "displayManager" "greetd" "greeter" "greeter" ]
      (greeter: gCfg: {
        startCommand = pkgs.lib.dotfyls.mkCommandOption "start ${greeter.name}";
      })
      {
        agreety = {
          name = "agreety";
          specialArgs.startCommand.default = "${lib.getExe' cfg.package "agreety"} --cmd ${cfg.launchCommand}";
        };
        tuigreet =
          let
            cfg' = cfg.greeter.greeter.tuigreet;

            mkSystemctlCommand = verb: pkgs.lib.dotfyls.mkCommand {
              runtimeInputs = with pkgs; [ systemd ];
              text = "systemctl ${verb}";
            };
          in
          {
            name = "tuigreet";
            specialArgs = {
              package = lib.mkPackageOption pkgs [ "greetd" "tuigreet" ] { };
              theme = lib.mkOption {
                type = lib.types.str;
                default = "text=cyan;border=magenta;prompt=green";
                example = "text=cyan;border=magenta;prompt=green";
                description = "Theme used for tuigreet.";
              };
              shutdownCommand = pkgs.lib.dotfyls.mkCommandOption "shutdown for tuigreet"
                // { default = mkSystemctlCommand "poweroff"; };
              rebootCommand = pkgs.lib.dotfyls.mkCommandOption "reboot for tuigreet"
                // { default = mkSystemctlCommand "reboot"; };
              startCommand.default = pkgs.lib.dotfyls.mkCommand ''
                ${lib.getExe cfg'.package} --cmd ${lib.getExe cfg.launchCommand} \
                --power-shutdown ${lib.getExe cfg'.shutdownCommand} \
                --power-reboot ${lib.getExe cfg'.rebootCommand} \
                --time --user-menu \
                --theme '${cfg'.theme}'
              '';
            };
          };
      })
  ];

  options.dotfyls.displayManager.displayManager.greetd = {
    enable = lib.mkEnableOption "greetd";
    launchCommand = pkgs.lib.dotfyls.mkCommandOption "launch default session"
      // { default = pkgs.lib.dotfyls.mkCommand "exec ${lib.getExe config.dotfyls.desktops.launchCommand} > /dev/null"; };
  };

  config = lib.mkIf (config.dotfyls.displayManager.enable && cfg.enable) {
    services.greetd = {
      enable = true;
      settings.default_session.command = lib.getExe cfg.greeter.selected.startCommand;
    };
  };
}
