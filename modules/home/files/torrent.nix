{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.files.torrent;

  iniFormat = pkgs.formats.ini { };
  jsonFormat = pkgs.formats.json { };

  confPath = "${config.xdg.configHome}/qBittorrent/qBittorrent.conf";
in
{
  options.dotfyls.files.torrent.enable = lib.mkEnableOption "qBittorrent" // {
    default = config.dotfyls.desktops.enable && config.dotfyls.security.proton.vpn.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file = {
      ".local/share/qBittorrent".cache = true;
      ".local/share/qBittorrent/BT_backup".sync = {
        enable = true;
        rescan = 0;
        watch.delay = 15 * 60;
        order = "newestFirst";
      };
    };

    home.packages = with pkgs; [ qbittorrent ];

    xdg.configFile."qBittorrent/categories.json".source = jsonFormat.generate "qbittorrent-categories" {
      Music.save_path = config.xdg.userDirs.music;

      Videos.save_path = config.xdg.userDirs.videos;
      "Videos/Movies".save_path = "${config.xdg.userDirs.videos}/Movies";
      "Videos/Shows".save_path = "${config.xdg.userDirs.videos}/Shows";
    };

    systemd.user = {
      tmpfiles.rules =
        let
          conf = iniFormat.generate "qbittorrent-conf" (
            lib.recursiveUpdate
              {
                BitTorrent = {
                  "Session\\AddExtensionToIncompleteFiles" = true;
                  "Session\\AnonymousModeEnabled" = true;
                  "Session\\AsyncIOThreadsCount" = 4 * config.dotfyls.meta.hardware.threads;
                  "Session\\DisableAutoTMMByDefault" = false;
                  "Session\\Encryption" = 1;
                  "Session\\FinishedTorrentExportDirectory" = "${config.xdg.userDirs.documents}/Sources";
                  "Session\\GlobalMaxRatio" = 1;
                  "Session\\SubcategoriesEnabled" = true;
                  "Session\\TorrentStopCondition" = "FilesChecked";
                };

                LegalNotice.Accepted = true;

                Meta.MigrationVersion = 8;

                Network.PortForwardingEnabled = false;

                Preferences = {
                  "Advanced\\useSystemIconTheme" = true;
                  "General\\PreventFromSuspendWhenDownloading" = true;
                };
              }
              (
                lib.optionalAttrs config.dotfyls.security.proton.vpn.enable {
                  BitTorrent = {
                    "Session\\Interface" = "proton0";
                    "Session\\InterfaceName" = "proton0";
                  };

                  Preferences = {
                    "WebUI\\Address" = "127.0.0.1";
                    "WebUI\\Enabled" = true;
                    "WebUI\\LocalHostAuth" = false;
                    "WebUI\\Password_PBKDF2" = # hunter2
                      ''"@ByteArray(fzEuBPehcOL0RcEycanV9w==:E0NCxjl0PkcNsuZ7r5j4RgwNOBfiqpZa7ELsjV2nD2kN5EWfB1UR4hGUPVsgxa8TAgbbe2pbr10AO4tdVqY3dA==)"'';
                    "WebUI\\Port" = 8681;
                  };
                }
              )
          );
        in
        [ "C+ '${confPath}' 0644 - - - ${lib.strings.escapeC [ "\t" "\n" "\r" " " "\\" ] "${conf}"}" ];
    }
    // lib.optionalAttrs config.dotfyls.security.proton.vpn.enable {
      services.dotfyls-qbittorrent-proton-vpn-port = {
        Unit = {
          Description = "dotfyls - qBittorrent / Proton VPN Port";
          After = [ "nftables.service" ];
          Wants = [ "nftables.service" ];
          PartOf = [ "nftables.service" ];
        };

        Service = {
          Type = "oneshot";
          ExecStart = lib.getExe self.packages.${pkgs.system}.dotfyls-qbittorrent-proton-forward;
        };

        Install.WantedBy = [ "default.target" ];
      };
      paths.dotfyls-qbittorrent-proton-vpn-port = {
        Unit.Description = "dotfyls - qBittorrent / Proton VPN Port";

        Path = {
          PathChanged = "%t/Proton/VPN/forwarded_port";
          Unit = "dotfyls-qbittorrent-proton-vpn-port.service";
        };

        Install.WantedBy = [ "default.target" ];
      };
    };

    wayland.windowManager.hyprland.settings.windowrule = [
      "tag +dialog, class:${lib.escapeRegex "org.qbittorrent.qBittorrent"}, floating:1"

      "noscreenshare, class:${lib.escapeRegex "org.qbittorrent.qBittorrent"}"
    ];
  };
}
