{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.security.ssh;
in
{
  imports = [ (self.lib.mkAliasPackageModule [ "dotfyls" "security" "ssh" ] [ "programs" "ssh" ]) ];

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

    programs.ssh.enable = true;

    services.ssh-agent.enable = lib.mkIf cfg.agent.enable true;
  };
}
