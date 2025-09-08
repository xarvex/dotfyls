{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.security.proton;
  hmCfg = config.hm.dotfyls.security.proton;
in
{
  options.dotfyls.security.proton = {
    enable = lib.mkEnableOption "Proton" // {
      default = hmCfg.enable;
    };
    vpn.enable = lib.mkEnableOption "Proton VPN" // {
      default = hmCfg.vpn.enable;
    };
  };

  config = lib.mkIf (cfg.enable && cfg.vpn.enable) {
    security.wrappers.proton-forward = {
      source = lib.getExe self.packages.${pkgs.system}.dotfyls-proton-forward;
      owner = "root";
      group = "networkmanager";
      permissions = "u+rx,g+x";
      capabilities = "cap_net_admin+p";
    };

    networking = {
      firewall.extraInputRules = ''
        iifname "proton0" tcp dport @proton0-forwarded-ports accept comment "Proton VPN forwarded port (TCP)"
      '';
      nftables.tables.nixos-fw.content = lib.mkBefore ''
        set proton0-forwarded-ports {
            type inet_service
            comment "Proton VPN forwarded ports"
        }
      '';
    };

    systemd.user = {
      services.dotfyls-proton-vpn-port-forward = {
        description = "dotfyls - Proton VPN Allow Port Forward";
        after = [ "nftables.service" ];
        wants = [ "nftables.service" ];
        partOf = [ "nftables.service" ];
        unitConfig.ConditionGroup = "networkmanager";

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "/run/wrappers/bin/proton-forward";
        };

        wantedBy = [ "default.target" ];
      };
      paths.dotfyls-proton-vpn-port-forward = {
        description = "dotfyls - Proton VPN Allow Port Forward";

        pathConfig = {
          PathChanged = "%t/Proton/VPN/forwarded_port";
          Unit = "dotfyls-proton-vpn-port-forward.service";
        };

        wantedBy = [ "default.target" ];
      };
    };
  };
}
