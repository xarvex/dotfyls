{ lib, ... }: {
  wayland.windowManager.hyprland.settings.animations.enabled = lib.mkForce false;
}
