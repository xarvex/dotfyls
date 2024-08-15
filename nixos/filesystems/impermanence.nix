{ config, lib, user, ... }:

let
  cfg = config.dotfyls.filesystems.impermanence;

  pCfg = config.dotfyls.persist;
  pHmCfg = config.hm.dotfyls.persist;
in
{
  options.dotfyls.filesystems.impermanence = {
    enable = lib.mkEnableOption "filesystem impermanence" // { default = true; };
    tmpfsRoot = lib.mkEnableOption "filesystem impermanence tmpfs root" // { default = true; };
  };

  config = lib.mkIf cfg.enable {
    # sudo cannot store that it has been ran.
    security.sudo.extraConfig = "Defaults lecture=never";

    environment.persistence = {
      "/persist" = {
        hideMounts = true;
        files = pCfg.files;
        directories = pCfg.directories;
        users.${user} = {
          files = pHmCfg.files;
          directories = pHmCfg.directories;
        };
      };

      "/persist/cache" = {
        hideMounts = true;
        files = pCfg.cacheFiles;
        directories = pCfg.cacheDirectories;
        users.${user} = {
          files = pHmCfg.cacheFiles;
          directories = pHmCfg.cacheDirectories;
        };
      };
    };

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
      "/persist/cache".neededForBoot = true;
    };
  };
}
