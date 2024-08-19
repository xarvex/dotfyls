{ user, ... }:

{
  config = {
    security.shadow.persistwd.enable = true;

    users = {
      mutableUsers = false;
      users = {
        root.hashedPasswordFile = "/persist/etc/shadow/root";

        ${user} = {
          isNormalUser = true;
          hashedPasswordFile = "/persist/etc/shadow/${user}";
          extraGroups = [ "networkmanager" "wheel" ];
        };
      };
    };
  };
}
