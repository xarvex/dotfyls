{ config, user, ... }:

let
  cfg = config.dotfyls.persist;
  hmCfg = config.hm.dotfyls.persist;
in
{
  environment.persistence = {
    "/persist" = {
      hideMounts = true;
      files = cfg.files;
      directories = cfg.directories;
      users.${user} = {
        files = hmCfg.files;
        directories = hmCfg.directories;
      };
    };

    "/persist/cache" = {
      hideMounts = true;
      files = cfg.cacheFiles;
      directories = cfg.cacheDirectories;
      users.${user} = {
        files = hmCfg.cacheFiles;
        directories = hmCfg.cacheDirectories;
      };
    };
  };
}
