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
        startCommand = self.lib.mkCommandOption "start ${greeter.name}";
      })
      {
        agreety = {
          name = "agreety";
          specialArgs.startCommand.default = "${self.lib.getCfgExe' cfg "agreety"} --cmd ${cfg.startCommand}";
        };
        tuigreet =
          let
            tCfg = cfg.greeter.greeter.tuigreet;

            mkSystemctlCommand = verb: pkgs.dotfyls.mkCommand {
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
              shutdownCommand = self.lib.mkCommandOption "shutdown for tuigreet"
                // { default = mkSystemctlCommand "poweroff"; };
              rebootCommand = self.lib.mkCommandOption "reboot for tuigreet"
                // { default = mkSystemctlCommand "reboot"; };
              startCommand.default = pkgs.dotfyls.mkCommand ''
                ${self.lib.getCfgExe tCfg} --cmd ${lib.getExe cfg.startCommand} \
                --power-shutdown ${lib.getExe tCfg.shutdownCommand} \
                --power-reboot ${lib.getExe tCfg.rebootCommand} \
                --time --user-menu \
                --theme '${tCfg.theme}'
              '';
            };
          };
      })
  ];

  options.dotfyls.displayManager.displayManager.greetd = {
    enable = lib.mkEnableOption "greetd";
    startCommand = self.lib.mkCommandOption "start default session"
      // { default = pkgs.dotfyls.mkCommand "exec ${lib.getExe config.dotfyls.desktops.startCommand} > /dev/null"; };
  };

  config = lib.mkIf (config.dotfyls.displayManager.enable && cfg.enable) {
    services.greetd = {
      enable = true;
      settings.default_session.command = lib.getExe cfg.greeter.selected.startCommand;
    };
  };
}
