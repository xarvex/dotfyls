{ lib, ... }: {
  dotfyls.terminals.alacritty.enable = true;

  wayland.windowManager.hyprland.settings = {
    animations.enabled = lib.mkForce false;
    decoration = {
      blur.enabled = lib.mkForce false;
      drop_shadow = lib.mkForce false;
    };
  };
}
