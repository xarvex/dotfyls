{
  config,
  lib,
  user,
  ...
}:

let
  cfg = config.dotfyls.filesystems.impermanence;

  # TODO: Replace with pipe operator.
  mkPersistenceEntry =
    attr: dir: cfg:
    lib.pipe cfg (
      [
        (lib.filterAttrs (_: fCfg: (dir == fCfg.dir) && fCfg.${attr}))
      ]
      ++ (
        if dir then
          [
            (lib.mapAttrsToList (
              file: config: {
                directory = file;
                inherit (config) mode;
              }
            ))
          ]
        else
          [ builtins.attrNames ]
      )
    );
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

        files = mkPersistenceEntry "persist" false config.dotfyls.files;
        directories = mkPersistenceEntry "persist" true config.dotfyls.files;

        users.${user} = {
          files = mkPersistenceEntry "persist" false config.hm.dotfyls.files;
          directories = mkPersistenceEntry "persist" true config.hm.dotfyls.files;
        };
      };

      "/cache" = {
        hideMounts = true;

        files = mkPersistenceEntry "cache" false config.dotfyls.files;
        directories = mkPersistenceEntry "cache" true config.dotfyls.files;

        users.${user} = {
          files = mkPersistenceEntry "cache" false config.hm.dotfyls.files;
          directories = mkPersistenceEntry "cache" true config.hm.dotfyls.files;
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
