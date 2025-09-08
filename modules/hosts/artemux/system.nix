{ lib, pkgs, ... }:

{
  dotfyls = {
    meta = {
      machine.type = "laptop";
      hardware.threads = 8;
    };

    boot = {
      kernel.variant = "xanmod";
      console = {
        efi = {
          width = 1920;
          height = 1080;
        };
        displays = rec {
          eDP-1 = {
            width = 1920;
            height = 1200;
            refresh = 60;
          };
          HDMI-A-1 = {
            width = 1920;
            height = 1080;
            refresh = 75;
          };
          DP-3 = HDMI-A-1;
        };
      };
    };

    filesystems.drives."1tb-samsung-pssd-t9".enable = true;

    graphics = {
      provider = "intel";
      intel.forceFullRGB = [
        322
        356
      ];
    };
  };

  environment.systemPackages = [
    (pkgs.writers.writeDashBin "temp-no-dnscrypt" ''
      current_system=$(${lib.getExe' pkgs.coreutils "readlink"} -f /run/current-system)
      no_dnscrypt_system=$(${lib.getExe' pkgs.coreutils "readlink"} -f /run/current-system/specialisation/no-dnscrypt)

      if [ "''${current_system}" != "''${no_dnscrypt_system}" ]; then
          sudo "''${no_dnscrypt_system}"/bin/switch-to-configuration test
            ${lib.getExe' pkgs.coreutils "sleep"} 10
          sudo "''${current_system}"/bin/switch-to-configuration test
      fi
    '')
  ];

  specialisation.no-dnscrypt.configuration.dotfyls.networking.dnscrypt.enable = false;
}
