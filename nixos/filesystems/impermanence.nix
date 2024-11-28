{
  config,
  lib,
  user,
  ...
}:

let
  cfg = config.dotfyls.filesystems.impermanence;

  fCfg = config.dotfyls.files;
  fHmCfg = config.hm.dotfyls.files;
in
{
  options.dotfyls.filesystems.impermanence = {
    enable = lib.mkEnableOption "filesystem impermanence" // {
      default = true;
    };
    tmpfsRoot = lib.mkEnableOption "filesystem impermanence tmpfs root" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence = {
      "/persist" = {
        hideMounts = true;

        files = fCfg.persistFiles;
        directories = fCfg.persistDirectories;

        users.${user} = {
          files = fHmCfg.persistFiles;
          directories = fHmCfg.persistDirectories;
        };
      };

      "/cache" = {
        hideMounts = true;

        files = fCfg.cacheFiles;
        directories = fCfg.cacheDirectories;

        users.${user} = {
          files = fHmCfg.cacheFiles;
          directories = fHmCfg.cacheDirectories;
        };
      };
    };

    # sudo cannot store that it has been ran.
    security.sudo.extraConfig = "Defaults lecture=never";

    fileSystems = {
      "/" = lib.mkIf cfg.tmpfsRoot {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [
          "defaults"
          "size=1G"
          "mode=755"
        ];
        neededForBoot = true;
      };
      "/persist".neededForBoot = true;
      "/cache".neededForBoot = true;
    };
  };
}
