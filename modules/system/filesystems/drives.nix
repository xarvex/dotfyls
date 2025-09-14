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
  withDrive = id: fn: lib.mkIf cfg.${id}.enable (fn cfg.${id});
in
{
  imports = [ self.nixosModules.filesystems_drives ];

  config = lib.mkMerge [
    (withDrive "1tb-samsung-pssd-t9" (drive: {
      systemd.services."dotfyls-after-mount-${lib.strings.sanitizeDerivationName drive.id}" =
        let
          mount = "${utils.escapeSystemdPath drive.mountpoint}.mount";
        in
        {
          description = "dotfyls - After-mount Unit for Extra Drive (${drive.id})";
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
                fsType = "none";
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
    }))
  ];
}
