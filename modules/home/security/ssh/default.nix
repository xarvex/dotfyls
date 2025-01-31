{ config, lib, ... }:

let
  cfg = config.dotfyls.security.ssh;
in
{
  options.dotfyls.security.ssh = {
    enable = lib.mkEnableOption "OpenSSH" // {
      default = config.dotfyls.desktops.enable;
    };
    agent.enable = lib.mkEnableOption "OpenSSH agent" // {
      default = config.dotfyls.desktops.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file.".ssh" = {
      mode = "0700";
      persist = true;
    };

    programs.ssh = {
      enable = true;

      userKnownHostsFile = builtins.concatStringsSep " " [
        "${config.xdg.configHome}/ssh/known_hosts"
        "${config.xdg.configHome}/ssh/known_hosts_generated"
      ];
    };

    services.ssh-agent.enable = lib.mkIf cfg.agent.enable true;

    xdg.configFile."ssh/known_hosts_generated".source = ./known_hosts;
  };
}
