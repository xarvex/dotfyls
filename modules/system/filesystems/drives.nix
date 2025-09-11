{
  config,
  lib,
  pkgs,
  self,
  utils,
  ...
}:

let
  cfg = config.dotfyls.filesystems.drives;

  inherit (config.dotfyls.meta) home;
in
{
  imports = [ self.nixosModules.filesystems_drives ];

  config = lib.mkMerge [
    (
      let
        id = "1tb-samsung-pssd-t9";
        drive = cfg.${id};
      in
      lib.mkIf drive.enable {
        dotfyls.filesystems.xfs.enable = true;

        systemd.services."dotfyls-after-mount-${id}" =
          let
            mount = "${utils.escapeSystemdPath drive.mountpoint}.mount";
          in
          {
            description = "dotfyls - After-mount Unit for Extra Drive (${id})";
            after = [ mount ];
            wants = [ mount ];

            serviceConfig = {
              Type = "oneshot";
              ExecStart = [
                "${lib.getExe' pkgs.coreutils "chmod"} -R u=rwX,g=,o= ${drive.mountpoint}"
                "${lib.getExe' pkgs.coreutils "chown"} -R ${config.dotfyls.meta.user}:${config.dotfyls.meta.group} ${drive.mountpoint}"
              ];
            };

            wantedBy = [ mount ];
          };

        fileSystems =
          let
            commonOptions = [
              "nofail"
              "x-systemd.automount"
              "x-systemd.idle-timeout=5m"
            ];
          in
          {
            ${drive.mountpoint} = {
              inherit (drive) label;
              fsType = "xfs";
              options = [
                "noatime"
                "x-systemd.device-timeout=5s"
              ]
              ++ commonOptions;
            };
          }
          // (builtins.listToAttrs (
            map
              (
                mountpoint:
                lib.nameValuePair "${home}/${mountpoint}" {
                  device = "${drive.mountpoint}/${mountpoint}";
                  options = [
                    "bind"
                    "X-fstrim.notrim"
                    "x-gvfs-hide"
                  ]
                  ++ commonOptions;
                  depends = [ drive.mountpoint ];
                }
              )
              [
                "Documents/ISO"
                "Videos/Movies"
                "Videos/Shows"
              ]
          ));
      }
    )
  ];
}
