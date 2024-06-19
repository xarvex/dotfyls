{ config, user, ... }:

let
  cfg = config.custom.persist;
  hmCfg = config.hm.custom.persist;
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
