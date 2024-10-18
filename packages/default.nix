{ pkgs }:

{
  dotfyls-install = pkgs.callPackage ./dotfyls-pamu2fcfg { };
  dotfyls-pamu2fcfg = pkgs.callPackage ./dotfyls-pamu2fcfg { };
}
