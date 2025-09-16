{
  config,
  lib,
  osConfig ? null,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.pipewire;
  osCfg = if osConfig == null then null else osConfig.dotfyls.media.pipewire;

  jsonFormat = pkgs.formats.json { };

  # From: https://github.com/NixOS/nixpkgs/blob/c23193b943c6c689d70ee98ce3128239ed9e32d1/nixos/modules/services/desktops/pipewire/wireplumber.nix#L31-L37
  configSectionsToConfFile =
    path: value:
    pkgs.writeTextDir path (
      builtins.concatStringsSep "\n" (
        lib.mapAttrsToList (section: content: "${section} = " + (builtins.toJSON content)) value
      )
    );
  # Adapted: https://github.com/NixOS/nixpkgs/blob/c23193b943c6c689d70ee98ce3128239ed9e32d1/nixos/modules/services/desktops/pipewire/wireplumber.nix#L39-L43
  mapConfigToFiles =
    config:
    lib.mapAttrs' (
      name: value:
      lib.nameValuePair "wireplumber/wireplumber.conf.d/${name}.conf" {
        source =
          let
            path = "share/wireplumber/wireplumber.conf.d/${name}.conf";
          in
          "${configSectionsToConfFile path value}/${path}";
      }
    ) config;
in
{
  options.dotfyls.media.pipewire = {
    enable = lib.mkEnableOption "PipeWire" // {
      default = if osCfg == null then config.dotfyls.desktops.enable else osCfg.enable;
    };

    wireplumber.extraConfig = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf jsonFormat.type);
      default = { };
      description = "See NixOS option `services.pipewire.wireplumber.extraConfig`.";
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".local/state/wireplumber" = {
      mode = "0700";
      cache = true;
    };

    xdg.configFile = mapConfigToFiles cfg.wireplumber.extraConfig;

    wayland.windowManager.hyprland.settings =
      let
        wpctl =
          if osConfig != null && osConfig.home-manager.useGlobalPkgs then
            self.lib.getCfgExe' osConfig.services.pipewire.wireplumber "wpctl"
          else
            "${lib.optionalString (!config.targets.genericLinux.enable) "/run/current-system/sw/bin/"}wpctl";
      in
      {
        bindl = [
          ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ];
        bindle = [
          ", XF86AudioLowerVolume, exec, ${wpctl} set-volume --limit 1 @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume --limit 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ];
      };
  };
}
