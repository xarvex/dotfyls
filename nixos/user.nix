{ config, lib, user, ... }:

{
  config = lib.mkMerge [
    {
      users = {
        mutableUsers = false;

        users = {
          root = {
            initialPassword = "password";
          };

          ${user} = {
            isNormalUser = true;
            initialPassword = "password";
            extraGroups = [ "networkmanager" "wheel" ];
          };
        };
      };
    }
  ];
}
