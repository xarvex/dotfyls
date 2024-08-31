{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.gnupg;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "gnupg"
      ]
      [
        "programs"
        "gpg"
      ]
    )
    (self.lib.mkAliasOptionModules
      [
        "dotfyls"
        "programs"
        "gnupg"
        "agent"
      ]
      [
        "services"
        "gpg-agent"
      ]
      [ "pinentryPackage" ]
    )
  ];

  options.dotfyls.programs.gnupg = {
    enable = lib.mkEnableOption "GnuPG" // {
      default = config.dotfyls.desktops.enable;
    };
    agent.enable = lib.mkEnableOption "GnuPG agent" // {
      default = config.dotfyls.desktops.enable;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        dotfyls.persist.directories = [ ".local/share/gnupg" ];

        programs.gpg = {
          enable = true;
          homedir = "${config.xdg.dataHome}/gnupg";
        };
      }

      (lib.mkIf cfg.agent.enable {
        dotfyls.programs.gnupg.agent.pinentryPackage = lib.mkDefault pkgs.pinentry-qt;

        services.gpg-agent = lib.mkIf cfg.agent.enable {
          enable = true;
          enableSshSupport = true;
        };
      })
    ]
  );
}
