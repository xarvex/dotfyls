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
        agreety.enable = lib.mkEnableOption "greetd greeter";
        tuigreet.enable = lib.mkEnableOption "tuigreet greeter";
      };
    };
  };

  config = let cfg = config.dotfyls.displayManager.displayManager.greetd; in lib.mkIf (config.dotfyls.displayManager.enable && cfg.enable) (
    let
      greeters = {
        agreety.command = "${pkgs.greetd.greetd}/bin/agreety --cmd dotfyls-desktop";
        tuigreet.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd dotfyls-desktop --time --user-menu";
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
