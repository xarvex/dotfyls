{
  config,
  lib,
  user,
  ...
}:

let
  cfg = config.dotfyls.filesystems.impermanence;

  pCfg = config.dotfyls.persist;
  pHmCfg = config.hm.dotfyls.persist;
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
        inherit (pCfg) files directories;

        hideMounts = true;
        users.${user} = {
          inherit (pHmCfg) files directories;
        };
      };

      "/cache" = {
        hideMounts = true;
        files = pCfg.cacheFiles;
        directories = pCfg.cacheDirectories;
        users.${user} = {
          files = pHmCfg.cacheFiles;
          directories = pHmCfg.cacheDirectories;
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
