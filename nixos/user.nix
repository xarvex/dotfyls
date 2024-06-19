{ user, ... }:

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
