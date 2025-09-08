{ config, lib, ... }:

{
  imports = [
    (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" config.dotfyls.meta.user ])
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
