{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.ssh;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "ssh"
      ]
      [
        "programs"
        "ssh"
      ]
    )
  ];

  options.dotfyls.programs.ssh = {
    enable = lib.mkEnableOption "OpenSSH" // {
      default = config.dotfyls.desktops.enable;
    };
    agent.enable = lib.mkEnableOption "OpenSSH agent" // {
      default = config.dotfyls.desktops.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.directories = [ ".ssh" ];

    programs.ssh.enable = true;

    services.ssh-agent.enable = lib.mkIf cfg.agent.enable true;
  };
}
