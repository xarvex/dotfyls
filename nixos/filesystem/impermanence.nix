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
      directories = cfg.cache;
      users.${user}.directories = hmCfg.cache;
    };
  };
}
