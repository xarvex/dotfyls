{
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
    dotfyls.file."/etc/persistwd/shadow" = {
      mode = "0000";
      persist = true;
    };

    security.shadow.persistwd.enable = true;

    users = {
      mutableUsers = false;
      users = {
        root = {
          initialPassword = "password";
          hashedPasswordFile = "/etc/persistwd/shadow/root";
        };

        ${user} = {
          isNormalUser = true;
          initialPassword = "password";
          hashedPasswordFile = "/etc/persistwd/shadow/${user}";
          extraGroups = [
            "networkmanager"
            "wheel"
          ];
        };
      };
    };
  };
}
