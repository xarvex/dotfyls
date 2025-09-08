{ pkgs }:

{
  dotfyls-hyprsol = pkgs.callPackage ./dotfyls-hyprsol { };
  dotfyls-install = pkgs.callPackage ./dotfyls-install {
    git = pkgs.gitMinimal;
    util-linux = pkgs.util-linuxMinimal;
  };
  dotfyls-nm-radio-toggle = pkgs.callPackage ./dotfyls-nm-radio-toggle { };
  dotfyls-nrepl = pkgs.callPackage ./dotfyls-nrepl { };
  dotfyls-pamu2fcfg = pkgs.callPackage ./dotfyls-pamu2fcfg { };
  dotfyls-proton-forward = pkgs.callPackage ./dotfyls-proton-forward { };
  dotfyls-qbittorrent-proton-forward = pkgs.callPackage ./dotfyls-qbittorrent-proton-forward { };

  mpv-sub-select = pkgs.mpvScripts.callPackage ./mpv-sub-select.nix { };
}
