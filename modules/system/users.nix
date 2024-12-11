{
  config,
  inputs,
  lib,
  user,
  ...
}:

{
  imports = [ inputs.persistwd.nixosModules.persistwd ];

  options.warnings = lib.mkOption {
    apply = lib.filter (
      w: !(lib.strings.hasInfix "The options silently discard others by the order of precedence" w)
    );
  };

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
        root.initialPassword = "password";

        ${user} = {
          isNormalUser = true;
          initialPassword = "password";
          extraGroups = [
            "networkmanager"
            "wheel"
          ];
        };
      };
    };
  };
}
