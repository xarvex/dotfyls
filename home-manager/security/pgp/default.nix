{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.security.pgp;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "security"
        "pgp"
      ]
      [
        "programs"
        "gpg"
      ]
    )
    (self.lib.mkAliasOptionModules
      [
        "dotfyls"
        "security"
        "pgp"
        "agent"
      ]
      [
        "services"
        "gpg-agent"
      ]
      [ "pinentryPackage" ]
    )
  ];

  options.dotfyls.security.pgp = {
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

          scdaemonSettings.disable-ccid = true;
        };
      }

      (lib.mkIf cfg.agent.enable {
        dotfyls.security.pgp.agent.pinentryPackage = lib.mkDefault pkgs.pinentry-qt;

        services.gpg-agent = {
          enable = true;

          maxCacheTtl = 0;
          maxCacheTtlSsh = 0;
        };
      })
    ]
  );
}
