{ lib, user, ... }:

{
  options.warnings = lib.mkOption {
    apply = lib.filter (
      w: !(lib.strings.hasInfix "The options silently discard others by the order of precedence" w)
    );
  };

  config = {
    users = {
      mutableUsers = false;
      users = {
        root = {
          initialPassword = "password";
          hashedPasswordFile = "/persist/etc/shadow/root";
        };

        ${user} = {
          isNormalUser = true;
          initialPassword = "password";
          hashedPasswordFile = "/persist/etc/shadow/${user}";
          extraGroups = [ "networkmanager" "wheel" ];
        };
      };
    };
  };
}
