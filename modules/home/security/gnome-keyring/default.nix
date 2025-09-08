{ config, lib, ... }:

let
  cfg = config.dotfyls.security.gnome-keyring;
in
{
  options.dotfyls.security.gnome-keyring.enable = lib.mkEnableOption "GNOME Keyring" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file.".local/share/keyrings" = {
      mode = "0700";
      persist = true;
    };

    wayland.windowManager.hyprland.settings.windowrule = [
      "tag +important-prompt, class:gcr-prompter"

      "noscreenshare, class:gcr-prompter"
      "dimaround, class:gcr-prompter, floating:1"
    ];
  };
}
