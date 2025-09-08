{ config, inputs, ... }:

let
  inherit (config.dotfyls.meta) user;
in
{
  imports = [ inputs.persistwd.nixosModules.persistwd ];

  config = {
    dotfyls.file.${config.security.shadow.persistwd.directory} = {
      mode = "0000";
      persist = true;
    };

    security.shadow.persistwd = {
      enable = true;

      users = [
        "root"
        user
      ];
    };

    users = {
      mutableUsers = false;
      users.${user} = {
        inherit (config.dotfyls.meta) home;
        isNormalUser = true;
      };
      groups.wheel.members = [ user ];
    };
  };
}
