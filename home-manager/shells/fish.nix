{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.shells;
  cfg = cfg'.shells.fish;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "shells"
        "shells"
        "fish"
      ]
      [
        "programs"
        "fish"
      ]
    )
  ];

  options.dotfyls.shells.shells.fish.enable = lib.mkEnableOption "Fish";

  config = lib.mkIf cfg.enable {
    dotfyls.persist.directories = [ ".local/share/fish" ];

    home.packages = with pkgs.fishPlugins; [
      sponge
      transient-fish
    ];

    programs.fish = {
      enable = true;

      shellInit = ''
        set fish_greeting
      '';
      shellAbbrs = config.home.shellAliases;
      interactiveShellInit = ''
        fish_vi_key_bindings

        ${cfg'.finalInitBins}
      '';
    };
  };
}
