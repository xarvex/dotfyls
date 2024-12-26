{ config, lib, ... }:

let
  cfg' = config.dotfyls.browsers;
  cfg = cfg'.browsers.firefox;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  programs.firefox.profiles.${config.home.username} = {
    containersForce = true;
    containers = {
      "01 - Personal" = {
        id = 1;
        color = "pink";
        icon = "fingerprint";
      };
      "02 - Development" = {
        id = 367;
        color = "blue";
        icon = "fingerprint";
      };
      "03 - Media" = {
        id = 457;
        color = "purple";
        icon = "tree";
      };
      "04 - Social" = {
        id = 455;
        color = "toolbar";
        icon = "chill";
      };
      "05 - Finance" = {
        id = 467;
        color = "green";
        icon = "dollar";
      };
      "06 - Gaming" = {
        id = 456;
        color = "turquoise";
        icon = "tree";
      };
      "07 - Shopping" = {
        id = 4;
        color = "red";
        icon = "cart";
      };
      "08 - Food" = {
        id = 458;
        color = "orange";
        icon = "food";
      };
      "10 - Services" = {
        id = 470;
        color = "yellow";
        icon = "vacation";
      };
      "20 - Work" = {
        id = 2;
        color = "green";
        icon = "briefcase";
      };
      "30 - School" = {
        id = 270;
        color = "red";
        icon = "fruit";
      };
      "80 - Alternative" = {
        id = 468;
        color = "purple";
        icon = "chill";
      };
      "90 - Family" = {
        id = 469;
        color = "blue";
        icon = "pet";
      };
      "Facebook" = {
        id = 6;
        color = "toolbar";
        icon = "fence";
      };
      "Google" = {
        id = 7;
        color = "orange";
        icon = "fence";
      };
    };
  };
}
