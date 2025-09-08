{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.security.proton;
  cfg = cfg'.pass;
in
{
  options.dotfyls.security.proton.pass.enable = lib.mkEnableOption "Proton Pass" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".config/Proton Pass" = {
      mode = "0700";
      cache = true;
    };

    home.packages = with pkgs; [ proton-pass ];

    wayland.windowManager.hyprland.settings.windowrule = [ "noscreenshare, class:Proton Pass" ];
  };
}
