{ pkgs }:

{
  dotfyls-install = pkgs.callPackage ./dotfyls-install { };
  dotfyls-pamu2fcfg = pkgs.callPackage ./dotfyls-pamu2fcfg { };
}
