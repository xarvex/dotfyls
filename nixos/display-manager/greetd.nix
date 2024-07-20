{ config, lib, pkgs, ... }:

{
  options.dotfyls.displayManager.displayManager.greetd = {
    enable = lib.mkEnableOption "greetd";
    greeters = {
      provider = lib.mkOption {
        type = lib.types.enum [ "agreety" "tuigreet" ];
        default = "tuigreet";
        example = "tuigreet";
        description = "Greeter to use.";
      };
      greeters = {
        agreety.enable = lib.mkEnableOption "agreety greeter";
        tuigreet.enable = lib.mkEnableOption "tuigreet greeter";
      };
    };
  };

  config = let cfg = config.dotfyls.displayManager.displayManager.greetd; in lib.mkIf (config.dotfyls.displayManager.enable && cfg.enable) (
    let
      command = pkgs.lib.dotfyls.mkCommandExe "exec ${lib.getExe config.dotfyls.desktops.launchCommand} > /dev/null";
      mkSystemctlCommand = verb: pkgs.lib.dotfyls.mkCommandExe {
        runtimeInputs = with pkgs; [ systemd ];
        text = "systemctl ${verb}";
      };

      greeters = {
        agreety.command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${command}";
        tuigreet.command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet --cmd ${command} \
            --power-shutdown ${mkSystemctlCommand "poweroff"} \
            --power-reboot ${mkSystemctlCommand "reboot"} \
            --time --user-menu \
            --theme 'text=cyan;border=magenta;prompt=green'
        '';
      };
    in
    {
      services.greetd = {
        enable = true;
        settings.default_session = greeters.${cfg.greeters.provider};
      };
    }
  );
}
