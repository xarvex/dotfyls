{
  config,
  inputs,
  lib,
  self,
  user,
  ...
}:

{
  imports = [
    inputs.persistwd.nixosModules.persistwd

    (self.lib.mkAliasPackageModule
      [ "dotfyls" "users" "persistwd" ]
      [ "security" "shadow" "persistwd" ]
    )
  ];

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
      volume = lib.mkIf config.dotfyls.files.systems.impermanence.enable "/persist";
    };

    users = {
      mutableUsers = false;
      users = {
        ${user} = {
          isNormalUser = true;
          extraGroups = [
            "networkmanager"
            "wheel"
          ];
        };
      };
    };
  };
}
