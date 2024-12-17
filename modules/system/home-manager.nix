{ lib, user, ... }:

{
  imports = [ (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user ]) ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
